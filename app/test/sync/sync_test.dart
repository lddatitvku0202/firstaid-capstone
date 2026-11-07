import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app/data/datasources/local/app_database.dart';
import 'package:app/data/datasources/local/protocol_local_datasource.dart';
import 'package:app/data/datasources/local/seed_loader.dart';
import 'package:app/data/repositories/drift_protocol_sync_store.dart';
import 'package:app/data/repositories/drift_sync_queue_repository.dart';
import 'package:app/domain/entities/first_aid_protocol.dart';
import 'package:app/domain/entities/protocol_step.dart';
import 'package:app/domain/entities/source_status.dart';
import 'package:app/domain/entities/sync_job.dart';
import 'package:app/domain/services/connectivity_service.dart';
import 'package:app/domain/services/remote_sync_source.dart';
import 'package:app/domain/usecases/enqueue_sos_log.dart';
import 'package:app/domain/usecases/process_sync_queue.dart';
import 'package:app/domain/usecases/run_sync.dart';
import 'package:app/domain/usecases/sync_protocols.dart';
import 'package:app/domain/utils/version_compare.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

Future<String> _fileLoader(String path) => File(path).readAsString();

class FakeRemote implements RemoteSyncSource {
  List<FirstAidProtocol> protocols = [];
  Object? fetchError;

  /// Số lần submit đầu tiên sẽ lỗi (RemoteTransientException).
  int failFirst = 0;
  Object? submitError;
  final List<String> received = [];
  final Set<String> serverIds = {};
  int submitCalls = 0;

  @override
  Future<List<FirstAidProtocol>> fetchProtocols() async {
    if (fetchError != null) throw fetchError!;
    return protocols;
  }

  @override
  Future<void> submitJob(SyncJob job) async {
    submitCalls++;
    if (submitError != null) throw submitError!;
    if (failFirst > 0) {
      failFirst--;
      throw RemoteTransientException('mất mạng');
    }
    received.add(job.id);
    serverIds.add(job.id); // idempotent: trùng id không nhân đôi
  }
}

class FakeConn implements ConnectivityService {
  FakeConn(this.connected);
  bool connected;
  final _c = StreamController<bool>.broadcast();
  void emit(bool v) {
    connected = v;
    _c.add(v);
  }

  @override
  Future<bool> isConnected() async => connected;

  @override
  Stream<bool> get onChanged => _c.stream;
}

FirstAidProtocol proto(
  String code,
  String version, {
  ClinicalReview review = ClinicalReview.reviewed,
  SourceVerification verification = SourceVerification.verified,
  String title = 'Phác đồ từ server',
  List<ProtocolStep>? steps,
}) => FirstAidProtocol(
  code: code,
  title: title,
  topicId: 'cpr',
  severity: 'critical',
  targetAudience: 'adult',
  ageGroup: 'adult',
  version: version,
  updatedAt: '2026-11-08',
  steps:
      steps ?? [const ProtocolStep(order: 1, text: 'Bước 1', citation: 'X p1')],
  clinicalReview: review,
  sourceVerification: verification,
);

SyncJob job(String id, DateTime now) => SyncJob(
  id: id,
  kind: SyncJob.kindSosLog,
  payloadJson: '{}',
  createdAt: now,
  nextAttemptAt: now,
);

void main() {
  // Test migration mở một DB thứ hai (executor riêng) chỉ để mô phỏng DB v1.
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  final t0 = DateTime(2026, 11, 8, 10);
  late AppDatabase db;
  late DriftSyncQueueRepository queue;
  late FakeRemote remote;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    queue = DriftSyncQueueRepository(db);
    remote = FakeRemote();
  });
  tearDown(() => db.close());

  group('compareVersions', () {
    test('so sánh số, không so chuỗi', () {
      expect(compareVersions('1.0.10', '1.0.9'), greaterThan(0));
      expect(compareVersions('1.0.0', '1.0'), 0);
      expect(compareVersions('0.9.9', '1.0.0'), lessThan(0));
    });
  });

  group('SyncQueue', () {
    test('enqueue idempotent theo id', () async {
      expect(await queue.enqueue(job('a', t0)), isTrue);
      expect(await queue.enqueue(job('a', t0)), isFalse);
      expect(await queue.all(), hasLength(1));
    });

    test('backoff mũ, có trần', () {
      final p = ProcessSyncQueue(
        queue,
        remote,
        maxDelay: const Duration(minutes: 5),
      );
      expect(p.backoff(1), const Duration(seconds: 30));
      expect(p.backoff(2), const Duration(seconds: 60));
      expect(p.backoff(3), const Duration(seconds: 120));
      expect(p.backoff(10), const Duration(minutes: 5));
    });

    test('lỗi tạm thời: hẹn thử lại, chưa đến hạn thì không gửi', () async {
      await queue.enqueue(job('a', t0));
      remote.failFirst = 1;
      final p = ProcessSyncQueue(queue, remote);

      final r1 = await p(now: t0);
      expect(r1.retryLater, 1);
      expect(remote.received, isEmpty);
      final after = (await queue.all()).single;
      expect(after.attempts, 1);
      expect(after.status, SyncJobStatus.pending);
      expect(after.nextAttemptAt, t0.add(const Duration(seconds: 30)));

      // Chưa đến hạn: không gọi remote.
      final calls = remote.submitCalls;
      await p(now: t0.add(const Duration(seconds: 10)));
      expect(remote.submitCalls, calls);

      // Đến hạn: gửi thành công.
      final r2 = await p(now: t0.add(const Duration(seconds: 31)));
      expect(r2.sent, 1);
      expect(remote.received, ['a']);
      expect((await queue.all()).single.status, SyncJobStatus.done);
    });

    test('hết số lần retry => failed và không thử nữa', () async {
      await queue.enqueue(job('a', t0));
      remote.submitError = RemoteTransientException('down');
      final p = ProcessSyncQueue(queue, remote, maxAttempts: 3);
      var now = t0;
      for (var i = 0; i < 3; i++) {
        await p(now: now);
        now = now.add(const Duration(hours: 2));
      }
      final j = (await queue.all()).single;
      expect(j.status, SyncJobStatus.failed);
      expect(j.attempts, 3);
      final calls = remote.submitCalls;
      await p(now: now.add(const Duration(days: 1)));
      expect(remote.submitCalls, calls);
    });

    test('lỗi vĩnh viễn (vd. RLS từ chối): failed ngay, không retry', () async {
      await queue.enqueue(job('a', t0));
      remote.submitError = RemotePermanentException('42501');
      final r = await ProcessSyncQueue(queue, remote)(now: t0);
      expect(r.failedPermanently, 1);
      expect((await queue.all()).single.status, SyncJobStatus.failed);
    });

    test(
      'idempotency: job gửi lại cùng id không nhân đôi trên server',
      () async {
        await queue.enqueue(job('same', t0));
        final p = ProcessSyncQueue(queue, remote);
        await p(now: t0);
        // Mô phỏng ack bị mất: job quay lại pending và gửi lần nữa.
        await db.customStatement("UPDATE sync_jobs SET status = 'pending'");
        await p(now: t0);
        expect(remote.received, ['same', 'same']); // đã gửi hai lần...
        expect(remote.serverIds, {'same'}); // ...nhưng server chỉ có một bản
      },
    );

    test('offline -> online: RunSync gửi khi kết nối quay lại', () async {
      final conn = FakeConn(false);
      await queue.enqueue(job('a', t0));
      final sync = RunSync(
        connectivity: conn,
        syncProtocols: SyncProtocols(remote, DriftProtocolSyncStore(db)),
        processQueue: ProcessSyncQueue(queue, remote),
        clock: () => t0,
      );
      expect(await sync.runOnce(), isFalse); // offline: bỏ qua
      expect(remote.submitCalls, 0);
      expect((await queue.all()).single.status, SyncJobStatus.pending);

      sync.start();
      conn.emit(true);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(remote.received, ['a']);
      await sync.dispose();
    });
  });

  group('EnqueueSosLog', () {
    test('không đồng ý => không lưu gì', () async {
      final ok = await EnqueueSosLog(queue)(
        consent: false,
        id: 'x',
        deviceId: 'dev',
        now: t0,
        latitude: 16.0544,
        longitude: 108.2022,
      );
      expect(ok, isFalse);
      expect(await queue.all(), isEmpty);
    });

    test('đồng ý => lưu, vị trí làm tròn, không có ghi chú', () async {
      await EnqueueSosLog(queue)(
        consent: true,
        id: 'x',
        deviceId: 'dev',
        now: t0,
        latitude: 16.054412,
        longitude: 108.202299,
      );
      final payload = jsonDecode(
        (await queue.all()).single.payloadJson,
      ) as Map<String, dynamic>;
      expect(payload['lat'], 16.054);
      expect(payload['lon'], 108.202);
      expect(payload['consent'], true);
      expect(payload.containsKey('note'), isFalse);
    });
  });

  group('SyncProtocols (server thắng, chỉ nhận bản đã review)', () {
    late ProtocolLocalDataSource local;
    late DriftProtocolSyncStore store;

    setUp(() async {
      await SeedLoader(db, _fileLoader).seedIfNeeded();
      local = ProtocolLocalDataSource(db);
      store = DriftProtocolSyncStore(db);
    });

    test('nhận bản reviewed + verified mới hơn', () async {
      remote.protocols = [
        proto('cpr_adult_adolescent', '1.1.0', title: 'Bản server'),
      ];
      final r = await SyncProtocols(remote, store)();
      expect(r.status, SyncProtocolsStatus.updated);
      final p = await local.getProtocolByCode('cpr_adult_adolescent');
      expect(p!.version, '1.1.0');
      expect(p.title, 'Bản server');
      expect(p.clinicalReview, ClinicalReview.reviewed);
    });

    test('bản chưa review KHÔNG ghi đè bản ổn định', () async {
      final before = (await local.getProtocolByCode('cpr_adult_adolescent'))!;
      remote.protocols = [
        proto(
          'cpr_adult_adolescent',
          '9.0.0',
          review: ClinicalReview.notClinicallyReviewed,
        ),
        proto(
          'cpr_baby_child',
          '9.0.0',
          verification: SourceVerification.unverified,
        ),
      ];
      final r = await SyncProtocols(remote, store)();
      expect(r.status, SyncProtocolsStatus.upToDate);
      expect(r.skippedUnreviewed, 2);
      final after = (await local.getProtocolByCode('cpr_adult_adolescent'))!;
      expect(after.version, before.version);
      expect(after.title, before.title);
    });

    test('version bằng hoặc cũ hơn: không đổi', () async {
      remote.protocols = [proto('cpr_adult_adolescent', '1.0.0')];
      final r = await SyncProtocols(remote, store)();
      expect(r.status, SyncProtocolsStatus.upToDate);
    });

    test('sync lỗi (mất mạng): giữ bản local, không ném lỗi', () async {
      final before = await local.getAllProtocols();
      remote.fetchError = RemoteTransientException('offline');
      final r = await SyncProtocols(remote, store)();
      expect(r.status, SyncProtocolsStatus.failed);
      final after = await local.getAllProtocols();
      expect(after.map((p) => p.version), before.map((p) => p.version));
      expect(after, hasLength(before.length));
    });

    test('lỗi giữa chừng khi ghi: rollback, bản cũ còn nguyên', () async {
      final before = (await local.getProtocolByCode('cpr_adult_adolescent'))!;
      remote.protocols = [
        proto('cpr_baby_child', '1.2.0', title: 'Hợp lệ'),
        // Hai bước trùng order => vi phạm khóa chính giữa transaction.
        proto(
          'cpr_adult_adolescent',
          '1.2.0',
          title: 'Hỏng',
          steps: [
            const ProtocolStep(order: 1, text: 'a'),
            const ProtocolStep(order: 1, text: 'b'),
          ],
        ),
      ];
      final r = await SyncProtocols(remote, store)();
      expect(r.status, SyncProtocolsStatus.failed);
      final after = (await local.getProtocolByCode('cpr_adult_adolescent'))!;
      expect(after.title, before.title);
      expect(after.steps, hasLength(before.steps.length));
      // Cả bản "Hợp lệ" cũng không được ghi (toàn bộ rollback).
      expect(
        (await local.getProtocolByCode('cpr_baby_child'))!.title,
        isNot('Hợp lệ'),
      );
    });

    test(
      'seed lại (asset đổi version) không ghi đè bản server mới hơn',
      () async {
        remote.protocols = [
          proto('cpr_adult_adolescent', '1.1.0', title: 'Bản server'),
        ];
        await SyncProtocols(remote, store)();
        // Buộc seed lại bằng cách đổi data_version.
        await db
            .into(db.meta)
            .insertOnConflictUpdate(
              MetaCompanion.insert(key: dataVersionKey, value: 'cu'),
            );
        expect(await SeedLoader(db, _fileLoader).seedIfNeeded(), isTrue);
        final p = (await local.getProtocolByCode('cpr_adult_adolescent'))!;
        expect(p.title, 'Bản server');
        expect(p.version, '1.1.0');
        // Các phác đồ khác vẫn được seed bình thường.
        expect(await local.getAllProtocols(), hasLength(6));
      },
    );

    test('seed lại: asset mới hơn bản server thì asset thắng', () async {
      await store.applyRemote([
        proto('cpr_adult_adolescent', '0.5.0', title: 'Cũ'),
      ]);
      await db
          .into(db.meta)
          .insertOnConflictUpdate(
            MetaCompanion.insert(key: dataVersionKey, value: 'cu'),
          );
      await SeedLoader(db, _fileLoader).seedIfNeeded();
      final p = (await local.getProtocolByCode('cpr_adult_adolescent'))!;
      expect(p.version, '1.0.0');
      expect(p.title, isNot('Cũ'));
    });
  });

  group('Migration Drift v1 -> v2', () {
    test('tạo bảng sync_jobs, giữ nguyên dữ liệu bảng meta cũ', () async {
      final old = AppDatabase.forTesting(
        NativeDatabase.memory(
          setup: (raw) {
            raw.execute(
              'CREATE TABLE meta (key TEXT NOT NULL PRIMARY KEY, value TEXT NOT NULL)',
            );
            raw.execute("INSERT INTO meta VALUES ('data_version', 'v1-cu')");
            raw.execute('PRAGMA user_version = 1');
          },
        ),
      );
      addTearDown(old.close);
      final row = await (old.select(
        old.meta,
      )..where((m) => m.key.equals('data_version'))).getSingle();
      expect(row.value, 'v1-cu');
      // sync_jobs dùng được sau khi nâng cấp.
      expect(await DriftSyncQueueRepository(old).enqueue(job('m', t0)), isTrue);
      expect(await DriftSyncQueueRepository(old).all(), hasLength(1));
    });
  });
}

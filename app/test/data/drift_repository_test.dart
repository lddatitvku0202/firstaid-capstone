import 'dart:io';

import 'package:app/data/datasources/local/app_database.dart';
import 'package:app/data/datasources/local/protocol_local_datasource.dart';
import 'package:app/data/datasources/local/seed_loader.dart';
import 'package:app/data/repositories/drift_emergency_repository.dart';
import 'package:app/data/repositories/drift_protocol_repository.dart';
import 'package:app/domain/usecases/get_offline_protocols.dart';
import 'package:app/domain/usecases/get_protocol_by_code.dart';
import 'package:app/domain/usecases/start_emergency_flow.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

Future<String> _fileLoader(String path) => File(path).readAsString();

void main() {
  late AppDatabase db;
  late ProtocolLocalDataSource local;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    local = ProtocolLocalDataSource(db);
    await SeedLoader(db, _fileLoader).seedIfNeeded();
  });

  tearDown(() => db.close());

  test('seed lần đầu ghi dữ liệu và data_version', () async {
    expect(await local.getDataVersion(), '1.0.0+1.0.0');
    expect(await local.getTriageRootId(), 'n_responsive');
  });

  test('seed idempotent: lần hai không seed lại', () async {
    final again = await SeedLoader(db, _fileLoader).seedIfNeeded();
    expect(again, isFalse);
    final all = await DriftProtocolRepository(local).getOfflineProtocols();
    expect(all, hasLength(6));
  });

  test('GetOfflineProtocols trả đủ phác đồ, bước theo thứ tự', () async {
    final repo = DriftProtocolRepository(local);
    final all = await GetOfflineProtocols(repo).call();
    expect(all.map((p) => p.topicId).toSet(), hasLength(4));
    for (final p in all) {
      final orders = p.steps.map((s) => s.order).toList();
      expect(orders, [...orders]..sort());
      expect(p.citations, isNotEmpty);
    }
  });

  test('GetProtocolByCode: có và không có', () async {
    final uc = GetProtocolByCode(DriftProtocolRepository(local));
    final p = await uc.call('cpr_adult_adolescent');
    expect(p, isNotNull);
    expect(p!.requiresClinicalWarning, isTrue);
    expect(p.doNot, isNotEmpty);
    expect(await uc.call('khong_ton_tai'), isNull);
  });

  test('StartEmergencyFlow bắt đầu từ nút gốc triage', () async {
    final repo = DriftEmergencyRepository(local);
    final fixed = DateTime.utc(2026, 11, 6);
    final c = await StartEmergencyFlow(repo, clock: () => fixed).call();
    expect(c.rootNode.id, 'n_responsive');
    expect(c.startedAt, fixed);
    final yes = await repo.getTriageNode(c.rootNode.yesNodeId!);
    expect(yes, isNotNull);
  });

  test('seed lại khi data_version đổi (xoá meta rồi seed)', () async {
    await db.delete(db.meta).go();
    final again = await SeedLoader(db, _fileLoader).seedIfNeeded();
    expect(again, isTrue);
    final all = await DriftProtocolRepository(local).getOfflineProtocols();
    expect(all, hasLength(6));
  });
}

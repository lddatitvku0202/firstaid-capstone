import 'package:drift/drift.dart';

import '../../domain/entities/sync_job.dart';
import '../../domain/repositories/sync_queue_repository.dart';
import '../datasources/local/app_database.dart';

class DriftSyncQueueRepository implements SyncQueueRepository {
  const DriftSyncQueueRepository(this._db);

  final AppDatabase _db;

  @override
  Future<bool> enqueue(SyncJob job) {
    // insertOrIgnore trả rowid cũ khi bị bỏ qua nên không dùng để phát hiện
    // trùng: kiểm tra tồn tại trong cùng transaction.
    return _db.transaction(() async {
      final exists = await (_db.select(
        _db.syncJobs,
      )..where((t) => t.id.equals(job.id))).getSingleOrNull();
      if (exists != null) return false;
      await _db
          .into(_db.syncJobs)
          .insert(
            SyncJobsCompanion.insert(
              id: job.id,
              kind: job.kind,
              payloadJson: job.payloadJson,
              createdAt: job.createdAt,
              nextAttemptAt: job.nextAttemptAt,
            ),
          );
      return true;
    });
  }

  @override
  Future<List<SyncJob>> dueJobs(DateTime now) async {
    final rows =
        await (_db.select(_db.syncJobs)
              ..where(
                (t) =>
                    t.status.equals('pending') &
                    t.nextAttemptAt.isSmallerOrEqualValue(now),
              )
              ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
            .get();
    return rows.map(_toJob).toList();
  }

  @override
  Future<void> markDone(String id) =>
      (_db.update(_db.syncJobs)..where((t) => t.id.equals(id))).write(
        const SyncJobsCompanion(status: Value('done'), lastError: Value(null)),
      );

  @override
  Future<void> markAttemptFailed(
    String id, {
    required String error,
    required DateTime nextAttemptAt,
    required bool failedPermanently,
  }) async {
    final row = await (_db.select(
      _db.syncJobs,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) return;
    await (_db.update(_db.syncJobs)..where((t) => t.id.equals(id))).write(
      SyncJobsCompanion(
        attempts: Value(row.attempts + 1),
        status: Value(failedPermanently ? 'failed' : 'pending'),
        nextAttemptAt: Value(nextAttemptAt),
        lastError: Value(error),
      ),
    );
  }

  @override
  Future<List<SyncJob>> all() async {
    final rows = await (_db.select(
      _db.syncJobs,
    )..orderBy([(t) => OrderingTerm.asc(t.createdAt)])).get();
    return rows.map(_toJob).toList();
  }

  SyncJob _toJob(SyncJobRow r) => SyncJob(
    id: r.id,
    kind: r.kind,
    payloadJson: r.payloadJson,
    createdAt: r.createdAt,
    nextAttemptAt: r.nextAttemptAt,
    attempts: r.attempts,
    status: switch (r.status) {
      'done' => SyncJobStatus.done,
      'failed' => SyncJobStatus.failed,
      _ => SyncJobStatus.pending,
    },
    lastError: r.lastError,
  );
}

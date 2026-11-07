import '../entities/sync_job.dart';

abstract interface class SyncQueueRepository {
  /// Thêm job. Nếu id đã tồn tại thì bỏ qua (idempotent), trả false.
  Future<bool> enqueue(SyncJob job);

  /// Các job `pending` có nextAttemptAt <= now.
  Future<List<SyncJob>> dueJobs(DateTime now);

  Future<void> markDone(String id);

  /// Ghi nhận một lần thử thất bại. `failedPermanently` = true thì chuyển
  /// sang `failed` (không thử nữa); ngược lại hẹn thử lại lúc `nextAttemptAt`.
  Future<void> markAttemptFailed(
    String id, {
    required String error,
    required DateTime nextAttemptAt,
    required bool failedPermanently,
  });

  Future<List<SyncJob>> all();
}

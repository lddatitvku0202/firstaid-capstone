enum SyncJobStatus { pending, failed, done }

/// Một việc đồng bộ chờ gửi lên server. `id` do client sinh (UUID) nên gửi lại
/// nhiều lần vẫn idempotent ở server.
class SyncJob {
  const SyncJob({
    required this.id,
    required this.kind,
    required this.payloadJson,
    required this.createdAt,
    required this.nextAttemptAt,
    this.attempts = 0,
    this.status = SyncJobStatus.pending,
    this.lastError,
  });

  static const kindSosLog = 'sos_log';

  final String id;
  final String kind;
  final String payloadJson;
  final DateTime createdAt;
  final DateTime nextAttemptAt;
  final int attempts;
  final SyncJobStatus status;
  final String? lastError;
}

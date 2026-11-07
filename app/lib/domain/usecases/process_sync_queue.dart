import '../repositories/sync_queue_repository.dart';
import '../services/remote_sync_source.dart';

class ProcessSyncQueueResult {
  const ProcessSyncQueueResult({
    this.sent = 0,
    this.retryLater = 0,
    this.failedPermanently = 0,
  });
  final int sent;
  final int retryLater;
  final int failedPermanently;
}

/// Gửi các job đến hạn. Retry có giới hạn với backoff mũ:
/// delay = baseDelay * 2^(attempts-1), tối đa maxDelay.
class ProcessSyncQueue {
  const ProcessSyncQueue(
    this._queue,
    this._remote, {
    this.maxAttempts = 5,
    this.baseDelay = const Duration(seconds: 30),
    this.maxDelay = const Duration(hours: 1),
  });

  final SyncQueueRepository _queue;
  final RemoteSyncSource _remote;
  final int maxAttempts;
  final Duration baseDelay;
  final Duration maxDelay;

  Duration backoff(int attempts) {
    final shift = attempts <= 1 ? 0 : (attempts - 1).clamp(0, 20);
    final d = baseDelay * (1 << shift);
    return d > maxDelay ? maxDelay : d;
  }

  Future<ProcessSyncQueueResult> call({required DateTime now}) async {
    var sent = 0;
    var retry = 0;
    var failed = 0;
    for (final job in await _queue.dueJobs(now)) {
      try {
        await _remote.submitJob(job);
        await _queue.markDone(job.id);
        sent++;
      } on RemotePermanentException catch (e) {
        await _queue.markAttemptFailed(
          job.id,
          error: e.message,
          nextAttemptAt: now,
          failedPermanently: true,
        );
        failed++;
      } on Object catch (e) {
        final attempts = job.attempts + 1;
        final giveUp = attempts >= maxAttempts;
        await _queue.markAttemptFailed(
          job.id,
          error: e.toString(),
          nextAttemptAt: now.add(backoff(attempts)),
          failedPermanently: giveUp,
        );
        if (giveUp) {
          failed++;
        } else {
          retry++;
        }
      }
    }
    return ProcessSyncQueueResult(
      sent: sent,
      retryLater: retry,
      failedPermanently: failed,
    );
  }
}

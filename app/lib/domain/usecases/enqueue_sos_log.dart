import 'dart:convert';

import '../entities/sync_job.dart';
import '../repositories/sync_queue_repository.dart';

/// Đưa log SOS vào hàng đợi đồng bộ. CHỈ khi người dùng đồng ý (consent).
/// Không đồng ý => không lưu gì và trả false. Vị trí được làm tròn 3 chữ số
/// thập phân (~110 m) trước khi gửi; không có ghi chú tự do.
class EnqueueSosLog {
  const EnqueueSosLog(this._queue);

  final SyncQueueRepository _queue;

  Future<bool> call({
    required bool consent,
    required String id,
    required String deviceId,
    required DateTime now,
    double? latitude,
    double? longitude,
  }) async {
    if (!consent) return false;
    double? round3(double? v) =>
        v == null ? null : (v * 1000).roundToDouble() / 1000;
    final payload = jsonEncode({
      'id': id,
      'device_id': deviceId,
      'consent': true,
      'lat': round3(latitude),
      'lon': round3(longitude),
    });
    return _queue.enqueue(
      SyncJob(
        id: id,
        kind: SyncJob.kindSosLog,
        payloadJson: payload,
        createdAt: now,
        nextAttemptAt: now,
      ),
    );
  }
}

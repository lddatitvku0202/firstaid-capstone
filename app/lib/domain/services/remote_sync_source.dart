import '../entities/first_aid_protocol.dart';
import '../entities/sync_job.dart';

/// Lỗi tạm thời (mất mạng, timeout, 5xx): nên thử lại.
class RemoteTransientException implements Exception {
  RemoteTransientException(this.message);
  final String message;
  @override
  String toString() => 'RemoteTransientException: $message';
}

/// Lỗi vĩnh viễn (từ chối RLS, dữ liệu sai): thử lại không giúp ích.
class RemotePermanentException implements Exception {
  RemotePermanentException(this.message);
  final String message;
  @override
  String toString() => 'RemotePermanentException: $message';
}

abstract interface class RemoteSyncSource {
  /// Danh sách phác đồ trên server (mọi trạng thái; việc lọc do use case).
  Future<List<FirstAidProtocol>> fetchProtocols();

  /// Gửi một job lên server. Phải idempotent theo `job.id`:
  /// gửi trùng id coi là thành công.
  Future<void> submitJob(SyncJob job);
}

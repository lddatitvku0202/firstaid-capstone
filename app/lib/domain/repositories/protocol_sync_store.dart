import '../entities/first_aid_protocol.dart';

/// Kho cục bộ nhận phác đồ tải từ server.
abstract interface class ProtocolSyncStore {
  /// code -> version đang có trên máy.
  Future<Map<String, String>> localVersions();

  /// Ghi tất cả `protocols` trong MỘT transaction: lỗi thì không đổi gì.
  Future<void> applyRemote(List<FirstAidProtocol> protocols);
}

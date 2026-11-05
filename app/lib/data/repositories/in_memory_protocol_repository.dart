import '../../domain/entities/first_aid_protocol.dart';
import '../../domain/repositories/protocol_repository.dart';

/// Stub tạm cho skeleton; Drift/SQLite sẽ thay ở prompt sau.
/// Không chứa nội dung y khoa: danh sách rỗng.
class InMemoryProtocolRepository implements ProtocolRepository {
  const InMemoryProtocolRepository();

  @override
  Future<List<FirstAidProtocol>> getOfflineProtocols() async => const [];

  @override
  Future<FirstAidProtocol?> getProtocolByCode(String code) async => null;
}

import '../../domain/entities/first_aid_protocol.dart';
import '../../domain/repositories/protocol_repository.dart';
import '../datasources/local/protocol_local_datasource.dart';

class DriftProtocolRepository implements ProtocolRepository {
  const DriftProtocolRepository(this._local);

  final ProtocolLocalDataSource _local;

  @override
  Future<List<FirstAidProtocol>> getOfflineProtocols() =>
      _local.getAllProtocols();

  @override
  Future<FirstAidProtocol?> getProtocolByCode(String code) =>
      _local.getProtocolByCode(code);
}

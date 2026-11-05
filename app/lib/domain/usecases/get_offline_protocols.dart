import '../entities/first_aid_protocol.dart';
import '../repositories/protocol_repository.dart';

class GetOfflineProtocols {
  const GetOfflineProtocols(this._repository);
  final ProtocolRepository _repository;

  Future<List<FirstAidProtocol>> call() => _repository.getOfflineProtocols();
}

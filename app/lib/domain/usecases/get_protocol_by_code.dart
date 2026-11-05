import '../entities/first_aid_protocol.dart';
import '../repositories/protocol_repository.dart';

class GetProtocolByCode {
  const GetProtocolByCode(this._repository);
  final ProtocolRepository _repository;

  Future<FirstAidProtocol?> call(String code) =>
      _repository.getProtocolByCode(code);
}

import '../entities/first_aid_protocol.dart';

abstract interface class ProtocolRepository {
  Future<List<FirstAidProtocol>> getOfflineProtocols();
  Future<FirstAidProtocol?> getProtocolByCode(String code);
}

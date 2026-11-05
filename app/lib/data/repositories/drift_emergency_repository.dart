import '../../domain/entities/triage_node.dart';
import '../../domain/repositories/emergency_repository.dart';
import '../datasources/local/protocol_local_datasource.dart';

class DriftEmergencyRepository implements EmergencyRepository {
  const DriftEmergencyRepository(this._local);

  final ProtocolLocalDataSource _local;

  @override
  Future<TriageNode> getTriageRoot() async {
    final rootId = await _local.getTriageRootId();
    final node = rootId == null ? null : await _local.getTriageNode(rootId);
    if (node == null) {
      throw StateError('Chưa có dữ liệu triage (chưa seed).');
    }
    return node;
  }

  @override
  Future<TriageNode?> getTriageNode(String id) => _local.getTriageNode(id);
}

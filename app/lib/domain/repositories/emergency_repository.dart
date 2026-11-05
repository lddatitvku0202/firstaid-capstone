import '../entities/triage_node.dart';

abstract interface class EmergencyRepository {
  Future<TriageNode> getTriageRoot();
}

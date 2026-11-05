import 'triage_node.dart';

class EmergencyCase {
  const EmergencyCase({
    required this.id,
    required this.startedAt,
    required this.rootNode,
    this.protocolCode,
  });

  final String id;
  final DateTime startedAt;
  final TriageNode rootNode;
  final String? protocolCode;
}

class TriageNode {
  const TriageNode({
    required this.id,
    required this.question,
    this.yesNodeId,
    this.noNodeId,
    this.protocolCode,
    this.callEmergencyNow = false,
  });

  final String id;
  final String question;
  final String? yesNodeId;
  final String? noNodeId;

  /// Mã phác đồ đích nếu đây là nút lá.
  final String? protocolCode;
  final bool callEmergencyNow;

  bool get isLeaf => protocolCode != null || callEmergencyNow;
}

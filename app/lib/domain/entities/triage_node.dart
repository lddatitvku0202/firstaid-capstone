import 'source_citation.dart';

class TriageNode {
  const TriageNode({
    required this.id,
    required this.question,
    this.yesNodeId,
    this.noNodeId,
    this.protocolCode,
    this.callEmergencyNow = false,
    this.citations = const [],
    this.note,
  });

  final String id;
  final String question;
  final String? yesNodeId;
  final String? noNodeId;

  /// Mã phác đồ đích nếu đây là nút lá.
  final String? protocolCode;
  final bool callEmergencyNow;
  final List<SourceCitation> citations;
  final String? note;

  bool get isLeaf => yesNodeId == null && noNodeId == null;
}

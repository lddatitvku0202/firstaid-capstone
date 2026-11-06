import '../entities/triage_node.dart';
import '../repositories/emergency_repository.dart';

/// Đi tiếp trong cây quyết định tĩnh (luật xác định, không phải AI).
class AdvanceTriage {
  const AdvanceTriage(this._repository);
  final EmergencyRepository _repository;

  /// Trả về null nếu nút hiện tại là nút lá hoặc nút đích không tồn tại.
  Future<TriageNode?> call(TriageNode current, {required bool answerYes}) {
    final nextId = answerYes ? current.yesNodeId : current.noNodeId;
    if (nextId == null) return Future.value();
    return _repository.getTriageNode(nextId);
  }
}

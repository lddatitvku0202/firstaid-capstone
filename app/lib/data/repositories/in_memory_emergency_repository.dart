import '../../domain/entities/triage_node.dart';
import '../../domain/repositories/emergency_repository.dart';

/// Stub: nút gốc là placeholder, chưa phải nội dung y khoa.
class InMemoryEmergencyRepository implements EmergencyRepository {
  const InMemoryEmergencyRepository();

  @override
  Future<TriageNode> getTriageRoot() async => const TriageNode(
    id: 'root',
    question: 'UNVERIFIED_PLACEHOLDER',
    callEmergencyNow: true,
  );
}

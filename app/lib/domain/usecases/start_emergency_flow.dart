import '../entities/emergency_case.dart';
import '../repositories/emergency_repository.dart';

class StartEmergencyFlow {
  const StartEmergencyFlow(this._repository, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;
  final EmergencyRepository _repository;
  final DateTime Function() _clock;

  Future<EmergencyCase> call() async {
    final root = await _repository.getTriageRoot();
    final now = _clock();
    return EmergencyCase(
      id: now.microsecondsSinceEpoch.toString(),
      startedAt: now,
      rootNode: root,
    );
  }
}

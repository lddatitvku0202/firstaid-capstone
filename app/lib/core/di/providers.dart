import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/in_memory_emergency_repository.dart';
import '../../data/repositories/in_memory_protocol_repository.dart';
import '../../domain/repositories/emergency_repository.dart';
import '../../domain/repositories/protocol_repository.dart';
import '../../domain/usecases/get_offline_protocols.dart';
import '../../domain/usecases/get_protocol_by_code.dart';
import '../../domain/usecases/prepare_sos_message.dart';
import '../../domain/usecases/start_emergency_flow.dart';

final protocolRepositoryProvider = Provider<ProtocolRepository>(
  (ref) => const InMemoryProtocolRepository(),
);
final emergencyRepositoryProvider = Provider<EmergencyRepository>(
  (ref) => const InMemoryEmergencyRepository(),
);

final getOfflineProtocolsProvider = Provider(
  (ref) => GetOfflineProtocols(ref.watch(protocolRepositoryProvider)),
);
final getProtocolByCodeProvider = Provider(
  (ref) => GetProtocolByCode(ref.watch(protocolRepositoryProvider)),
);
final startEmergencyFlowProvider = Provider(
  (ref) => StartEmergencyFlow(ref.watch(emergencyRepositoryProvider)),
);
final prepareSosMessageProvider = Provider((ref) => const PrepareSosMessage());

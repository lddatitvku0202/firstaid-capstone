import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/local/app_database.dart';
import '../../data/datasources/local/protocol_local_datasource.dart';
import '../../data/repositories/drift_emergency_repository.dart';
import '../../data/repositories/drift_protocol_repository.dart';
import '../../domain/repositories/emergency_repository.dart';
import '../../domain/repositories/protocol_repository.dart';
import '../../domain/usecases/get_offline_protocols.dart';
import '../../domain/usecases/get_protocol_by_code.dart';
import '../../domain/usecases/prepare_sos_message.dart';
import '../../domain/usecases/start_emergency_flow.dart';

/// Phải được override trong ProviderScope (main.dart hoặc test).
final appDatabaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError('appDatabaseProvider chưa được override'),
);

final protocolLocalDataSourceProvider = Provider(
  (ref) => ProtocolLocalDataSource(ref.watch(appDatabaseProvider)),
);

final protocolRepositoryProvider = Provider<ProtocolRepository>(
  (ref) => DriftProtocolRepository(ref.watch(protocolLocalDataSourceProvider)),
);
final emergencyRepositoryProvider = Provider<EmergencyRepository>(
  (ref) => DriftEmergencyRepository(ref.watch(protocolLocalDataSourceProvider)),
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

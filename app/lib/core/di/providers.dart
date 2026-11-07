import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/local/app_database.dart';
import '../../data/datasources/local/protocol_local_datasource.dart';
import '../../data/repositories/drift_emergency_repository.dart';
import '../../data/repositories/drift_protocol_repository.dart';
import '../../data/services/connectivity_plus_service.dart';
import '../../data/services/flutter_tts_service.dart';
import '../../data/services/geolocator_location_service.dart';
import '../../data/services/url_launcher_dialer_service.dart';
import '../../data/services/url_launcher_sms_composer.dart';
import '../../domain/repositories/emergency_repository.dart';
import '../../domain/repositories/protocol_repository.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/services/connectivity_service.dart';
import '../../domain/services/dialer_service.dart';
import '../../domain/services/location_service.dart';
import '../../domain/services/sms_composer.dart';
import '../../domain/services/tts_service.dart';
import '../../domain/usecases/advance_triage.dart';
import '../../domain/usecases/get_current_location_for_sos.dart';
import '../../domain/usecases/get_offline_protocols.dart';
import '../../domain/usecases/get_protocol_by_code.dart';
import '../../domain/usecases/prepare_sos_message.dart';
import '../../domain/usecases/search_protocols.dart';
import '../../domain/usecases/start_emergency_flow.dart';

/// Phải được override trong ProviderScope (main.dart hoặc test).
final appDatabaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError('appDatabaseProvider chưa được override'),
);

/// Phải được override (main.dart dùng SharedPreferences, test dùng fake).
final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) =>
      throw UnimplementedError('settingsRepositoryProvider chưa được override'),
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

final ttsServiceProvider = Provider<TtsService>((ref) => FlutterTtsService());
final connectivityServiceProvider = Provider<ConnectivityService>(
  (ref) => ConnectivityPlusService(),
);
final dialerServiceProvider = Provider<DialerService>(
  (ref) => const UrlLauncherDialerService(),
);

/// Đồng hồ (override trong test để nội dung SMS xác định).
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

final locationServiceProvider = Provider<LocationService>(
  (ref) => const GeolocatorLocationService(),
);
final smsComposerProvider = Provider<SmsComposer>(
  (ref) => const UrlLauncherSmsComposer(),
);
final getCurrentLocationForSosProvider = Provider(
  (ref) => GetCurrentLocationForSos(ref.watch(locationServiceProvider)),
);

final getOfflineProtocolsProvider = Provider(
  (ref) => GetOfflineProtocols(ref.watch(protocolRepositoryProvider)),
);
final getProtocolByCodeProvider = Provider(
  (ref) => GetProtocolByCode(ref.watch(protocolRepositoryProvider)),
);
final searchProtocolsProvider = Provider(
  (ref) => SearchProtocols(ref.watch(protocolRepositoryProvider)),
);
final startEmergencyFlowProvider = Provider(
  (ref) => StartEmergencyFlow(ref.watch(emergencyRepositoryProvider)),
);
final advanceTriageProvider = Provider(
  (ref) => AdvanceTriage(ref.watch(emergencyRepositoryProvider)),
);
final prepareSosMessageProvider = Provider((ref) => const PrepareSosMessage());

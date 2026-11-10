import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/local/app_database.dart';
import '../../data/datasources/local/protocol_local_datasource.dart';
import '../../data/repositories/drift_emergency_repository.dart';
import '../../data/repositories/drift_protocol_repository.dart';
import '../../data/repositories/drift_protocol_sync_store.dart';
import '../../data/repositories/drift_sync_queue_repository.dart';
import '../../data/repositories/http_ai_router_repository.dart';
import '../../data/services/connectivity_plus_service.dart';
import '../../data/services/flutter_tts_service.dart';
import '../../data/services/geolocator_location_service.dart';
import '../../data/services/url_launcher_dialer_service.dart';
import '../../data/services/url_launcher_sms_composer.dart';
import '../../domain/repositories/ai_router_repository.dart';
import '../../domain/repositories/emergency_repository.dart';
import '../../domain/repositories/protocol_repository.dart';
import '../../domain/repositories/protocol_sync_store.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/repositories/sync_queue_repository.dart';
import '../../domain/services/connectivity_service.dart';
import '../../domain/services/dialer_service.dart';
import '../../domain/services/location_service.dart';
import '../../domain/services/remote_sync_source.dart';
import '../../domain/services/sms_composer.dart';
import '../../domain/services/tts_service.dart';
import '../../domain/usecases/advance_triage.dart';
import '../../domain/usecases/enqueue_sos_log.dart';
import '../../domain/usecases/get_current_location_for_sos.dart';
import '../../domain/usecases/get_offline_protocols.dart';
import '../../domain/usecases/get_protocol_by_code.dart';
import '../../domain/usecases/prepare_sos_message.dart';
import '../../domain/usecases/process_sync_queue.dart';
import '../../domain/usecases/route_situation.dart';
import '../../domain/usecases/run_sync.dart';
import '../../domain/usecases/search_protocols.dart';
import '../../domain/usecases/start_emergency_flow.dart';
import '../../domain/usecases/sync_protocols.dart';
import '../config/app_config.dart';

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

/// Thiếu AI_BASE_URL => repository luôn báo notConfigured (app fallback).
final aiRouterRepositoryProvider = Provider<AiRouterRepository>(
  (ref) => AppConfig.aiConfigured
      ? HttpAiRouterRepository(
          baseUrl: AppConfig.aiBaseUrl,
          apiKey: AppConfig.aiApiKey,
        )
      : const DisabledAiRouterRepository(),
);
final routeSituationProvider = Provider(
  (ref) => RouteSituation(
    ref.watch(aiRouterRepositoryProvider),
    ref.watch(protocolRepositoryProvider),
    ref.watch(connectivityServiceProvider),
    timeout: const Duration(seconds: AppConfig.aiTimeoutSeconds),
  ),
);

/// null = chưa cấu hình Supabase (hoặc test): sync tắt, app dùng dữ liệu local.
/// main.dart override khi có SUPABASE_URL/SUPABASE_ANON_KEY.
final remoteSyncSourceProvider = Provider<RemoteSyncSource?>((ref) => null);

final syncQueueRepositoryProvider = Provider<SyncQueueRepository>(
  (ref) => DriftSyncQueueRepository(ref.watch(appDatabaseProvider)),
);
final protocolSyncStoreProvider = Provider<ProtocolSyncStore>(
  (ref) => DriftProtocolSyncStore(ref.watch(appDatabaseProvider)),
);
final enqueueSosLogProvider = Provider(
  (ref) => EnqueueSosLog(ref.watch(syncQueueRepositoryProvider)),
);

/// null khi chưa cấu hình remote.
final runSyncProvider = Provider<RunSync?>((ref) {
  final remote = ref.watch(remoteSyncSourceProvider);
  if (remote == null) return null;
  final sync = RunSync(
    connectivity: ref.watch(connectivityServiceProvider),
    syncProtocols: SyncProtocols(remote, ref.watch(protocolSyncStoreProvider)),
    processQueue: ProcessSyncQueue(
      ref.watch(syncQueueRepositoryProvider),
      remote,
    ),
    clock: ref.watch(clockProvider),
  );
  ref.onDispose(sync.dispose);
  return sync;
});

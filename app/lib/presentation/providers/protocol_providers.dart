import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/providers.dart';
import '../../domain/entities/first_aid_protocol.dart';
import '../../domain/services/tts_service.dart';

final protocolListProvider = FutureProvider<List<FirstAidProtocol>>(
  (ref) => ref.watch(getOfflineProtocolsProvider).call(),
);

final protocolSearchProvider =
    FutureProvider.family<List<FirstAidProtocol>, String>(
      (ref, query) => ref.watch(searchProtocolsProvider).call(query),
    );

final protocolDetailProvider = FutureProvider.family<FirstAidProtocol?, String>(
  (ref, code) => ref.watch(getProtocolByCodeProvider).call(code),
);

final ttsAvailabilityProvider = FutureProvider<TtsAvailability>(
  (ref) => ref.watch(ttsServiceProvider).checkVietnamese(),
);

/// true = có kết nối mạng (không đảm bảo có Internet).
final connectivityProvider = StreamProvider<bool>((ref) async* {
  final service = ref.watch(connectivityServiceProvider);
  yield await service.isConnected();
  yield* service.onChanged;
});

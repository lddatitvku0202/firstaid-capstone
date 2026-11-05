import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/providers.dart';
import '../../domain/entities/first_aid_protocol.dart';

final protocolListProvider = FutureProvider<List<FirstAidProtocol>>(
  (ref) => ref.watch(getOfflineProtocolsProvider).call(),
);

final protocolDetailProvider = FutureProvider.family<FirstAidProtocol?, String>(
  (ref, code) => ref.watch(getProtocolByCodeProvider).call(code),
);

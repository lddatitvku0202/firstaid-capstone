import 'package:connectivity_plus/connectivity_plus.dart';

import '../../domain/services/connectivity_service.dart';

class ConnectivityPlusService implements ConnectivityService {
  ConnectivityPlusService([Connectivity? connectivity])
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  static bool _any(List<ConnectivityResult> r) =>
      r.any((e) => e != ConnectivityResult.none);

  @override
  Future<bool> isConnected() async =>
      _any(await _connectivity.checkConnectivity());

  @override
  Stream<bool> get onChanged => _connectivity.onConnectivityChanged.map(_any);
}

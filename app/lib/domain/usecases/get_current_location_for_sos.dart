import '../services/location_service.dart';

class GetCurrentLocationForSos {
  const GetCurrentLocationForSos(this._service);
  final LocationService _service;

  Future<LocationResult> call({
    Duration timeout = const Duration(seconds: 15),
  }) => _service.getCurrentLocation(timeout: timeout);
}

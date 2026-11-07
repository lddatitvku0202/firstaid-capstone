import 'dart:async';

import 'package:geolocator/geolocator.dart';

import '../../domain/services/location_service.dart';

class GeolocatorLocationService implements LocationService {
  const GeolocatorLocationService();

  @override
  Future<LocationResult> getCurrentLocation({
    Duration timeout = const Duration(seconds: 15),
  }) async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return const LocationResult.failure(LocationStatus.serviceDisabled);
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      switch (permission) {
        case LocationPermission.denied:
          return const LocationResult.failure(LocationStatus.permissionDenied);
        case LocationPermission.deniedForever:
          return const LocationResult.failure(
            LocationStatus.permissionDeniedForever,
          );
        case LocationPermission.unableToDetermine:
          return const LocationResult.failure(LocationStatus.error);
        case LocationPermission.whileInUse:
        case LocationPermission.always:
          break;
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: timeout,
        ),
      );
      return LocationResult.ok(
        latitude: pos.latitude,
        longitude: pos.longitude,
        accuracyMeters: pos.accuracy,
      );
    } on TimeoutException {
      return const LocationResult.failure(LocationStatus.timeout);
    } on Object {
      return const LocationResult.failure(LocationStatus.error);
    }
  }

  @override
  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  @override
  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }
}

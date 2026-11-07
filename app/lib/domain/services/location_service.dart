enum LocationStatus {
  ok,
  permissionDenied,
  permissionDeniedForever,
  serviceDisabled,
  timeout,
  error,
}

class LocationResult {
  const LocationResult.ok({
    required double this.latitude,
    required double this.longitude,
    this.accuracyMeters,
  }) : status = LocationStatus.ok;

  const LocationResult.failure(this.status)
    : latitude = null,
      longitude = null,
      accuracyMeters = null;

  final LocationStatus status;
  final double? latitude;
  final double? longitude;
  final double? accuracyMeters;

  bool get isOk => status == LocationStatus.ok;
}

/// Lấy tọa độ GPS. Tọa độ dùng được khi không có Internet (cần tín hiệu GPS);
/// không cung cấp bản đồ hay địa chỉ chữ.
abstract interface class LocationService {
  /// Xin quyền (nếu cần) rồi lấy vị trí hiện tại, có giới hạn thời gian.
  Future<LocationResult> getCurrentLocation({
    Duration timeout = const Duration(seconds: 15),
  });

  Future<void> openAppSettings();
  Future<void> openLocationSettings();
}

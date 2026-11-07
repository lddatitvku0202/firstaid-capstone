class SosMessage {
  const SosMessage({
    required this.body,
    this.latitude,
    this.longitude,
    this.noteTruncated = false,
  });

  final String body;
  final double? latitude;
  final double? longitude;

  /// true nếu ghi chú đã bị cắt cho vừa độ dài cho phép.
  final bool noteTruncated;

  bool get hasLocation => latitude != null && longitude != null;
}

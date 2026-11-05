class SosMessage {
  const SosMessage({required this.body, this.latitude, this.longitude});

  final String body;
  final double? latitude;
  final double? longitude;

  bool get hasLocation => latitude != null && longitude != null;
}

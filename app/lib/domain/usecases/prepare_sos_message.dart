import '../entities/sos_message.dart';

/// Chỉ soạn nội dung để người dùng kiểm tra; KHÔNG tự gửi.
class PrepareSosMessage {
  const PrepareSosMessage();

  SosMessage call({double? latitude, double? longitude}) {
    final hasLocation = latitude != null && longitude != null;
    final location = hasLocation
        ? 'Vị trí: $latitude, $longitude'
        : 'Vị trí: chưa có';
    return SosMessage(
      body: 'Cần hỗ trợ khẩn cấp. $location',
      latitude: latitude,
      longitude: longitude,
    );
  }
}

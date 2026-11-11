import '../entities/ai_route.dart';

/// Gọi dịch vụ định tuyến AI (cần mạng).
abstract interface class AiRouterRepository {
  /// false khi app không được cấu hình máy chủ AI (thiếu AI_BASE_URL lúc build):
  /// khi đó không bao giờ gửi mô tả lên mạng nên cũng không hỏi đồng ý.
  bool get isConfigured;

  /// Phát các sự kiện tiến trình rồi đúng một [AiRouteFinal].
  /// Lỗi được phát dưới dạng [AiRouteException]. Hủy subscription = hủy yêu cầu.
  Stream<AiRouteEvent> routeSituation(String text);
}

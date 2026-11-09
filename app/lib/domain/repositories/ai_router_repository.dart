import '../entities/ai_route.dart';

/// Gọi dịch vụ định tuyến AI (cần mạng).
abstract interface class AiRouterRepository {
  /// Phát các sự kiện tiến trình rồi đúng một [AiRouteFinal].
  /// Lỗi được phát dưới dạng [AiRouteException]. Hủy subscription = hủy yêu cầu.
  Stream<AiRouteEvent> routeSituation(String text);
}

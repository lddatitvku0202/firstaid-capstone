/// Cấu hình lấy từ --dart-define / --dart-define-from-file=.env (không hardcode).
class AppConfig {
  const AppConfig._();

  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  /// Chỉ bật đồng bộ khi có đủ URL và key (không phải giá trị mẫu).
  static bool get supabaseConfigured =>
      supabaseUrl.startsWith('https://') &&
      !supabaseUrl.contains('your-project') &&
      supabaseAnonKey.isNotEmpty &&
      !supabaseAnonKey.contains('your-');

  /// Gốc URL backend định tuyến AI, vd `https://api.example.com`
  /// (emulator gọi máy dev: `http://10.0.2.2:8000`, chỉ bản debug cho phép http).
  static const aiBaseUrl = String.fromEnvironment('AI_BASE_URL');

  /// Token tùy chọn gửi qua X-API-Key. Nhúng trong app nên KHÔNG phải bí mật.
  static const aiApiKey = String.fromEnvironment('AI_API_KEY');

  /// Deadline tổng cho một lần gọi AI (giây). Mặc định 15: lựa chọn của nhóm,
  /// chưa đo trên mạng thật; người dùng luôn có nút bỏ qua ngay.
  static const aiTimeoutSeconds = int.fromEnvironment(
    'AI_TIMEOUT_SECONDS',
    defaultValue: 15,
  );

  static bool get aiConfigured =>
      (aiBaseUrl.startsWith('https://') || aiBaseUrl.startsWith('http://')) &&
      !aiBaseUrl.contains('your-');
}

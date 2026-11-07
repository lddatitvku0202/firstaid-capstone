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
}

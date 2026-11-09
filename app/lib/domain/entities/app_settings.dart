enum AppThemeMode { system, light, dark }

class AppSettings {
  const AppSettings({
    this.themeMode = AppThemeMode.system,
    this.textScale = 1.0,
    this.aiPrivacyConsent = false,
  });

  static const minTextScale = 0.85;
  static const maxTextScale = 1.5;

  final AppThemeMode themeMode;
  final double textScale;

  /// Người dùng đã đồng ý gửi văn bản mô tả tình huống lên máy chủ AI.
  final bool aiPrivacyConsent;

  AppSettings copyWith({
    AppThemeMode? themeMode,
    double? textScale,
    bool? aiPrivacyConsent,
  }) => AppSettings(
    themeMode: themeMode ?? this.themeMode,
    textScale: (textScale ?? this.textScale).clamp(minTextScale, maxTextScale),
    aiPrivacyConsent: aiPrivacyConsent ?? this.aiPrivacyConsent,
  );
}

enum AppThemeMode { system, light, dark }

class AppSettings {
  const AppSettings({
    this.themeMode = AppThemeMode.system,
    this.textScale = 1.0,
  });

  static const minTextScale = 0.85;
  static const maxTextScale = 1.5;

  final AppThemeMode themeMode;
  final double textScale;

  AppSettings copyWith({AppThemeMode? themeMode, double? textScale}) =>
      AppSettings(
        themeMode: themeMode ?? this.themeMode,
        textScale: (textScale ?? this.textScale).clamp(
          minTextScale,
          maxTextScale,
        ),
      );
}

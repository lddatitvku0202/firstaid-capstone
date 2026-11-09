import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';

const _themeKey = 'theme_mode';
const _textScaleKey = 'text_scale';
const _aiConsentKey = 'ai_privacy_consent';

class SharedPrefsSettingsRepository implements SettingsRepository {
  const SharedPrefsSettingsRepository(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<AppSettings> load() async {
    final name = _prefs.getString(_themeKey);
    final mode = AppThemeMode.values.firstWhere(
      (m) => m.name == name,
      orElse: () => AppThemeMode.system,
    );
    return const AppSettings().copyWith(
      themeMode: mode,
      textScale: _prefs.getDouble(_textScaleKey),
      aiPrivacyConsent: _prefs.getBool(_aiConsentKey),
    );
  }

  @override
  Future<void> save(AppSettings settings) async {
    await _prefs.setString(_themeKey, settings.themeMode.name);
    await _prefs.setDouble(_textScaleKey, settings.textScale);
    await _prefs.setBool(_aiConsentKey, settings.aiPrivacyConsent);
  }
}

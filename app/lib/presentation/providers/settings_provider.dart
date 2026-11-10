import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/providers.dart';
import '../../domain/entities/app_settings.dart';

/// Giá trị ban đầu đã đọc từ storage (override trong main.dart); mặc định cho test.
final initialSettingsProvider = Provider<AppSettings>(
  (ref) => const AppSettings(),
);

class SettingsController extends Notifier<AppSettings> {
  @override
  AppSettings build() => ref.watch(initialSettingsProvider);

  Future<void> setThemeMode(AppThemeMode mode) =>
      _update(state.copyWith(themeMode: mode));

  Future<void> setTextScale(double scale) =>
      _update(state.copyWith(textScale: scale));

  /// Xem trước khi đang kéo thanh trượt: chỉ đổi state, KHÔNG ghi đĩa mỗi
  /// frame (lưu bằng [setTextScale] khi thả tay).
  void previewTextScale(double scale) =>
      state = state.copyWith(textScale: scale);

  Future<void> setAiPrivacyConsent(bool value) =>
      _update(state.copyWith(aiPrivacyConsent: value));

  Future<void> _update(AppSettings next) async {
    state = next;
    await ref.read(settingsRepositoryProvider).save(next);
  }
}

final settingsProvider = NotifierProvider<SettingsController, AppSettings>(
  SettingsController.new,
);

ThemeMode toFlutterThemeMode(AppThemeMode m) => switch (m) {
  AppThemeMode.system => ThemeMode.system,
  AppThemeMode.light => ThemeMode.light,
  AppThemeMode.dark => ThemeMode.dark,
};

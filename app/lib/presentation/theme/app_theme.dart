import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const _seed = Color(0xFFB3261E);

  // Dựng một lần rồi dùng lại: FirstAidApp rebuild mỗi khi cài đặt đổi (kể cả
  // từng frame khi kéo thanh cỡ chữ); ColorScheme.fromSeed tính bảng màu nên
  // không nên chạy lại mỗi lần build.
  static final ThemeData _light = _build(Brightness.light);
  static final ThemeData _dark = _build(Brightness.dark);

  static ThemeData light() => _light;
  static ThemeData dark() => _dark;

  static ThemeData _build(Brightness brightness) => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: _seed, brightness: brightness),
  );
}

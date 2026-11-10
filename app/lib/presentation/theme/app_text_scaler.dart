import 'package:flutter/widgets.dart';

/// Cỡ chữ hiệu lực = cỡ chữ hệ thống (Android, có thể phi tuyến) x hệ số
/// trong Cài đặt của app, chặn trên ở [maxScale].
///
/// Trước đây app thay hẳn cỡ chữ hệ thống bằng hệ số của app, nên người dùng
/// đặt chữ to trong Android không có tác dụng. 2.0 là mức đã kiểm thử không
/// tràn/cắt chữ trên màn 360dp (test/accessibility_test.dart).
class AppTextScaler extends TextScaler {
  const AppTextScaler(this.system, this.appFactor);

  static const maxScale = 2.0;

  final TextScaler system;
  final double appFactor;

  /// Dùng trong MaterialApp.builder.
  static TextScaler resolve(TextScaler system, double appFactor) =>
      AppTextScaler(system, appFactor).clamp(maxScaleFactor: maxScale);

  @override
  double scale(double fontSize) => system.scale(fontSize) * appFactor;

  @Deprecated('Dùng scale()')
  @override
  double get textScaleFactor => scale(14) / 14;

  @override
  bool operator ==(Object other) =>
      other is AppTextScaler &&
      other.system == system &&
      other.appFactor == appFactor;

  @override
  int get hashCode => Object.hash(system, appFactor);
}

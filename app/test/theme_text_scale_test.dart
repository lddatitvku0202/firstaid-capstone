import 'package:app/domain/entities/app_settings.dart';
import 'package:app/presentation/screens/home_screen.dart';
import 'package:app/presentation/theme/app_text_scaler.dart';
import 'package:app/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_app.dart';

void main() {
  group('AppTheme', () {
    test('Material 3, sáng/tối đúng brightness, dựng một lần (cache)', () {
      expect(AppTheme.light().useMaterial3, isTrue);
      expect(AppTheme.dark().useMaterial3, isTrue);
      expect(AppTheme.light().colorScheme.brightness, Brightness.light);
      expect(AppTheme.dark().colorScheme.brightness, Brightness.dark);
      expect(identical(AppTheme.light(), AppTheme.light()), isTrue);
      expect(identical(AppTheme.dark(), AppTheme.dark()), isTrue);
    });
  });

  group('AppTextScaler', () {
    test('nhân cỡ chữ hệ thống với hệ số của app', () {
      final s = AppTextScaler.resolve(const TextScaler.linear(1.3), 1.2);
      expect(s.scale(10), closeTo(15.6, 1e-9));
    });

    test('chặn trên ở 2.0 (mức đã kiểm thử)', () {
      final s = AppTextScaler.resolve(const TextScaler.linear(2.0), 1.5);
      expect(s.scale(10), 20);
    });

    test('so sánh bằng nhau theo giá trị (tránh rebuild thừa)', () {
      expect(
        const AppTextScaler(TextScaler.noScaling, 1.2),
        const AppTextScaler(TextScaler.noScaling, 1.2),
      );
      expect(
        const AppTextScaler(TextScaler.noScaling, 1.2) ==
            const AppTextScaler(TextScaler.noScaling, 1.3),
        isFalse,
      );
    });
  });

  testWidgets('app tôn trọng cỡ chữ hệ thống (trước đây bị ghi đè)', (
    tester,
  ) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final env = await createEnv(
      tester,
      settings: const AppSettings(textScale: 1.2),
    );
    await pumpFullApp(tester, env);
    final ctx = tester.element(find.byType(HomeScreen));
    // 1.5 (hệ thống) x 1.2 (app) = 1.8
    expect(MediaQuery.textScalerOf(ctx).scale(10), closeTo(18, 1e-9));
  });

  testWidgets('kéo thanh cỡ chữ: chỉ ghi đĩa khi thả tay', (tester) async {
    final env = await createEnv(tester);
    await pumpFullApp(tester, env);
    await tester.tap(find.byIcon(Icons.settings));
    await settle(tester);
    final before = env.settings.saveCount;
    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(Slider)),
    );
    for (var i = 0; i < 10; i++) {
      await gesture.moveBy(const Offset(15, 0));
      await tester.pump();
    }
    expect(env.settings.saveCount, before); // đang kéo: chưa lưu
    await gesture.up();
    await settle(tester);
    expect(env.settings.saveCount, before + 1);
    expect(env.settings.stored.textScale, greaterThan(1.0));
  });
}

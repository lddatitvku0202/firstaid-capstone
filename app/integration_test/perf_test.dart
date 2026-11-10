// Đo hiệu năng khung hình (frame timing) các thao tác chính.
// CHỈ có ý nghĩa ở profile mode trên MÁY THẬT (debug/emulator không đại diện):
//
//   cd "D:\Start Github\firstaid-capstone\app"
//   flutter drive --profile --no-dds -d <ID> --driver=test_driver/perf_driver.dart --target=integration_test/perf_test.dart
//
// (--no-dds bắt buộc: watchPerformance cần nối VM service; chạy bằng
// `flutter test` sẽ lỗi.) Kết quả: build/<reportKey>.json do perf_driver ghi
// ra (xem docs/evidence/fps/README.md). Không tự điền số vào báo cáo.
import 'package:app/core/di/providers.dart';
import 'package:app/data/datasources/local/app_database.dart';
import 'package:app/data/datasources/local/seed_loader.dart';
import 'package:app/domain/entities/app_settings.dart';
import 'package:app/main.dart';
import 'package:app/presentation/providers/settings_provider.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/helpers/test_app.dart'
    show FakeDialer, FakeLocation, FakeSettingsRepository, FakeSms, FakeTts;

Future<void> _runScenarios(
  IntegrationTestWidgetsFlutterBinding binding,
  WidgetTester tester, {
  required AppThemeMode theme,
}) async {
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  addTearDown(db.close);
  await SeedLoader(db, rootBundle.loadString).seedIfNeeded();
  final settings = AppSettings(themeMode: theme);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        settingsRepositoryProvider.overrideWithValue(
          FakeSettingsRepository(settings),
        ),
        initialSettingsProvider.overrideWithValue(settings),
        ttsServiceProvider.overrideWithValue(FakeTts()),
        dialerServiceProvider.overrideWithValue(FakeDialer()),
        locationServiceProvider.overrideWithValue(FakeLocation()),
        smsComposerProvider.overrideWithValue(FakeSms()),
      ],
      child: const FirstAidApp(),
    ),
  );
  await tester.pumpAndSettle();
  final suffix = theme.name;

  // S1: hướng dẫn CPR từng bước (Tiếp x6, Trước x6).
  await tester.tap(find.text('Hồi sinh tim phổi (CPR)'));
  await tester.pumpAndSettle();
  await binding.watchPerformance(() async {
    for (var i = 0; i < 6; i++) {
      await tester.tap(find.text('Tiếp'));
      await tester.pumpAndSettle();
    }
    for (var i = 0; i < 6; i++) {
      await tester.tap(find.text('Trước'));
      await tester.pumpAndSettle();
    }
  }, reportKey: 'guide_steps_$suffix');
  await tester.pageBack();
  await tester.pumpAndSettle();

  // S2: cẩm nang: gõ tìm kiếm rồi cuộn danh sách.
  await tester.tap(find.text('Cẩm nang sơ cứu'));
  await tester.pumpAndSettle();
  await binding.watchPerformance(() async {
    await tester.enterText(find.byType(TextField), 'bong');
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();
    final list = find.byType(Scrollable).last;
    for (var i = 0; i < 3; i++) {
      await tester.fling(list, const Offset(0, -600), 2000);
      await tester.pumpAndSettle();
      await tester.fling(list, const Offset(0, 600), 2000);
      await tester.pumpAndSettle();
    }
  }, reportKey: 'handbook_search_scroll_$suffix');
  await tester.pageBack();
  await tester.pumpAndSettle();

  // S3: sàng lọc khẩn cấp tới kết quả CPR.
  await binding.watchPerformance(() async {
    await tester.tap(find.text('KHẨN CẤP'));
    await tester.pumpAndSettle();
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.text('Không'));
      await tester.pumpAndSettle();
    }
  }, reportKey: 'triage_flow_$suffix');
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('frame timing: giao diện Sáng', (tester) async {
    await _runScenarios(binding, tester, theme: AppThemeMode.light);
  });

  testWidgets('frame timing: giao diện Tối', (tester) async {
    await _runScenarios(binding, tester, theme: AppThemeMode.dark);
  });
}

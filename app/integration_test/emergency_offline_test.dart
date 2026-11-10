// Integration test: luồng khẩn cấp khi KHÔNG có mạng, chạy trên emulator/máy thật.
//
// Dùng thật: asset phác đồ + cây sàng lọc (rootBundle), Drift/SQLite trên máy,
// connectivity_plus (đọc trạng thái mạng thật), router, theme.
// Thay bằng fake: trình quay số (không mở app gọi điện thật), TTS, vị trí,
// SMS, settings.
//
// Bật chế độ máy bay TRƯỚC khi chạy:
//   adb shell cmd connectivity airplane-mode enable
//   flutter test integration_test -d <ID>
//   adb shell cmd connectivity airplane-mode disable
import 'package:app/core/di/providers.dart';
import 'package:app/data/datasources/local/app_database.dart';
import 'package:app/data/datasources/local/seed_loader.dart';
import 'package:app/domain/usecases/route_situation.dart';
import 'package:app/main.dart';
import 'package:app/presentation/providers/settings_provider.dart';
import 'package:app/presentation/screens/describe_situation_screen.dart';
import 'package:app/presentation/widgets/call_115_button.dart';
import 'package:app/presentation/widgets/network_chip.dart';
import 'package:app/presentation/widgets/sos_button.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/helpers/test_app.dart'
    show FakeDialer, FakeLocation, FakeSettingsRepository, FakeSms, FakeTts;

/// Trên thiết bị, kết quả platform channel/SQLite về bất đồng bộ thật nên
/// pumpAndSettle có thể trả về sớm: chờ tới khi thấy [finder] (tối đa 15 s).
/// [scroll]: cuộn danh sách xuống dần (màn nhỏ/bàn phím ảo che bớt).
Future<void> waitFor(
  WidgetTester tester,
  Finder finder, {
  bool scroll = false,
}) async {
  final end = DateTime.now().add(const Duration(seconds: 15));
  while (finder.evaluate().isEmpty && DateTime.now().isBefore(end)) {
    if (scroll && find.byType(Scrollable).evaluate().isNotEmpty) {
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -200));
    }
    await tester.pump(const Duration(milliseconds: 100));
  }
  if (finder.evaluate().isEmpty) {
    final shown = find
        .byType(Text)
        .evaluate()
        .map((e) => (e.widget as Text).data)
        .whereType<String>()
        .join(' | ');
    fail('Không thấy $finder. Chữ đang hiện: $shown');
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('mất mạng: KHẨN CẤP -> sàng lọc -> CPR từng bước -> Gọi 115; '
      'Mô tả tình huống fallback offline', (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    await SeedLoader(db, rootBundle.loadString).seedIfNeeded();
    final dialer = FakeDialer();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          settingsRepositoryProvider.overrideWithValue(
            FakeSettingsRepository(),
          ),
          ttsServiceProvider.overrideWithValue(FakeTts()),
          dialerServiceProvider.overrideWithValue(dialer),
          locationServiceProvider.overrideWithValue(FakeLocation()),
          smsComposerProvider.overrideWithValue(FakeSms()),
          initialSettingsProvider.overrideWithValue(
            FakeSettingsRepository().stored,
          ),
        ],
        child: const FirstAidApp(),
      ),
    );
    await tester.pumpAndSettle();

    // connectivity_plus thật phải báo không có mạng.
    await waitFor(tester, find.text(NetworkChip.offlineLabel));

    // Sàng lọc: không phản ứng -> không thở bình thường -> không phải trẻ em.
    await tester.tap(find.text(SosButton.label));
    for (final q in [
      'phản ứng khi bạn gọi to',
      'thở bình thường',
      'em bé hoặc trẻ em',
    ]) {
      await waitFor(tester, find.textContaining(q));
      await tester.tap(find.text('Không'));
    }
    await waitFor(tester, find.textContaining('bắt đầu ép ngực'));

    await tester.tap(find.text('Xem hướng dẫn từng bước'));
    await waitFor(tester, find.text('Bước 1/7'));
    await tester.tap(find.text('Tiếp'));
    await waitFor(tester, find.text('Bước 2/7'));

    // Nút nằm cuối danh sách hướng dẫn: cuộn tới trước khi bấm.
    await tester.scrollUntilVisible(
      find.text(Call115Button.label),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text(Call115Button.label));
    await tester.pumpAndSettle();
    expect(dialer.dialed, ['115']);

    // Về Home, thử AI khi mất mạng: phải fallback, không cần đồng ý/không gửi.
    while (find.byType(SosButton).evaluate().isEmpty) {
      await tester.pageBack();
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('Mô tả tình huống'));
    await waitFor(tester, find.text(DescribeSituationScreen.submitLabel));
    await tester.enterText(find.byType(TextField), 'tay bị bỏng do nước sôi');
    await tester.tap(find.text(DescribeSituationScreen.submitLabel));
    // Không cuộn thủ công: app phải tự cuộn tới thẻ kết quả.
    await waitFor(tester, find.text(fallbackMessage(FallbackReason.offline)));
    await tester.pumpAndSettle();
    final card = tester.getRect(
      find.text(fallbackMessage(FallbackReason.offline)),
    );
    final screen = tester.getRect(find.byType(Scaffold).last);
    expect(card.top >= screen.top && card.bottom <= screen.bottom, isTrue);
    expect(find.text(DescribeSituationScreen.consentTitle), findsNothing);

    await tester.ensureVisible(find.text('Bắt đầu sàng lọc offline'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bắt đầu sàng lọc offline'));
    await waitFor(tester, find.textContaining('phản ứng khi bạn gọi to'));
  });
}

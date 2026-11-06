import 'package:app/domain/services/tts_service.dart';
import 'package:app/presentation/screens/protocol_detail_screen.dart';
import 'package:app/presentation/screens/protocol_list_screen.dart';
import 'package:app/presentation/widgets/call_115_button.dart';
import 'package:app/presentation/widgets/clinical_warning_banner.dart';
import 'package:app/presentation/widgets/network_chip.dart';
import 'package:app/presentation/widgets/sos_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_app.dart';

void main() {
  group('Home', () {
    testWidgets('có nút KHẨN CẤP (icon + chữ), lối vào và chip mạng', (
      tester,
    ) async {
      final env = await createEnv(tester);
      await pumpFullApp(tester, env);
      expect(find.text(SosButton.label), findsOneWidget);
      expect(find.byIcon(Icons.emergency), findsOneWidget);
      expect(find.text('Cẩm nang sơ cứu'), findsOneWidget);
      expect(find.text('Hồi sinh tim phổi (CPR)'), findsOneWidget);
      expect(find.text('Mô tả tình huống'), findsOneWidget);
      expect(find.text(NetworkChip.onlineLabel), findsOneWidget);
      expect(find.byIcon(Icons.wifi), findsOneWidget);
    });

    testWidgets('chip mạng chuyển sang chữ + icon offline', (tester) async {
      final env = await createEnv(tester, connected: false);
      await pumpFullApp(tester, env);
      expect(find.text(NetworkChip.offlineLabel), findsOneWidget);
      expect(find.byIcon(Icons.wifi_off), findsOneWidget);
      env.connectivity.emit(true);
      await settle(tester);
      expect(find.text(NetworkChip.onlineLabel), findsOneWidget);
    });
  });

  group('Triage', () {
    testWidgets('KHẨN CẤP -> không phản ứng, không thở -> CPR + gọi 115', (
      tester,
    ) async {
      final env = await createEnv(tester);
      await pumpFullApp(tester, env);
      await tester.tap(find.text(SosButton.label));
      await settle(tester);
      expect(find.textContaining('phản ứng khi bạn gọi to'), findsOneWidget);
      await tester.tap(find.text('Không')); // không phản ứng
      await settle(tester);
      expect(find.textContaining('thở bình thường'), findsOneWidget);
      await tester.tap(find.text('Không')); // không thở bình thường
      await settle(tester);
      await tester.tap(find.text('Không')); // không phải trẻ em
      await settle(tester);
      expect(find.textContaining('bắt đầu ép ngực'), findsOneWidget);
      expect(find.text('Xem hướng dẫn từng bước'), findsOneWidget);

      await tester.tap(find.text(Call115Button.label));
      await settle(tester);
      expect(env.dialer.dialed, ['115']);
    });

    testWidgets('mọi bước sàng lọc đều có nút Gọi 115 ngay', (tester) async {
      final env = await createEnv(tester);
      await pumpFullApp(tester, env);
      await tester.tap(find.text(SosButton.label));
      await settle(tester);
      expect(find.text(Call115Button.label), findsOneWidget);
    });

    testWidgets('không xác định tình huống -> Gọi 115', (tester) async {
      final env = await createEnv(tester);
      await pumpFullApp(tester, env);
      await tester.tap(find.text(SosButton.label));
      await settle(tester);
      // phản ứng: Có -> hóc: Không -> chảy máu: Không -> bỏng: Không
      for (var i = 0; i < 4; i++) {
        await tester.tap(find.byIcon(i == 0 ? Icons.check : Icons.close));
        await settle(tester);
      }
      expect(find.text('Gọi 115 ngay.'), findsOneWidget);
      await tester.tap(find.text(Call115Button.label));
      await settle(tester);
      expect(env.dialer.dialed, ['115']);
    });
  });

  group('Hướng dẫn từng bước', () {
    testWidgets('hiện bước, nguồn, version, cảnh báo, KHÔNG ĐƯỢC LÀM', (
      tester,
    ) async {
      final env = await createEnv(tester);
      await pumpScreen(
        tester,
        env,
        const ProtocolDetailScreen(code: 'burns_thermal_chemical'),
      );
      expect(find.text('Bước 1/7'), findsOneWidget);
      expect(find.textContaining('nước sạch chảy'), findsOneWidget);
      expect(find.text(ClinicalWarningBanner.message), findsOneWidget);
      await tester.scrollUntilVisible(
        find.textContaining('Phiên bản 1.0.0'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('KHÔNG ĐƯỢC LÀM'), findsOneWidget);
      expect(find.textContaining('IFRC-2025'), findsWidgets);
      expect(find.text(Call115Button.label), findsOneWidget);
    });

    testWidgets('Tiếp/Trước đổi bước; Đọc to gọi TTS với đúng text', (
      tester,
    ) async {
      final env = await createEnv(tester);
      await pumpScreen(
        tester,
        env,
        const ProtocolDetailScreen(code: 'cpr_adult_adolescent'),
      );
      await tester.tap(find.text('Tiếp'));
      await settle(tester);
      expect(find.text('Bước 2/7'), findsOneWidget);
      await tester.tap(find.text('Đọc to'));
      await settle(tester);
      expect(env.tts.spoken, hasLength(1));
      expect(env.tts.spoken.single, contains('100-120'));
      await tester.tap(find.text('Trước'));
      await settle(tester);
      expect(find.text('Bước 1/7'), findsOneWidget);
    });

    testWidgets('thiếu giọng vi-VN: thông báo rõ, vẫn hiện text, nút đọc tắt', (
      tester,
    ) async {
      final env = await createEnv(
        tester,
        tts: TtsAvailability.vietnameseMissing,
      );
      await pumpScreen(
        tester,
        env,
        const ProtocolDetailScreen(code: 'cpr_adult_adolescent'),
      );
      expect(
        find.textContaining('chưa có giọng đọc tiếng Việt'),
        findsOneWidget,
      );
      expect(find.textContaining('hô to gọi giúp'), findsOneWidget);
      final button = tester.widget<OutlinedButton>(
        find.ancestor(
          of: find.text('Đọc to'),
          matching: find.byType(OutlinedButton),
        ),
      );
      expect(button.onPressed, isNull);
      expect(env.tts.spoken, isEmpty);
    });
  });

  group('Cẩm nang', () {
    testWidgets('danh sách, cảnh báo và tìm kiếm local không dấu', (
      tester,
    ) async {
      final env = await createEnv(tester);
      await pumpScreen(tester, env, const ProtocolListScreen());
      expect(find.text(ClinicalWarningBanner.message), findsOneWidget);
      expect(find.text('Chảy máu nặng bên ngoài'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'bong');
      await settle(tester);
      expect(find.text('Bỏng nhiệt và bỏng hóa chất'), findsOneWidget);
      expect(find.text('Chảy máu nặng bên ngoài'), findsNothing);
      await tester.enterText(find.byType(TextField), 'zzzz');
      await settle(tester);
      expect(find.text('Không tìm thấy kết quả.'), findsOneWidget);
    });
  });

  group('Cài đặt', () {
    testWidgets('đổi chế độ tối và cỡ chữ, được lưu qua repository', (
      tester,
    ) async {
      final env = await createEnv(tester);
      await pumpFullApp(tester, env);
      await tester.tap(find.byIcon(Icons.settings));
      await settle(tester);
      await tester.tap(find.text('Tối'));
      await settle(tester);
      expect(env.settings.stored.themeMode.name, 'dark');
      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.themeMode, ThemeMode.dark);
      await tester.drag(find.byType(Slider), const Offset(300, 0));
      await settle(tester);
      expect(env.settings.stored.textScale, greaterThan(1.0));
      expect(env.settings.saveCount, greaterThanOrEqualTo(2));
    });
  });
}

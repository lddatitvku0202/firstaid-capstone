import 'package:app/domain/services/location_service.dart';
import 'package:app/presentation/screens/sos_screen.dart';
import 'package:app/presentation/widgets/call_115_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_app.dart';

void main() {
  Future<void> openSos(WidgetTester tester, TestEnv env) async {
    await pumpFullApp(tester, env);
    await tester.tap(find.text('SOS: gửi vị trí'));
    await settle(tester);
  }

  testWidgets('giải thích quyền trước, chưa lấy vị trí/chưa gửi gì', (
    tester,
  ) async {
    final env = await createEnv(tester);
    await openSos(tester, env);
    expect(find.text(SosScreen.introText), findsOneWidget);
    expect(find.text(SosScreen.limitsText), findsOneWidget);
    expect(find.text('Lấy vị trí của tôi'), findsOneWidget);
    expect(find.text(Call115Button.label), findsOneWidget);
    expect(env.location.calls, 0);
    expect(env.sms.drafts, isEmpty);
  });

  testWidgets('luồng xác nhận: vị trí -> xem trước -> xác nhận mới mở SMS', (
    tester,
  ) async {
    final env = await createEnv(tester);
    await openSos(tester, env);
    await tester.tap(find.text('Lấy vị trí của tôi'));
    await settle(tester);

    expect(env.location.calls, 1);
    expect(find.textContaining('Vĩ độ 16.054400'), findsOneWidget);
    expect(find.textContaining('sai số khoảng 12 m'), findsOneWidget);
    final preview = tester.widget<Text>(find.byKey(const Key('sms_preview')));
    expect(preview.data, contains('07/11/2026 09:30'));
    expect(preview.data, contains('16.054400, 108.202200'));
    expect(find.text(SosScreen.noAutoSendText), findsOneWidget);
    // Chưa xác nhận thì chưa mở SMS.
    expect(env.sms.drafts, isEmpty);

    await tester.enterText(find.byType(TextField), 'Cổng sau trường');
    await settle(tester);
    expect(
      tester.widget<Text>(find.byKey(const Key('sms_preview'))).data,
      contains('Ghi chú: Cổng sau trường'),
    );

    await tester.tap(find.text('Xác nhận và mở tin nhắn'));
    await settle(tester);
    expect(env.sms.drafts, hasLength(1));
    expect(env.sms.drafts.single, contains('Ghi chú: Cổng sau trường'));
    expect(env.sms.recipients.single, isNull);
    expect(find.textContaining('tự bấm Gửi'), findsWidgets);
  });

  testWidgets('bỏ qua vị trí: soạn tin không tọa độ', (tester) async {
    final env = await createEnv(tester);
    await openSos(tester, env);
    await tester.tap(find.text('Bỏ qua, soạn tin không có vị trí'));
    await settle(tester);
    expect(env.location.calls, 0);
    expect(find.text('Không có vị trí'), findsOneWidget);
    expect(
      tester.widget<Text>(find.byKey(const Key('sms_preview'))).data,
      contains('Vị trí: chưa có'),
    );
  });

  for (final c in [
    (LocationStatus.permissionDenied, 'từ chối quyền vị trí'),
    (LocationStatus.permissionDeniedForever, 'đang bị chặn'),
    (LocationStatus.serviceDisabled, 'GPS (dịch vụ vị trí) đang tắt'),
    (LocationStatus.timeout, 'Chưa lấy được vị trí trong thời gian'),
    (LocationStatus.error, 'lỗi không xác định'),
  ]) {
    testWidgets('lỗi ${c.$1.name}: thông báo, thử lại, bỏ qua, vẫn gọi 115', (
      tester,
    ) async {
      final env = await createEnv(
        tester,
        location: LocationResult.failure(c.$1),
      );
      await openSos(tester, env);
      await tester.tap(find.text('Lấy vị trí của tôi'));
      await settle(tester);
      expect(find.textContaining(c.$2), findsOneWidget);
      expect(find.text('Thử lại'), findsOneWidget);
      expect(find.text('Bỏ qua, soạn tin không có vị trí'), findsOneWidget);
      expect(env.sms.drafts, isEmpty);

      await tester.tap(find.text(Call115Button.label));
      await settle(tester);
      expect(env.dialer.dialed, ['115']);
    });
  }

  testWidgets('bị chặn vĩnh viễn / GPS tắt: mở đúng màn cài đặt', (
    tester,
  ) async {
    final env = await createEnv(
      tester,
      location: const LocationResult.failure(
        LocationStatus.permissionDeniedForever,
      ),
    );
    await openSos(tester, env);
    await tester.tap(find.text('Lấy vị trí của tôi'));
    await settle(tester);
    await tester.tap(find.text('Mở cài đặt ứng dụng'));
    await settle(tester);
    expect(env.location.openAppSettingsCalls, 1);

    env.location.result = const LocationResult.failure(
      LocationStatus.serviceDisabled,
    );
    await tester.tap(find.text('Thử lại'));
    await settle(tester);
    await tester.tap(find.text('Mở cài đặt vị trí'));
    await settle(tester);
    expect(env.location.openLocationSettingsCalls, 1);
  });

  testWidgets('thử lại sau lỗi thành công thì vào màn xem trước', (
    tester,
  ) async {
    final env = await createEnv(
      tester,
      location: const LocationResult.failure(LocationStatus.timeout),
    );
    await openSos(tester, env);
    await tester.tap(find.text('Lấy vị trí của tôi'));
    await settle(tester);
    env.location.result = const LocationResult.ok(
      latitude: 10.5,
      longitude: 106.5,
    );
    await tester.tap(find.text('Thử lại'));
    await settle(tester);
    expect(find.textContaining('Vĩ độ 10.500000'), findsOneWidget);
    expect(env.location.calls, 2);
  });
}

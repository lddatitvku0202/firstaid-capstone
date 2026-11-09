import 'dart:async';

import 'package:app/domain/entities/ai_route.dart';
import 'package:app/domain/entities/app_settings.dart';
import 'package:app/domain/entities/source_citation.dart';
import 'package:app/domain/usecases/route_situation.dart';
import 'package:app/presentation/screens/describe_situation_screen.dart';
import 'package:app/presentation/widgets/call_115_button.dart';
import 'package:app/presentation/widgets/clinical_warning_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_app.dart';

const _llmNote = 'GHI_CHU_LLM_KHONG_DUOC_HIEN';
const _burnsTitle = 'Bỏng nhiệt và bỏng hóa chất';
const _consented = AppSettings(aiPrivacyConsent: true);

AiRouteResult _result({
  AiRouteCategory category = AiRouteCategory.burns,
  String? code = 'burns_thermal_chemical',
  bool uncertain = false,
}) => AiRouteResult(
  category: category,
  protocolCode: code,
  confidenceNote: _llmNote,
  sources: const [SourceCitation(sourceId: 'IFRC-2025', pages: '288-290')],
  uncertain: uncertain,
);

Stream<AiRouteEvent> _ok(AiRouteResult r) => Stream.fromIterable([
  const AiRouteStatus(AiRouteStage.received),
  const AiRouteDelta(10),
  AiRouteFinal(r),
]);

void _tallScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 2.0;
  addTearDown(tester.view.reset);
}

/// Không dùng pumpAndSettle khi có LinearProgressIndicator (animation vô hạn).
Future<void> _pumpUntil(WidgetTester tester, Finder finder) async {
  for (var i = 0; i < 50; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 10)),
    );
    await tester.pump(const Duration(milliseconds: 100));
    if (finder.evaluate().isNotEmpty) return;
  }
  fail('Không thấy $finder');
}

Future<TestEnv> _openDescribe(
  WidgetTester tester, {
  AppSettings settings = _consented,
  bool connected = true,
  Stream<AiRouteEvent> Function(String)? handler,
}) async {
  _tallScreen(tester);
  final env = await createEnv(tester, settings: settings, connected: connected);
  env.ai.handler = handler;
  await pumpFullApp(tester, env);
  await tester.tap(find.text('Mô tả tình huống'));
  await settle(tester);
  expect(find.text(DescribeSituationScreen.skipLabel), findsOneWidget);
  return env;
}

Future<void> _submit(WidgetTester tester, String text) async {
  await tester.enterText(find.byType(TextField), text);
  await tester.tap(find.text(DescribeSituationScreen.submitLabel));
  await tester.pump();
}

void main() {
  testWidgets('lần đầu: hỏi đồng ý -> AI chọn mã -> phác đồ từ Drift, '
      'nguồn, cảnh báo; KHÔNG hiện văn bản LLM', (tester) async {
    final env = await _openDescribe(
      tester,
      settings: const AppSettings(),
      handler: (_) => _ok(_result()),
    );
    expect(find.text(DescribeSituationScreen.privacyNotice), findsOneWidget);

    await _submit(tester, 'tay bị bỏng do nước sôi');
    await _pumpUntil(tester, find.text(DescribeSituationScreen.consentTitle));
    expect(env.ai.calls, isEmpty); // chưa đồng ý thì chưa gửi
    await tester.tap(find.text(DescribeSituationScreen.consentAccept));
    await _pumpUntil(tester, find.text(DescribeSituationScreen.referenceLabel));

    expect(env.ai.calls, ['tay bị bỏng do nước sôi']);
    expect(env.settings.stored.aiPrivacyConsent, isTrue);
    expect(find.text(_burnsTitle), findsOneWidget);
    expect(find.textContaining('IFRC-2025'), findsWidgets);
    expect(find.text(ClinicalWarningBanner.message), findsOneWidget);
    expect(find.textContaining(_llmNote), findsNothing);

    await tester.tap(find.text('Mở hướng dẫn từng bước'));
    await settle(tester);
    expect(find.text('Bước 1/7'), findsOneWidget);
  });

  testWidgets('đã đồng ý thì không hỏi lại', (tester) async {
    final env = await _openDescribe(tester, handler: (_) => _ok(_result()));
    await _submit(tester, 'bị bỏng tay');
    await _pumpUntil(tester, find.text(DescribeSituationScreen.referenceLabel));
    expect(find.text(DescribeSituationScreen.consentTitle), findsNothing);
    expect(env.ai.calls, hasLength(1));
  });

  testWidgets('không đồng ý -> không gửi, gợi ý sàng lọc offline', (
    tester,
  ) async {
    final env = await _openDescribe(
      tester,
      settings: const AppSettings(),
      handler: (_) => _ok(_result()),
    );
    await _submit(tester, 'tay bị bỏng');
    await _pumpUntil(tester, find.text(DescribeSituationScreen.consentDecline));
    await tester.tap(find.text(DescribeSituationScreen.consentDecline));
    await _pumpUntil(
      tester,
      find.text(fallbackMessage(FallbackReason.consentDeclined)),
    );
    expect(env.ai.calls, isEmpty);
    expect(env.settings.stored.aiPrivacyConsent, isFalse);
  });

  testWidgets('đang xử lý: hiện tiến trình streaming; Bỏ qua -> sàng lọc '
      'ngay và hủy yêu cầu', (tester) async {
    var cancelled = false;
    final env = await _openDescribe(
      tester,
      handler: (_) {
        final c = StreamController<AiRouteEvent>(
          onCancel: () => cancelled = true,
        );
        c
          ..add(const AiRouteStatus(AiRouteStage.retrieved))
          ..add(const AiRouteStatus(AiRouteStage.aiSelecting))
          ..add(const AiRouteDelta(42));
        return c.stream; // không bao giờ có kết quả
      },
    );
    await _submit(tester, 'tay bị bỏng');
    await _pumpUntil(tester, find.text(stageLabel(AiRouteStage.aiSelecting)));
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(find.text('Đang nhận phản hồi (42 ký tự)'), findsOneWidget);
    expect(find.text(Call115Button.label), findsOneWidget);
    expect(env.ai.calls, hasLength(1));

    await tester.tap(find.text(DescribeSituationScreen.skipLabel));
    await settle(tester);
    expect(find.textContaining('phản ứng khi bạn gọi to'), findsOneWidget);
    expect(cancelled, isTrue);
  });

  testWidgets('Bỏ qua ngay khi chưa nhập gì -> sàng lọc', (tester) async {
    final env = await _openDescribe(tester);
    await tester.tap(find.text(DescribeSituationScreen.skipLabel));
    await settle(tester);
    expect(find.textContaining('phản ứng khi bạn gọi to'), findsOneWidget);
    expect(env.ai.calls, isEmpty);
  });

  testWidgets('mất mạng -> fallback ngay, không gọi AI; nút sàng lọc offline', (
    tester,
  ) async {
    final env = await _openDescribe(
      tester,
      connected: false,
      handler: (_) => _ok(_result()),
    );
    await _submit(tester, 'tay bị bỏng');
    await _pumpUntil(
      tester,
      find.text(fallbackMessage(FallbackReason.offline)),
    );
    expect(find.byIcon(Icons.wifi_off), findsWidgets);
    expect(env.ai.calls, isEmpty);
    await tester.tap(find.text('Bắt đầu sàng lọc offline'));
    await settle(tester);
    expect(find.textContaining('phản ứng khi bạn gọi to'), findsOneWidget);
  });

  final fallbackCases =
      <String, (Stream<AiRouteEvent> Function(String), FallbackReason)>{
        'uncertain': (
          (_) => _ok(
            _result(
              category: AiRouteCategory.outOfScope,
              code: null,
              uncertain: true,
            ),
          ),
          FallbackReason.uncertain,
        ),
        'mã không có trong cẩm nang': (
          (_) => _ok(_result(code: 'ma_bia_khong_ton_tai')),
          FallbackReason.codeNotAllowed,
        ),
        'timeout': (
          (_) => Stream.error(
            const AiRouteException(
              AiRouteFailureKind.timeout,
              code: 'llm_timeout',
            ),
          ),
          FallbackReason.timeout,
        ),
        'lỗi máy chủ (429/5xx)': (
          (_) => Stream.error(
            const AiRouteException(
              AiRouteFailureKind.server,
              code: 'llm_unavailable',
            ),
          ),
          FallbackReason.serverError,
        ),
        'chưa cấu hình AI_BASE_URL': (
          (_) => Stream.error(
            const AiRouteException(AiRouteFailureKind.notConfigured),
          ),
          FallbackReason.notConfigured,
        ),
      };
  for (final c in fallbackCases.entries) {
    testWidgets('${c.key} -> fallback sàng lọc + Gọi 115, không mở phác đồ', (
      tester,
    ) async {
      await _openDescribe(tester, handler: c.value.$1);
      await _submit(tester, 'tay bị bỏng');
      await _pumpUntil(tester, find.text(fallbackMessage(c.value.$2)));
      expect(find.text('Bắt đầu sàng lọc offline'), findsOneWidget);
      expect(find.text(Call115Button.label), findsOneWidget);
      expect(find.text('Mở hướng dẫn từng bước'), findsNothing);
      expect(find.text(DescribeSituationScreen.referenceLabel), findsNothing);
    });
  }

  testWidgets('từ khóa nguy cấp -> GỌI 115 NGAY, không hỏi đồng ý, '
      'không gửi mạng', (tester) async {
    final env = await _openDescribe(
      tester,
      settings: const AppSettings(),
      handler: (_) => _ok(_result()),
    );
    await _submit(tester, 'Người lớn bất tỉnh, không thở');
    await _pumpUntil(tester, find.textContaining('GỌI 115 NGAY'));
    expect(find.text(DescribeSituationScreen.consentTitle), findsNothing);
    expect(env.ai.calls, isEmpty);
    expect(find.textContaining('Trong lúc chờ:'), findsOneWidget);
    await tester.tap(find.text(Call115Button.label).first);
    await tester.pump();
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    expect(env.dialer.dialed, ['115']);
  });

  testWidgets('server rules call_115_now -> GỌI 115 NGAY', (tester) async {
    await _openDescribe(
      tester,
      handler: (_) => _ok(
        _result(
          category: AiRouteCategory.call115Now,
          code: null,
          uncertain: true,
        ),
      ),
    );
    await _submit(tester, 'mô tả mà máy không bắt được từ khóa');
    await _pumpUntil(tester, find.textContaining('GỌI 115 NGAY'));
    expect(find.textContaining('quy tắc cố định của máy chủ'), findsOneWidget);
    expect(find.textContaining('Trong lúc chờ:'), findsNothing);
  });

  testWidgets('ô trống -> báo lỗi nhập, không gọi AI', (tester) async {
    final env = await _openDescribe(tester, handler: (_) => _ok(_result()));
    await tester.tap(find.text(DescribeSituationScreen.submitLabel));
    await tester.pump();
    expect(find.text('Hãy nhập mô tả ngắn về tình huống.'), findsOneWidget);
    expect(env.ai.calls, isEmpty);
  });

  testWidgets('Dark Mode: kết quả hiển thị đủ chữ + icon', (tester) async {
    await _openDescribe(
      tester,
      settings: const AppSettings(
        themeMode: AppThemeMode.dark,
        aiPrivacyConsent: true,
      ),
      handler: (_) => _ok(_result()),
    );
    final ctx = tester.element(find.byType(DescribeSituationScreen));
    expect(Theme.of(ctx).brightness, Brightness.dark);
    await _submit(tester, 'bị bỏng tay');
    await _pumpUntil(tester, find.text(DescribeSituationScreen.referenceLabel));
    expect(find.byIcon(Icons.info_outline), findsOneWidget);
    expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
  });

  testWidgets('Cài đặt: bật/tắt đồng ý gửi mô tả, được lưu', (tester) async {
    _tallScreen(tester);
    final env = await createEnv(tester);
    await pumpFullApp(tester, env);
    await tester.tap(find.byIcon(Icons.settings));
    await settle(tester);
    await tester.tap(find.text('Gửi mô tả tình huống tới máy chủ AI'));
    await settle(tester);
    expect(env.settings.stored.aiPrivacyConsent, isTrue);
  });
}

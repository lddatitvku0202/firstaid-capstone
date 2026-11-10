import 'package:app/presentation/screens/describe_situation_screen.dart';
import 'package:app/presentation/screens/home_screen.dart';
import 'package:app/presentation/screens/protocol_detail_screen.dart';
import 'package:app/presentation/screens/protocol_list_screen.dart';
import 'package:app/presentation/screens/settings_screen.dart';
import 'package:app/presentation/screens/sos_screen.dart';
import 'package:app/presentation/screens/triage_screen.dart';
import 'package:app/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_app.dart';

/// Các màn chính (mở trực tiếp, không qua router).
final _screens = <String, Widget Function()>{
  'Home': () => const HomeScreen(),
  'Sàng lọc': () => const TriageScreen(),
  'Hướng dẫn CPR': () =>
      const ProtocolDetailScreen(code: 'cpr_adult_adolescent'),
  'Cẩm nang': () => const ProtocolListScreen(),
  'Cài đặt': () => const SettingsScreen(),
  'SOS': () => const SosScreen(),
  'Mô tả tình huống': () => const DescribeSituationScreen(),
};

/// Điện thoại nhỏ phổ biến: 360x800 dp.
void _phone(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.reset);
}

Future<void> _pump(
  WidgetTester tester,
  TestEnv env,
  Widget screen, {
  required Brightness brightness,
  double textScale = 1.0,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: env.overrides,
      child: MaterialApp(
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: brightness == Brightness.dark
            ? ThemeMode.dark
            : ThemeMode.light,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        ),
        home: screen,
      ),
    ),
  );
  await settle(tester);
}

/// Đoạn chữ bị cắt: chiều cao cần để vẽ hết > chiều cao được cấp.
/// (Flutter không báo lỗi khi nút có chiều cao cố định cắt mất chữ.)
List<String> _clippedTexts(WidgetTester tester) {
  final out = <String>[];
  for (final el in find.byType(RichText).evaluate()) {
    final rp = el.renderObject! as RenderParagraph;
    if (!rp.hasSize || rp.size.width == 0) continue;
    final needed = rp.getMinIntrinsicHeight(rp.size.width);
    if (needed > rp.size.height + 0.5) {
      out.add(
        '"${rp.text.toPlainText()}" cần ${needed.toStringAsFixed(1)} '
        'có ${rp.size.height.toStringAsFixed(1)}',
      );
    }
  }
  return out;
}

void main() {
  group('đối chứng: các kiểm tra thật sự bắt lỗi', () {
    testWidgets('nút 20x20 không nhãn, chữ tương phản thấp -> trượt', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: GestureDetector(
                      onTap: () {},
                      child: const ColoredBox(color: Colors.blue),
                    ),
                  ),
                ),
                const Text(
                  'mờ',
                  style: TextStyle(color: Color(0xFFFAFAFA), fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      );
      expect(
        await androidTapTargetGuideline.evaluate(tester),
        isA<Evaluation>().having((e) => e.passed, 'passed', isFalse),
      );
      expect(
        await labeledTapTargetGuideline.evaluate(tester),
        isA<Evaluation>().having((e) => e.passed, 'passed', isFalse),
      );
      expect(
        await textContrastGuideline.evaluate(tester),
        isA<Evaluation>().having((e) => e.passed, 'passed', isFalse),
      );
      handle.dispose();
    });

    testWidgets('chữ to trong nút cao cố định -> phát hiện bị cắt', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 200,
              height: 40,
              child: FilledButton(
                onPressed: () {},
                child: const Text(
                  'một nhãn rất dài sẽ phải xuống dòng',
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ),
          ),
        ),
      );
      expect(_clippedTexts(tester), isNotEmpty);
    });
  });

  for (final brightness in Brightness.values) {
    for (final e in _screens.entries) {
      testWidgets('${e.key} (${brightness.name}): tap target >= 48dp, '
          'nút có nhãn, contrast chữ đạt guideline', (tester) async {
        _phone(tester);
        final env = await createEnv(tester);
        final handle = tester.ensureSemantics();
        await _pump(tester, env, e.value(), brightness: brightness);
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        await expectLater(tester, meetsGuideline(textContrastGuideline));
        handle.dispose();
      });
    }
  }

  for (final e in _screens.entries) {
    testWidgets(
      '${e.key}: cỡ chữ 200% trên màn 360dp không tràn, không cắt chữ',
      (tester) async {
        _phone(tester);
        final env = await createEnv(tester);
        await _pump(
          tester,
          env,
          e.value(),
          brightness: Brightness.light,
          textScale: 2.0,
        );
        expect(tester.takeException(), isNull);
        final clipped = _clippedTexts(tester);
        expect(clipped, isEmpty, reason: clipped.join('; '));
      },
    );
  }
}

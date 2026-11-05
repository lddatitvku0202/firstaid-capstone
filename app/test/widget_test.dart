import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Home shows SOS button with icon and text', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: FirstAidApp()));
    await tester.pumpAndSettle();
    expect(find.text('SOS'), findsOneWidget);
    expect(find.byIcon(Icons.emergency), findsOneWidget);
  });
}

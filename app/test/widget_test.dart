import 'dart:io';

import 'package:app/core/di/providers.dart';
import 'package:app/data/datasources/local/app_database.dart';
import 'package:app/data/datasources/local/seed_loader.dart';
import 'package:app/main.dart';
import 'package:app/presentation/screens/protocol_detail_screen.dart';
import 'package:app/presentation/screens/protocol_list_screen.dart';
import 'package:app/presentation/widgets/clinical_warning_banner.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<AppDatabase> _seededDb(WidgetTester tester) async {
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  await tester.runAsync(
    () => SeedLoader(db, (p) => File(p).readAsString()).seedIfNeeded(),
  );
  addTearDown(() => tester.runAsync(db.close));
  return db;
}

void main() {
  testWidgets('Home shows SOS button with icon and text', (tester) async {
    final db = await _seededDb(tester);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const FirstAidApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('SOS'), findsOneWidget);
    expect(find.byIcon(Icons.emergency), findsOneWidget);
  });

  testWidgets('List screen shows clinical warning and protocols', (
    tester,
  ) async {
    final db = await _seededDb(tester);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: ProtocolListScreen()),
      ),
    );
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();
    expect(find.text(ClinicalWarningBanner.message), findsOneWidget);
    expect(find.text('Chảy máu nặng bên ngoài'), findsOneWidget);
  });

  testWidgets('Detail screen shows source, version and warning', (
    tester,
  ) async {
    final db = await _seededDb(tester);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const MaterialApp(
          home: ProtocolDetailScreen(code: 'burns_thermal_chemical'),
        ),
      ),
    );
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();
    expect(find.text(ClinicalWarningBanner.message), findsOneWidget);
    expect(find.textContaining('IFRC-2025'), findsWidgets);
    // ListView lazy: cuộn tới phần cuối (nguồn + phiên bản).
    await tester.scrollUntilVisible(
      find.textContaining('Phiên bản 1.0.0'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.textContaining('Phiên bản 1.0.0'), findsOneWidget);
  });
}

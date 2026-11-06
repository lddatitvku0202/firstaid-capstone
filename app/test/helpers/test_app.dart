import 'dart:async';
import 'dart:io';

import 'package:app/core/di/providers.dart';
import 'package:app/data/datasources/local/app_database.dart';
import 'package:app/data/datasources/local/seed_loader.dart';
import 'package:app/domain/entities/app_settings.dart';
import 'package:app/domain/repositories/settings_repository.dart';
import 'package:app/domain/services/connectivity_service.dart';
import 'package:app/domain/services/dialer_service.dart';
import 'package:app/domain/services/tts_service.dart';
import 'package:app/main.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';

class FakeTts implements TtsService {
  FakeTts([this.availability = TtsAvailability.available]);

  final TtsAvailability availability;
  final List<String> spoken = [];
  int stopCount = 0;

  @override
  Future<TtsAvailability> checkVietnamese() async => availability;

  @override
  Future<void> speak(String text) async => spoken.add(text);

  @override
  Future<void> stop() async => stopCount++;
}

class FakeConnectivity implements ConnectivityService {
  FakeConnectivity({this.connected = true});

  bool connected;
  final _controller = StreamController<bool>.broadcast();

  void emit(bool value) {
    connected = value;
    _controller.add(value);
  }

  @override
  Future<bool> isConnected() async => connected;

  @override
  Stream<bool> get onChanged => _controller.stream;
}

class FakeDialer implements DialerService {
  final List<String> dialed = [];

  @override
  Future<bool> openDialer(String number) async {
    dialed.add(number);
    return true;
  }
}

class FakeSettingsRepository implements SettingsRepository {
  FakeSettingsRepository([this.stored = const AppSettings()]);

  AppSettings stored;
  int saveCount = 0;

  @override
  Future<AppSettings> load() async => stored;

  @override
  Future<void> save(AppSettings settings) async {
    stored = settings;
    saveCount++;
  }
}

class TestEnv {
  TestEnv({
    required this.db,
    required this.tts,
    required this.connectivity,
    required this.dialer,
    required this.settings,
  });

  final AppDatabase db;
  final FakeTts tts;
  final FakeConnectivity connectivity;
  final FakeDialer dialer;
  final FakeSettingsRepository settings;

  List<Override> get overrides => [
    appDatabaseProvider.overrideWithValue(db),
    ttsServiceProvider.overrideWithValue(tts),
    connectivityServiceProvider.overrideWithValue(connectivity),
    dialerServiceProvider.overrideWithValue(dialer),
    settingsRepositoryProvider.overrideWithValue(settings),
  ];
}

Future<TestEnv> createEnv(
  WidgetTester tester, {
  TtsAvailability tts = TtsAvailability.available,
  bool connected = true,
}) async {
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  await tester.runAsync(
    () => SeedLoader(db, (p) => File(p).readAsString()).seedIfNeeded(),
  );
  addTearDown(() => tester.runAsync(db.close));
  return TestEnv(
    db: db,
    tts: FakeTts(tts),
    connectivity: FakeConnectivity(connected: connected),
    dialer: FakeDialer(),
    settings: FakeSettingsRepository(),
  );
}

Future<void> settle(WidgetTester tester) async {
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 20)),
  );
  await tester.pumpAndSettle();
}

Future<void> pumpFullApp(WidgetTester tester, TestEnv env) async {
  await tester.pumpWidget(
    ProviderScope(overrides: env.overrides, child: const FirstAidApp()),
  );
  await settle(tester);
}

Future<void> pumpScreen(WidgetTester tester, TestEnv env, Widget home) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: env.overrides,
      child: MaterialApp(home: home),
    ),
  );
  await settle(tester);
}

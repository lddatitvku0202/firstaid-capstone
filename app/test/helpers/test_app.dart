import 'dart:async';
import 'dart:io';

import 'package:app/core/di/providers.dart';
import 'package:app/data/datasources/local/app_database.dart';
import 'package:app/data/datasources/local/seed_loader.dart';
import 'package:app/domain/entities/ai_route.dart';
import 'package:app/domain/entities/app_settings.dart';
import 'package:app/domain/repositories/ai_router_repository.dart';
import 'package:app/domain/repositories/settings_repository.dart';
import 'package:app/domain/services/connectivity_service.dart';
import 'package:app/domain/services/dialer_service.dart';
import 'package:app/domain/services/location_service.dart';
import 'package:app/domain/services/sms_composer.dart';
import 'package:app/domain/services/tts_service.dart';
import 'package:app/main.dart';
import 'package:app/presentation/providers/settings_provider.dart';
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

class FakeLocation implements LocationService {
  FakeLocation([
    this.result = const LocationResult.ok(
      latitude: 16.0544,
      longitude: 108.2022,
      accuracyMeters: 12,
    ),
  ]);

  LocationResult result;
  int calls = 0;
  int openAppSettingsCalls = 0;
  int openLocationSettingsCalls = 0;

  @override
  Future<LocationResult> getCurrentLocation({
    Duration timeout = const Duration(seconds: 15),
  }) async {
    calls++;
    return result;
  }

  @override
  Future<void> openAppSettings() async => openAppSettingsCalls++;

  @override
  Future<void> openLocationSettings() async => openLocationSettingsCalls++;
}

class FakeSms implements SmsComposer {
  final List<String> drafts = [];
  final List<String?> recipients = [];

  @override
  Future<bool> openSmsDraft(String body, {String? recipient}) async {
    drafts.add(body);
    recipients.add(recipient);
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

/// Fake máy chủ AI: [handler] quyết định luồng sự kiện; ghi lại văn bản đã gửi.
class FakeAiRouter implements AiRouterRepository {
  FakeAiRouter([this.handler]);

  Stream<AiRouteEvent> Function(String text)? handler;
  final List<String> calls = [];

  @override
  Stream<AiRouteEvent> routeSituation(String text) {
    calls.add(text);
    final h = handler;
    if (h == null) {
      return Stream.error(
        const AiRouteException(AiRouteFailureKind.notConfigured),
      );
    }
    return h(text);
  }
}

class TestEnv {
  TestEnv({
    required this.ai,
    required this.db,
    required this.tts,
    required this.connectivity,
    required this.dialer,
    required this.settings,
    required this.location,
    required this.sms,
  });

  final AppDatabase db;
  final FakeTts tts;
  final FakeConnectivity connectivity;
  final FakeDialer dialer;
  final FakeSettingsRepository settings;
  final FakeLocation location;
  final FakeSms sms;
  final FakeAiRouter ai;

  List<Override> get overrides => [
    appDatabaseProvider.overrideWithValue(db),
    ttsServiceProvider.overrideWithValue(tts),
    connectivityServiceProvider.overrideWithValue(connectivity),
    dialerServiceProvider.overrideWithValue(dialer),
    settingsRepositoryProvider.overrideWithValue(settings),
    locationServiceProvider.overrideWithValue(location),
    smsComposerProvider.overrideWithValue(sms),
    clockProvider.overrideWithValue(() => DateTime(2026, 11, 7, 9, 30)),
    initialSettingsProvider.overrideWithValue(settings.stored),
    aiRouterRepositoryProvider.overrideWithValue(ai),
  ];
}

Future<TestEnv> createEnv(
  WidgetTester tester, {
  TtsAvailability tts = TtsAvailability.available,
  bool connected = true,
  LocationResult location = const LocationResult.ok(
    latitude: 16.0544,
    longitude: 108.2022,
    accuracyMeters: 12,
  ),
  AppSettings settings = const AppSettings(),
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
    settings: FakeSettingsRepository(settings),
    location: FakeLocation(location),
    sms: FakeSms(),
    ai: FakeAiRouter(),
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

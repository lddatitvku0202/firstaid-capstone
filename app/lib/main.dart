import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/di/providers.dart';
import 'data/datasources/local/app_database.dart';
import 'data/datasources/local/seed_loader.dart';
import 'data/repositories/shared_prefs_settings_repository.dart';
import 'presentation/providers/settings_provider.dart';
import 'presentation/router/app_router.dart';
import 'presentation/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase();
  await SeedLoader(db, rootBundle.loadString).seedIfNeeded();
  final settingsRepo = SharedPrefsSettingsRepository(
    await SharedPreferences.getInstance(),
  );
  final initial = await settingsRepo.load();
  runApp(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        settingsRepositoryProvider.overrideWithValue(settingsRepo),
        initialSettingsProvider.overrideWithValue(initial),
      ],
      child: const FirstAidApp(),
    ),
  );
}

class FirstAidApp extends ConsumerStatefulWidget {
  const FirstAidApp({super.key});

  @override
  ConsumerState<FirstAidApp> createState() => _FirstAidAppState();
}

class _FirstAidAppState extends ConsumerState<FirstAidApp> {
  late final GoRouter _router = buildRouter();

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    return MaterialApp.router(
      title: 'FirstAid',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: toFlutterThemeMode(settings.themeMode),
      routerConfig: _router,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(settings.textScale)),
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/app_settings.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final controller = ref.read(settingsProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: const Text('Cài đặt')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Giao diện', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            SegmentedButton<AppThemeMode>(
              segments: const [
                ButtonSegment(
                  value: AppThemeMode.system,
                  icon: Icon(Icons.brightness_auto),
                  label: Text('Hệ thống'),
                ),
                ButtonSegment(
                  value: AppThemeMode.light,
                  icon: Icon(Icons.light_mode),
                  label: Text('Sáng'),
                ),
                ButtonSegment(
                  value: AppThemeMode.dark,
                  icon: Icon(Icons.dark_mode),
                  label: Text('Tối'),
                ),
              ],
              selected: {settings.themeMode},
              onSelectionChanged: (s) => controller.setThemeMode(s.first),
            ),
            const SizedBox(height: 24),
            Text('Cỡ chữ', style: Theme.of(context).textTheme.titleMedium),
            Slider(
              min: AppSettings.minTextScale,
              max: AppSettings.maxTextScale,
              divisions: 13,
              value: settings.textScale,
              label: '${(settings.textScale * 100).round()}%',
              onChanged: controller.previewTextScale,
              onChangeEnd: controller.setTextScale,
            ),
            Text(
              'Chữ mẫu: ${(settings.textScale * 100).round()}%',
              textScaler: TextScaler.linear(settings.textScale),
            ),
            const SizedBox(height: 24),
            Text(
              'Quyền riêng tư',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: const Icon(Icons.cloud_upload_outlined),
              title: const Text('Gửi mô tả tình huống tới máy chủ AI'),
              subtitle: const Text(
                'Tắt thì "Mô tả tình huống" hỏi lại trước khi gửi. '
                'Sàng lọc và cẩm nang không cần gửi gì.',
              ),
              value: settings.aiPrivacyConsent,
              onChanged: controller.setAiPrivacyConsent,
            ),
          ],
        ),
      ),
    );
  }
}

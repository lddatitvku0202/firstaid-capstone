import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/network_chip.dart';
import '../widgets/sos_button.dart';

/// Home: không cần đăng nhập; nút khẩn cấp lớn ở vùng thumb (dưới màn hình).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FirstAid'),
        actions: [
          IconButton(
            tooltip: 'Cài đặt',
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: NetworkChip(),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  children: [
                    _EntryTile(
                      icon: Icons.menu_book,
                      title: 'Cẩm nang sơ cứu',
                      subtitle: 'Dùng được khi không có mạng',
                      onTap: () => context.push('/protocols'),
                    ),
                    _EntryTile(
                      icon: Icons.monitor_heart,
                      title: 'Hồi sinh tim phổi (CPR)',
                      subtitle: 'Mở thẳng hướng dẫn CPR',
                      onTap: () =>
                          context.push('/protocols/cpr_adult_adolescent'),
                    ),
                    _EntryTile(
                      icon: Icons.edit_note,
                      title: 'Mô tả tình huống',
                      subtitle:
                          'Chưa có (AI sẽ cần mạng; dùng sàng lọc bên dưới)',
                      enabled: false,
                      onTap: () {},
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Nội dung sơ cứu chưa được chuyên gia lâm sàng thẩm định.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              SosButton(onPressed: () => context.push('/triage')),
            ],
          ),
        ),
      ),
    );
  }
}

class _EntryTile extends StatelessWidget {
  const _EntryTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.enabled = true,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        minTileHeight: 64,
        enabled: enabled,
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: enabled ? const Icon(Icons.chevron_right) : null,
        onTap: enabled ? onTap : null,
      ),
    );
  }
}

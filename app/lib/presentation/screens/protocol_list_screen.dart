import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/protocol_providers.dart';
import '../widgets/clinical_warning_banner.dart';

class ProtocolListScreen extends ConsumerWidget {
  const ProtocolListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final protocols = ref.watch(protocolListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Cẩm nang sơ cứu')),
      body: protocols.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Không đọc được dữ liệu: $e')),
        data: (list) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (list.any((p) => p.requiresClinicalWarning))
              const ClinicalWarningBanner(),
            const SizedBox(height: 12),
            for (final p in list)
              Card(
                child: ListTile(
                  title: Text(p.title),
                  subtitle: Text('Phiên bản ${p.version}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/protocols/${p.code}'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

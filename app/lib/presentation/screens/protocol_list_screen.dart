import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/protocol_providers.dart';
import '../widgets/clinical_warning_banner.dart';

class ProtocolListScreen extends ConsumerStatefulWidget {
  const ProtocolListScreen({super.key});

  @override
  ConsumerState<ProtocolListScreen> createState() => _ProtocolListScreenState();
}

class _ProtocolListScreenState extends ConsumerState<ProtocolListScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final protocols = ref.watch(protocolSearchProvider(_query));
    return Scaffold(
      appBar: AppBar(title: const Text('Cẩm nang sơ cứu')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: TextField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  labelText: 'Tìm trong cẩm nang',
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            Expanded(
              child: protocols.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) =>
                    Center(child: Text('Không đọc được dữ liệu: $e')),
                data: (list) => ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (list.any((p) => p.requiresClinicalWarning))
                      const ClinicalWarningBanner(),
                    const SizedBox(height: 12),
                    if (list.isEmpty) const Text('Không tìm thấy kết quả.'),
                    for (final p in list)
                      Card(
                        child: ListTile(
                          minTileHeight: 64,
                          title: Text(p.title),
                          subtitle: Text('Phiên bản ${p.version}'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => context.push('/protocols/${p.code}'),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

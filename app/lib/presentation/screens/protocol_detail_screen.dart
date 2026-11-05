import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/cited_text.dart';
import '../../domain/entities/first_aid_protocol.dart';
import '../providers/protocol_providers.dart';
import '../widgets/clinical_warning_banner.dart';

class ProtocolDetailScreen extends ConsumerWidget {
  const ProtocolDetailScreen({required this.code, super.key});

  final String code;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final protocol = ref.watch(protocolDetailProvider(code));
    return Scaffold(
      appBar: AppBar(title: const Text('Hướng dẫn')),
      body: protocol.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Không đọc được dữ liệu: $e')),
        data: (p) => p == null
            ? const Center(child: Text('Không tìm thấy phác đồ.'))
            : _Body(protocol: p),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.protocol});

  final FirstAidProtocol protocol;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (protocol.requiresClinicalWarning) const ClinicalWarningBanner(),
        const SizedBox(height: 12),
        Text(protocol.title, style: text.headlineSmall),
        const SizedBox(height: 16),
        Text('Các bước', style: text.titleMedium),
        for (final s in protocol.steps)
          ListTile(
            leading: CircleAvatar(child: Text('${s.order}')),
            title: Text(s.text),
            subtitle: s.citation == null ? null : Text(s.citation!),
          ),
        _Section(title: 'Không nên làm', items: protocol.doNot),
        _Section(title: 'Khi nào gọi 115', items: protocol.call115Conditions),
        const Divider(),
        Text('Nguồn', style: text.titleMedium),
        for (final c in protocol.citations) Text('$c'),
        Text('Phiên bản ${protocol.version} • cập nhật ${protocol.updatedAt}'),
        if (protocol.notes != null) Text('Ghi chú: ${protocol.notes}'),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.items});

  final String title;
  final List<CitedText> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        for (final i in items)
          ListTile(
            leading: const Icon(Icons.chevron_right),
            title: Text(i.text),
            subtitle: i.citation == null ? null : Text(i.citation!),
          ),
      ],
    );
  }
}

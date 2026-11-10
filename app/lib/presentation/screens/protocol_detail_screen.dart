import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/providers.dart';
import '../../domain/entities/cited_text.dart';
import '../../domain/entities/first_aid_protocol.dart';
import '../../domain/services/tts_service.dart';
import '../providers/protocol_providers.dart';
import '../widgets/call_115_button.dart';
import '../widgets/clinical_warning_banner.dart';

/// Hướng dẫn từng bước: một hành động mỗi bước, đọc to (vi-VN), nguồn + version.
class ProtocolDetailScreen extends ConsumerWidget {
  const ProtocolDetailScreen({required this.code, super.key});

  final String code;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final protocol = ref.watch(protocolDetailProvider(code));
    return Scaffold(
      appBar: AppBar(title: const Text('Hướng dẫn')),
      body: SafeArea(
        child: protocol.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Không đọc được dữ liệu: $e')),
          data: (p) => p == null
              ? const Center(child: Text('Không tìm thấy phác đồ.'))
              : _Body(protocol: p),
        ),
      ),
    );
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body({required this.protocol});

  final FirstAidProtocol protocol;

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> {
  int _index = 0;

  late final TtsService _tts;

  @override
  void initState() {
    super.initState();
    // Lưu service vào field: không dùng ref trong dispose().
    _tts = ref.read(ttsServiceProvider);
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.protocol;
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final step = p.steps[_index];
    final availability = ref.watch(ttsAvailabilityProvider).value;

    final list = ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (p.requiresClinicalWarning) const ClinicalWarningBanner(),
        const SizedBox(height: 12),
        Text(p.title, style: text.headlineSmall),
        const SizedBox(height: 16),
        Card(
          color: scheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bước ${_index + 1}/${p.steps.length}',
                  style: text.titleMedium?.copyWith(
                    color: scheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  step.text,
                  style: text.headlineSmall?.copyWith(
                    color: scheme.onPrimaryContainer,
                  ),
                ),
                if (step.citation != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Nguồn: ${step.citation}',
                    style: text.bodySmall?.copyWith(
                      color: scheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _Section(title: 'KHÔNG ĐƯỢC LÀM', icon: Icons.block, items: p.doNot),
        _Section(
          title: 'Khi nào gọi 115',
          icon: Icons.call,
          items: p.call115Conditions,
        ),
        const SizedBox(height: 16),
        const Call115Button(),
        const Divider(height: 32),
        Text('Nguồn', style: text.titleMedium),
        for (final c in p.citations) Text('$c'),
        Text('Phiên bản ${p.version} • cập nhật ${p.updatedAt}'),
        if (p.notes != null) Text('Ghi chú: ${p.notes}'),
      ],
    );
    return Column(
      children: [
        Expanded(child: list),
        Material(
          elevation: 8,
          color: scheme.surface,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (availability == TtsAvailability.vietnameseMissing ||
                      availability == TtsAvailability.unavailable)
                    const _TtsNotice(),
                  ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 56),
                    child: OutlinedButton.icon(
                      onPressed: availability == TtsAvailability.available
                          ? () => _tts.speak(step.text)
                          : null,
                      icon: const Icon(Icons.volume_up),
                      label: const Text('Đọc to'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 56),
                          child: FilledButton.tonalIcon(
                            onPressed: _index > 0
                                ? () => _go(_index - 1)
                                : null,
                            icon: const Icon(Icons.arrow_back),
                            label: const Text('Trước'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 56),
                          child: FilledButton.icon(
                            onPressed: _index < p.steps.length - 1
                                ? () => _go(_index + 1)
                                : null,
                            icon: const Icon(Icons.arrow_forward),
                            label: const Text('Tiếp'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _go(int i) {
    _tts.stop();
    setState(() => _index = i);
  }
}

class _TtsNotice extends StatelessWidget {
  const _TtsNotice();

  static const message =
      'Thiết bị chưa có giọng đọc tiếng Việt (vi-VN), nên không đọc to được. '
      'Nội dung vẫn hiển thị bằng chữ.';

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline),
          SizedBox(width: 8),
          Expanded(child: Text(message)),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.icon,
    required this.items,
  });

  final String title;
  final IconData icon;
  final List<CitedText> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(icon),
            const SizedBox(width: 8),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
        for (final i in items)
          ListTile(
            leading: Icon(icon),
            title: Text(i.text),
            subtitle: i.citation == null ? null : Text(i.citation!),
          ),
      ],
    );
  }
}

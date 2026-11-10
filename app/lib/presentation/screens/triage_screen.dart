import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/providers.dart';
import '../../domain/entities/triage_node.dart';
import '../widgets/call_115_button.dart';

/// Sàng lọc theo cây quyết định tĩnh (luật xác định, không phải AI).
class TriageScreen extends ConsumerStatefulWidget {
  const TriageScreen({super.key});

  @override
  ConsumerState<TriageScreen> createState() => _TriageScreenState();
}

class _TriageScreenState extends ConsumerState<TriageScreen> {
  TriageNode? _node;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    try {
      final c = await ref.read(startEmergencyFlowProvider).call();
      if (mounted) setState(() => _node = c.rootNode);
    } on Object catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  Future<void> _answer(bool yes) async {
    final current = _node;
    if (current == null) return;
    final next = await ref
        .read(advanceTriageProvider)
        .call(current, answerYes: yes);
    if (mounted && next != null) setState(() => _node = next);
  }

  @override
  Widget build(BuildContext context) {
    final node = _node;
    return Scaffold(
      appBar: AppBar(title: const Text('Sàng lọc khẩn cấp')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _error != null
              ? const Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Không đọc được dữ liệu sàng lọc. Hãy gọi 115 nếu nguy hiểm.',
                    ),
                    Spacer(),
                    Call115Button(),
                  ],
                )
              : node == null
              ? const Center(child: CircularProgressIndicator())
              : _NodeView(node: node, onAnswer: _answer),
        ),
      ),
    );
  }
}

class _NodeView extends StatelessWidget {
  const _NodeView({required this.node, required this.onAnswer});

  final TriageNode node;
  final Future<void> Function(bool yes) onAnswer;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final children = <Widget>[
      Text(node.question, style: text.headlineSmall),
      const SizedBox(height: 16),
    ];
    if (node.isLeaf) {
      if (node.note != null) {
        children.addAll([Text(node.note!), const SizedBox(height: 16)]);
      }
      if (node.protocolCode != null) {
        children.add(
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 64),
            child: FilledButton.icon(
              onPressed: () => context.push('/protocols/${node.protocolCode}'),
              icon: const Icon(Icons.list_alt),
              label: const Text('Xem hướng dẫn từng bước'),
            ),
          ),
        );
        children.add(const SizedBox(height: 12));
      }
    } else {
      children.addAll([
        _AnswerButton(
          label: 'Có',
          icon: Icons.check,
          onPressed: () => onAnswer(true),
        ),
        const SizedBox(height: 12),
        _AnswerButton(
          label: 'Không',
          icon: Icons.close,
          onPressed: () => onAnswer(false),
        ),
      ]);
    }
    // Luôn có nút Gọi 115 ngay ở cuối mọi bước sàng lọc.
    return ListView(
      children: [
        ...children,
        const SizedBox(height: 24),
        const Call115Button(),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 56),
          child: OutlinedButton.icon(
            onPressed: () => context.push('/sos'),
            icon: const Icon(Icons.sms),
            label: const Text('SOS: gửi vị trí'),
          ),
        ),
      ],
    );
  }
}

class _AnswerButton extends StatelessWidget {
  const _AnswerButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 72),
      child: FilledButton.tonalIcon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label, style: Theme.of(context).textTheme.titleLarge),
      ),
    );
  }
}

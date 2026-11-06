import 'package:flutter/material.dart';

/// Nút KHẨN CẤP lớn: có icon + chữ, không chỉ dựa vào màu.
class SosButton extends StatelessWidget {
  const SosButton({required this.onPressed, super.key});

  static const label = 'KHẨN CẤP';

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      label: 'Khẩn cấp, bắt đầu sàng lọc',
      child: SizedBox(
        width: double.infinity,
        height: 120,
        child: FilledButton.icon(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: scheme.error,
            foregroundColor: scheme.onError,
            textStyle: Theme.of(context).textTheme.headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          icon: const Icon(Icons.emergency, size: 40),
          label: const Text(label),
        ),
      ),
    );
  }
}

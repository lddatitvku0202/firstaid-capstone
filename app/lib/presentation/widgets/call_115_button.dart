import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/providers.dart';

/// "Gọi 115 ngay": mở trình quay số, người dùng tự bấm gọi.
class Call115Button extends ConsumerWidget {
  const Call115Button({super.key});

  static const label = 'Gọi 115 ngay';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.error,
          foregroundColor: scheme.onError,
          textStyle: Theme.of(context).textTheme.titleLarge,
        ),
        onPressed: () async {
          final messenger = ScaffoldMessenger.of(context);
          final ok = await ref.read(dialerServiceProvider).openDialer('115');
          if (!ok) {
            messenger.showSnackBar(
              const SnackBar(
                content: Text('Không mở được trình quay số. Hãy tự gọi 115.'),
              ),
            );
          }
        },
        icon: const Icon(Icons.call),
        label: const Text(label),
      ),
    );
  }
}

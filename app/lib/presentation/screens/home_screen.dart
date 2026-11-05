import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/sos_button.dart';

/// Màn Home (skeleton). SOS chưa triển khai; cẩm nang đọc từ Drift offline.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FirstAid')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SosButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Chế độ khẩn cấp: chưa triển khai'),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => context.push('/protocols'),
              icon: const Icon(Icons.menu_book),
              label: const Text('Cẩm nang sơ cứu (offline)'),
            ),
            const SizedBox(height: 16),
            Text(
              'Nội dung sơ cứu chưa được thẩm định chuyên môn.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

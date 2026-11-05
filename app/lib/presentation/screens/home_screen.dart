import 'package:flutter/material.dart';

import '../widgets/sos_button.dart';

/// Màn Home rỗng (skeleton). Chưa có nội dung y khoa.
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

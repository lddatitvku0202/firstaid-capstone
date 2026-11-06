import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/protocol_providers.dart';

/// Chip trạng thái mạng: icon + chữ (không chỉ dựa vào màu).
/// Phản ánh thiết bị có kết nối, không đảm bảo có Internet.
class NetworkChip extends ConsumerWidget {
  const NetworkChip({super.key});

  static const onlineLabel = 'Có kết nối mạng';
  static const offlineLabel = 'Không có mạng (cẩm nang vẫn dùng được)';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connected = ref.watch(connectivityProvider).value;
    final (icon, label) = switch (connected) {
      true => (Icons.wifi, onlineLabel),
      false => (Icons.wifi_off, offlineLabel),
      null => (Icons.sync, 'Đang kiểm tra mạng'),
    };
    return Chip(avatar: Icon(icon, size: 18), label: Text(label));
  }
}

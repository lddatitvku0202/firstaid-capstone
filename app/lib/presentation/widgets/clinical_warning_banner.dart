import 'package:flutter/material.dart';

/// Cảnh báo bắt buộc khi clinical_review != reviewed (CLAUDE.md §6).
/// Có icon + chữ, không chỉ dựa vào màu.
class ClinicalWarningBanner extends StatelessWidget {
  const ClinicalWarningBanner({super.key});

  static const message =
      'Chưa được chuyên gia lâm sàng thẩm định. Đây là bản tóm lược của nhóm '
      'từ tài liệu nguồn, không thay thế nhân viên y tế. '
      'Trường hợp nguy hiểm: gọi 115.';

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      container: true,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: scheme.errorContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: scheme.error),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.warning_amber_rounded, color: scheme.onErrorContainer),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: scheme.onErrorContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

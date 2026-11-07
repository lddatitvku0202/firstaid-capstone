import 'package:url_launcher/url_launcher.dart';

import '../../domain/services/sms_composer.dart';

/// Dựng URI `sms:` an toàn. Dùng %20 (không dùng '+') cho khoảng trắng vì một
/// số ứng dụng SMS hiển thị nguyên dấu '+'. Tách riêng để test mã hóa.
Uri buildSmsUri(String body, {String? recipient}) => Uri(
  scheme: 'sms',
  path: (recipient ?? '').trim(),
  query: 'body=${Uri.encodeComponent(body)}',
);

class UrlLauncherSmsComposer implements SmsComposer {
  const UrlLauncherSmsComposer();

  @override
  Future<bool> openSmsDraft(String body, {String? recipient}) async {
    try {
      return await launchUrl(buildSmsUri(body, recipient: recipient));
    } on Object {
      return false;
    }
  }
}

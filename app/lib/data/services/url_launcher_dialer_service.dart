import 'package:url_launcher/url_launcher.dart';

import '../../domain/services/dialer_service.dart';

class UrlLauncherDialerService implements DialerService {
  const UrlLauncherDialerService();

  @override
  Future<bool> openDialer(String number) async {
    try {
      return await launchUrl(Uri(scheme: 'tel', path: number));
    } on Object {
      return false;
    }
  }
}

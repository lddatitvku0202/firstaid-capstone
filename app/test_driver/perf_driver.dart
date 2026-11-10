// Driver cho integration_test/perf_test.dart (chạy bằng `flutter drive --profile`).
// Ghi mỗi báo cáo watchPerformance ra build/<reportKey>.json.
import 'package:integration_test/integration_test_driver.dart';

Future<void> main() => integrationDriver(
  responseDataCallback: (data) async {
    if (data == null) return;
    for (final entry in data.entries) {
      final value = entry.value;
      if (value is Map<String, dynamic>) {
        await writeResponseData(value, testOutputFilename: entry.key);
      }
    }
  },
);

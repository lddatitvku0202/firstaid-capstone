import 'dart:async';

import '../services/connectivity_service.dart';
import 'process_sync_queue.dart';
import 'sync_protocols.dart';

/// Chạy đồng bộ khi khởi động (nếu có kết nối) và mỗi khi kết nối quay lại.
/// Không bao giờ ném lỗi ra ngoài: sync lỗi thì app vẫn dùng bản local.
class RunSync {
  RunSync({
    required this.connectivity,
    required this.syncProtocols,
    required this.processQueue,
    required this.clock,
  });

  final ConnectivityService connectivity;
  final SyncProtocols syncProtocols;
  final ProcessSyncQueue processQueue;
  final DateTime Function() clock;

  StreamSubscription<bool>? _sub;
  bool _running = false;

  /// Một lượt đồng bộ. Trả false nếu bỏ qua (không có kết nối / đang chạy).
  Future<bool> runOnce() async {
    if (_running) return false;
    _running = true;
    try {
      if (!await connectivity.isConnected()) return false;
      await syncProtocols();
      await processQueue(now: clock());
      return true;
    } on Object {
      return false;
    } finally {
      _running = false;
    }
  }

  void start() {
    unawaited(runOnce());
    _sub ??= connectivity.onChanged.listen((connected) {
      if (connected) unawaited(runOnce());
    });
  }

  Future<void> dispose() async => _sub?.cancel();
}

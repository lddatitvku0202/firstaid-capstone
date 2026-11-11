import 'dart:async';

import '../entities/ai_route.dart';
import '../entities/first_aid_protocol.dart';
import '../repositories/ai_router_repository.dart';
import '../repositories/protocol_repository.dart';
import '../services/connectivity_service.dart';
import 'detect_emergency_keywords.dart';

/// Lý do quay về sàng lọc tĩnh (cây quyết định offline).
enum FallbackReason {
  emptyInput,
  consentDeclined,
  offline,
  timeout,
  serverError,
  invalidResponse,
  uncertain,
  codeNotAllowed,
  notConfigured,
}

/// Ai đã phát hiện tình huống cần gọi 115.
enum Call115Source { localKeywords, serverRules }

sealed class RouteSituationOutcome {
  const RouteSituationOutcome();
}

/// AI chọn được mã có trong cẩm nang trên máy. Nội dung hiển thị lấy từ
/// [protocol] (Drift), không từ AI.
class RoutedToProtocol extends RouteSituationOutcome {
  const RoutedToProtocol(this.protocol, this.result);
  final FirstAidProtocol protocol;
  final AiRouteResult result;
}

/// Dấu hiệu nguy cấp: gọi 115 ngay. [protocol] có khi xác định được tuổi.
class EmergencyCall115 extends RouteSituationOutcome {
  const EmergencyCall115(this.source, [this.protocol]);
  final Call115Source source;
  final FirstAidProtocol? protocol;
}

class FallbackToTriage extends RouteSituationOutcome {
  const FallbackToTriage(this.reason);
  final FallbackReason reason;
}

sealed class RouteSituationUpdate {
  const RouteSituationUpdate();
}

class RouteProgress extends RouteSituationUpdate {
  const RouteProgress(this.stage, {this.receivedChars = 0});
  final AiRouteStage stage;

  /// Số ký tự đầu ra tạm đã nhận (streaming); không hiển thị nội dung.
  final int receivedChars;
}

class RouteDone extends RouteSituationUpdate {
  const RouteDone(this.outcome);
  final RouteSituationOutcome outcome;
}

/// Định tuyến mô tả tình huống tới phác đồ cục bộ, với fallback an toàn.
///
/// Thứ tự: rỗng -> từ khóa nguy cấp (trên máy, không gửi mạng) -> AI đã được
/// cấu hình (chưa thì fallback ngay, không hỏi đồng ý) -> có mạng
/// -> người dùng đồng ý gửi -> gọi AI (deadline tổng) -> kiểm tra kết quả với
/// allowlist là các phác đồ trong Drift. Không bao giờ ném lỗi: luôn kết thúc
/// bằng đúng một [RouteDone].
class RouteSituation {
  const RouteSituation(
    this._ai,
    this._protocols,
    this._connectivity, {
    this.timeout = const Duration(seconds: 15),
  });

  static const maxLength = 1000;

  final AiRouterRepository _ai;
  final ProtocolRepository _protocols;
  final ConnectivityService _connectivity;
  final Duration timeout;

  /// [confirmRemote] chỉ được gọi ngay trước khi gửi văn bản lên mạng
  /// (UI hỏi đồng ý ở lần đầu); trả false thì không gửi.
  Stream<RouteSituationUpdate> call(
    String text, {
    required Future<bool> Function() confirmRemote,
  }) async* {
    final input = text.trim();
    if (input.isEmpty) {
      yield const RouteDone(FallbackToTriage(FallbackReason.emptyInput));
      return;
    }

    final local = detectEmergencyKeywords(input);
    if (local != null) {
      yield RouteDone(
        EmergencyCall115(
          Call115Source.localKeywords,
          await _lookup(local.protocolCode),
        ),
      );
      return;
    }

    // R-33: bản build không có AI_BASE_URL không gửi gì lên mạng, nên không
    // kiểm tra mạng và không hỏi đồng ý.
    if (!_ai.isConfigured) {
      yield const RouteDone(FallbackToTriage(FallbackReason.notConfigured));
      return;
    }

    if (!await _safeIsConnected()) {
      yield const RouteDone(FallbackToTriage(FallbackReason.offline));
      return;
    }
    bool allowed;
    try {
      allowed = await confirmRemote();
    } on Object {
      allowed = false;
    }
    if (!allowed) {
      yield const RouteDone(FallbackToTriage(FallbackReason.consentDeclined));
      return;
    }

    final payload = input.length > maxLength
        ? input.substring(0, maxLength)
        : input;
    // yield* chuyển tiếp việc hủy NGAY tới luồng mạng (await for thì không).
    yield* _remote(payload);
  }

  Future<RouteSituationOutcome> _evaluate(AiRouteResult r) async {
    if (r.category == AiRouteCategory.call115Now) {
      return EmergencyCall115(
        Call115Source.serverRules,
        await _lookup(r.protocolCode),
      );
    }
    final code = r.protocolCode;
    if (r.uncertain ||
        code == null ||
        r.category == AiRouteCategory.outOfScope) {
      return const FallbackToTriage(FallbackReason.uncertain);
    }
    final protocol = await _lookup(code);
    if (protocol == null) {
      return const FallbackToTriage(FallbackReason.codeNotAllowed);
    }
    if (protocol.topicId != r.category.wireName) {
      return const FallbackToTriage(FallbackReason.invalidResponse);
    }
    return RoutedToProtocol(protocol, r);
  }

  /// Allowlist = phác đồ đang có trong CSDL cục bộ.
  Future<FirstAidProtocol?> _lookup(String? code) async {
    if (code == null) return null;
    try {
      return await _protocols.getProtocolByCode(code);
    } on Object {
      return null;
    }
  }

  Future<bool> _safeIsConnected() async {
    try {
      return await _connectivity.isConnected();
    } on Object {
      // Không biết trạng thái: vẫn thử gọi; lỗi mạng sẽ được fallback.
      return true;
    }
  }

  static FallbackReason _reasonFor(AiRouteFailureKind k) => switch (k) {
    AiRouteFailureKind.network => FallbackReason.offline,
    AiRouteFailureKind.timeout => FallbackReason.timeout,
    AiRouteFailureKind.server => FallbackReason.serverError,
    AiRouteFailureKind.invalidResponse => FallbackReason.invalidResponse,
    AiRouteFailureKind.notConfigured => FallbackReason.notConfigured,
  };

  /// Phần gọi mạng. Deadline tính cho TOÀN BỘ yêu cầu (không phải từng sự
  /// kiện). Hủy subscription (người dùng bấm Bỏ qua) hoặc hết giờ thì hủy
  /// ngay subscription nguồn (=> đóng kết nối HTTP). Luôn kết thúc bằng
  /// đúng một [RouteDone].
  Stream<RouteSituationUpdate> _remote(String payload) {
    late final StreamController<RouteSituationUpdate> out;
    StreamSubscription<AiRouteEvent>? sub;
    Timer? timer;
    var cancelled = false;
    var stage = AiRouteStage.sending;
    var chars = 0;

    void stop() {
      timer?.cancel();
      timer = null;
      final s = sub;
      sub = null;
      s?.cancel();
    }

    void done(RouteSituationOutcome o) {
      stop();
      if (cancelled || out.isClosed) return;
      out
        ..add(RouteDone(o))
        ..close();
    }

    void progress() {
      if (!cancelled && !out.isClosed) {
        out.add(RouteProgress(stage, receivedChars: chars));
      }
    }

    void onEvent(AiRouteEvent ev) {
      switch (ev) {
        case AiRouteStatus(stage: final s):
          stage = s;
          progress();
        case AiRouteDelta(:final length):
          chars += length;
          stage = AiRouteStage.aiSelecting;
          progress();
        case AiRouteFinal(:final result):
          stop(); // bỏ qua mọi sự kiện sau kết quả
          _evaluate(result).then(
            done,
            onError: (Object _) =>
                done(const FallbackToTriage(FallbackReason.serverError)),
          );
      }
    }

    out = StreamController<RouteSituationUpdate>(
      onListen: () {
        progress(); // sending
        timer = Timer(
          timeout,
          () => done(const FallbackToTriage(FallbackReason.timeout)),
        );
        try {
          sub = _ai
              .routeSituation(payload)
              .listen(
                onEvent,
                onError: (Object e) => done(
                  FallbackToTriage(
                    e is AiRouteException
                        ? _reasonFor(e.kind)
                        : FallbackReason.serverError,
                  ),
                ),
                onDone: () => done(
                  const FallbackToTriage(FallbackReason.invalidResponse),
                ),
              );
        } on Object {
          done(const FallbackToTriage(FallbackReason.serverError));
        }
      },
      onCancel: () {
        cancelled = true;
        stop();
      },
    );
    return out.stream;
  }
}

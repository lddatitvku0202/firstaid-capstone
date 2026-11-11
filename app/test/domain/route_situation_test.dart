import 'dart:async';

import 'package:app/domain/entities/ai_route.dart';
import 'package:app/domain/entities/first_aid_protocol.dart';
import 'package:app/domain/entities/protocol_step.dart';
import 'package:app/domain/entities/source_citation.dart';
import 'package:app/domain/repositories/ai_router_repository.dart';
import 'package:app/domain/repositories/protocol_repository.dart';
import 'package:app/domain/services/connectivity_service.dart';
import 'package:app/domain/usecases/detect_emergency_keywords.dart';
import 'package:app/domain/usecases/route_situation.dart';
import 'package:flutter_test/flutter_test.dart';

FirstAidProtocol _p(String code, String topic) => FirstAidProtocol(
  code: code,
  title: 'T-$code',
  topicId: topic,
  severity: 'urgent',
  targetAudience: 'x',
  ageGroup: 'all',
  version: '1',
  updatedAt: '2026-11-06',
  steps: const [ProtocolStep(order: 1, text: 'x')],
);

/// Allowlist cục bộ: chỉ 3 mã này "có trong Drift".
class _LocalProtocols implements ProtocolRepository {
  final _all = {
    'burns_thermal_chemical': _p('burns_thermal_chemical', 'burns'),
    'cpr_adult_adolescent': _p('cpr_adult_adolescent', 'cardiac_arrest_cpr'),
    'choking_baby': _p('choking_baby', 'choking'),
  };

  @override
  Future<List<FirstAidProtocol>> getOfflineProtocols() async =>
      _all.values.toList();

  @override
  Future<FirstAidProtocol?> getProtocolByCode(String code) async => _all[code];
}

class _Connectivity implements ConnectivityService {
  _Connectivity(this.connected);
  final bool connected;

  @override
  Future<bool> isConnected() async => connected;

  @override
  Stream<bool> get onChanged => const Stream.empty();
}

class _FakeAi implements AiRouterRepository {
  _FakeAi(this.handler, {this.configured = true});
  final Stream<AiRouteEvent> Function(String) handler;
  final bool configured;
  final calls = <String>[];

  @override
  bool get isConfigured => configured;

  @override
  Stream<AiRouteEvent> routeSituation(String text) {
    calls.add(text);
    return handler(text);
  }
}

AiRouteResult _result({
  AiRouteCategory category = AiRouteCategory.burns,
  String? code = 'burns_thermal_chemical',
  bool uncertain = false,
}) => AiRouteResult(
  category: category,
  protocolCode: code,
  confidenceNote: 'ghi chú LLM',
  sources: const [SourceCitation(sourceId: 'IFRC-2025', pages: '288-290')],
  uncertain: uncertain,
);

Stream<AiRouteEvent> _final(AiRouteResult r) => Stream.fromIterable([
  const AiRouteStatus(AiRouteStage.received),
  const AiRouteStatus(AiRouteStage.retrieved),
  const AiRouteDelta(5),
  const AiRouteDelta(7),
  AiRouteFinal(r),
]);

Future<bool> _yes() async => true;
Future<bool> _no() async => false;

void main() {
  late _FakeAi ai;

  Future<List<RouteSituationUpdate>> run(
    Stream<AiRouteEvent> Function(String) handler, {
    String text = 'tay bị bỏng do nước sôi',
    bool connected = true,
    Future<bool> Function() confirm = _yes,
    Duration timeout = const Duration(seconds: 5),
    bool configured = true,
  }) {
    ai = _FakeAi(handler, configured: configured);
    final uc = RouteSituation(
      ai,
      _LocalProtocols(),
      _Connectivity(connected),
      timeout: timeout,
    );
    return uc.call(text, confirmRemote: confirm).toList();
  }

  RouteSituationOutcome outcome(List<RouteSituationUpdate> u) {
    expect(u.whereType<RouteDone>(), hasLength(1));
    expect(u.last, isA<RouteDone>());
    return (u.last as RouteDone).outcome;
  }

  FallbackReason reason(List<RouteSituationUpdate> u) =>
      (outcome(u) as FallbackToTriage).reason;

  group('RouteSituation', () {
    test('thành công: mở phác đồ từ allowlist cục bộ, có tiến trình', () async {
      final u = await run((_) => _final(_result()));
      final o = outcome(u) as RoutedToProtocol;
      expect(o.protocol.code, 'burns_thermal_chemical');
      expect(o.protocol.title, 'T-burns_thermal_chemical'); // từ repo cục bộ
      final progress = u.whereType<RouteProgress>().toList();
      expect(progress.first.stage, AiRouteStage.sending);
      expect(progress.map((p) => p.stage), contains(AiRouteStage.retrieved));
      expect(progress.last.stage, AiRouteStage.aiSelecting);
      expect(progress.last.receivedChars, 12);
      expect(ai.calls.single, 'tay bị bỏng do nước sôi');
    });

    test('uncertain (null + out_of_scope) -> sàng lọc tĩnh', () async {
      final u = await run(
        (_) => _final(
          _result(
            category: AiRouteCategory.outOfScope,
            code: null,
            uncertain: true,
          ),
        ),
      );
      expect(reason(u), FallbackReason.uncertain);
    });

    test('uncertain=true dù có mã -> vẫn fallback', () async {
      final u = await run((_) => _final(_result(uncertain: true)));
      expect(reason(u), FallbackReason.uncertain);
    });

    test('timeout tổng: hết giờ thì fallback và hủy yêu cầu', () async {
      var cancelled = false;
      final c = StreamController<AiRouteEvent>(
        onCancel: () => cancelled = true,
      );
      final u = await run((_) {
        c.add(const AiRouteStatus(AiRouteStage.received));
        return c.stream; // không bao giờ có kết quả
      }, timeout: const Duration(milliseconds: 50));
      expect(reason(u), FallbackReason.timeout);
      expect(cancelled, isTrue);
    });

    test('server báo timeout (llm_timeout) -> fallback timeout', () async {
      final u = await run(
        (_) => Stream.error(
          const AiRouteException(
            AiRouteFailureKind.timeout,
            code: 'llm_timeout',
          ),
        ),
      );
      expect(reason(u), FallbackReason.timeout);
    });

    test('mã sai (không có trong allowlist cục bộ) -> fallback', () async {
      final u = await run((_) => _final(_result(code: 'snake_bite_made_up')));
      expect(reason(u), FallbackReason.codeNotAllowed);
    });

    test('mã có nhưng chủ đề không khớp category -> fallback', () async {
      final u = await run(
        (_) => _final(_result(category: AiRouteCategory.choking)),
      );
      expect(reason(u), FallbackReason.invalidResponse);
    });

    test('server rules call_115_now -> Gọi 115 + phác đồ nếu có', () async {
      final u = await run(
        (_) => _final(
          _result(
            category: AiRouteCategory.call115Now,
            code: 'cpr_adult_adolescent',
          ),
        ),
      );
      final o = outcome(u) as EmergencyCall115;
      expect(o.source, Call115Source.serverRules);
      expect(o.protocol?.code, 'cpr_adult_adolescent');
    });

    test('từ khóa nguy cấp: Gọi 115 ngay trên máy, KHÔNG gửi mạng', () async {
      var asked = false;
      final u = await run(
        (_) => _final(_result()),
        text: 'Người lớn bất tỉnh, không thở',
        connected: false,
        confirm: () async => asked = true,
      );
      final o = outcome(u) as EmergencyCall115;
      expect(o.source, Call115Source.localKeywords);
      expect(o.protocol?.code, 'cpr_adult_adolescent');
      expect(ai.calls, isEmpty);
      expect(asked, isFalse);
    });

    test(
      'từ khóa nguy cấp không rõ tuổi: Gọi 115, không đoán phác đồ',
      () async {
        final u = await run((_) => _final(_result()), text: 'bố tôi ngừng tim');
        final o = outcome(u) as EmergencyCall115;
        expect(o.protocol, isNull);
        expect(ai.calls, isEmpty);
      },
    );

    test('mất mạng -> fallback ngay, không hỏi đồng ý, không gọi AI', () async {
      var asked = false;
      final u = await run(
        (_) => _final(_result()),
        connected: false,
        confirm: () async => asked = true,
      );
      expect(reason(u), FallbackReason.offline);
      expect(ai.calls, isEmpty);
      expect(asked, isFalse);
    });

    test('chưa cấu hình AI (R-33) -> notConfigured ngay, không hỏi đồng ý, '
        'không gọi AI', () async {
      var asked = false;
      final u = await run(
        (_) => _final(_result()),
        configured: false,
        confirm: () async => asked = true,
      );
      expect(reason(u), FallbackReason.notConfigured);
      expect(u, hasLength(1));
      expect(ai.calls, isEmpty);
      expect(asked, isFalse);
    });

    test('chưa cấu hình AI vẫn kiểm tra từ khóa nguy cấp trên máy', () async {
      final u = await run(
        (_) => _final(_result()),
        text: 'Người lớn bất tỉnh, không thở',
        configured: false,
      );
      final o = outcome(u) as EmergencyCall115;
      expect(o.source, Call115Source.localKeywords);
      expect(ai.calls, isEmpty);
    });

    test('không đồng ý gửi -> không gọi AI', () async {
      final u = await run((_) => _final(_result()), confirm: _no);
      expect(reason(u), FallbackReason.consentDeclined);
      expect(ai.calls, isEmpty);
    });

    test('rỗng -> emptyInput, không gọi AI', () async {
      final u = await run((_) => _final(_result()), text: '   ');
      expect(reason(u), FallbackReason.emptyInput);
      expect(ai.calls, isEmpty);
    });

    test('lỗi mạng/HTTP/không cấu hình/định dạng ánh xạ đúng lý do', () async {
      const cases = {
        AiRouteFailureKind.network: FallbackReason.offline,
        AiRouteFailureKind.server: FallbackReason.serverError,
        AiRouteFailureKind.invalidResponse: FallbackReason.invalidResponse,
        AiRouteFailureKind.notConfigured: FallbackReason.notConfigured,
      };
      for (final e in cases.entries) {
        final u = await run((_) => Stream.error(AiRouteException(e.key)));
        expect(reason(u), e.value, reason: '${e.key}');
      }
    });

    test('lỗi bất ngờ (không phải AiRouteException) -> serverError', () async {
      final u = await run((_) => Stream.error(StateError('boom')));
      expect(reason(u), FallbackReason.serverError);
    });

    test('luồng kết thúc không có kết quả -> invalidResponse', () async {
      final u = await run(
        (_) =>
            Stream.fromIterable([const AiRouteStatus(AiRouteStage.received)]),
      );
      expect(reason(u), FallbackReason.invalidResponse);
    });

    test('cắt văn bản quá 1000 ký tự trước khi gửi', () async {
      await run((_) => _final(_result()), text: 'bỏng ${'a' * 1200}');
      expect(ai.calls.single.length, RouteSituation.maxLength);
    });
  });

  group('detectEmergencyKeywords (cùng ca với backend/tests)', () {
    const positives = {
      'Người lớn bất tỉnh, không thở': ('cpr', 'cpr_adult_adolescent'),
      'em bé 3 tháng tuổi không thở': ('cpr', 'cpr_baby_child'),
      'bé nhà tôi không phản ứng gì': ('cpr', 'cpr_baby_child'),
      'bố tôi ngừng tim': ('cpr', null),
      'em bé sơ sinh bị nghẹn, không khóc được': ('choking', 'choking_baby'),
      'người lớn hóc xương, không nói được': ('choking', 'choking_adult_child'),
      'hóc đồ ăn, không thở được': ('choking', null),
      'máu phun ra từ cánh tay': ('bleeding', 'bleeding_wounds_severe'),
      'chảy máu nhiều không cầm được': ('bleeding', 'bleeding_wounds_severe'),
    };
    for (final e in positives.entries) {
      test('khớp: ${e.key}', () {
        final m = detectEmergencyKeywords(e.key);
        expect(m, isNotNull);
        expect(m!.rule, e.value.$1);
        expect(m.protocolCode, e.value.$2);
      });
    }

    for (final t in [
      'bị bỏng nước sôi ở tay',
      'hôm nay trời đẹp quá',
      'đau bụng nhẹ từ sáng',
      'bé ho sặc sữa nhưng vẫn ho được',
    ]) {
      test('không khớp: $t', () => expect(detectEmergencyKeywords(t), isNull));
    }

    test('chuẩn hóa giống textnorm.py (kể cả chữ tách dấu NFD)', () {
      expect(
        normalizeForRules('Bé bị Nghẹn, KHÔNG thở được!'),
        'be bi nghen khong tho duoc',
      );
      // "không thở" gõ dạng tách dấu: o + U+0302, o + U+0309
      final nfd =
          'kho${String.fromCharCode(0x0302)}ng tho${String.fromCharCode(0x0309)}';
      expect(normalizeForRules(nfd), 'khong tho');
    });
  });
}

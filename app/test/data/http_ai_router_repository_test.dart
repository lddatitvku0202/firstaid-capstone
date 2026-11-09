import 'dart:convert';

import 'package:app/data/repositories/http_ai_router_repository.dart';
import 'package:app/domain/entities/ai_route.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const _okResult = {
  'category': 'burns',
  'protocol_code': 'burns_thermal_chemical',
  'confidence_note': 'x',
  'sources': [
    {'source_id': 'IFRC-2025', 'pages': '288-290'},
  ],
  'uncertain': false,
};

String _sse(String event, Object data) =>
    'event: $event\ndata: ${jsonEncode(data)}\n\n';

class _Captured {
  http.BaseRequest? request;
  String? body;
}

HttpAiRouterRepository _repo(
  _Captured cap, {
  int status = 200,
  List<List<int>>? chunks,
  String sse = '',
  String baseUrl = 'http://10.0.2.2:8000/',
  String apiKey = '',
}) => HttpAiRouterRepository(
  baseUrl: baseUrl,
  apiKey: apiKey,
  clientFactory: () => MockClient.streaming((request, bodyStream) async {
    cap.request = request;
    cap.body = await bodyStream.bytesToString();
    return http.StreamedResponse(
      Stream.fromIterable(chunks ?? [utf8.encode(sse)]),
      status,
      headers: {'content-type': 'text/event-stream'},
    );
  }),
);

Future<AiRouteFailureKind> _failureKind(Stream<AiRouteEvent> s) async {
  try {
    await s.toList();
  } on AiRouteException catch (e) {
    return e.kind;
  }
  fail('không ném AiRouteException');
}

void main() {
  test(
    'gửi POST SSE đúng endpoint/header/body và parse status/delta/result',
    () async {
      final cap = _Captured();
      final repo = _repo(
        cap,
        apiKey: 'demo-token',
        sse:
            ': keep-alive\n\n'
            '${_sse('status', {'stage': 'received'})}'
            '${_sse('status', {'stage': 'retrieved', 'candidates': 2})}'
            '${_sse('status', {'stage': 'llm_started'})}'
            '${_sse('delta', {'text': '{"cat'})}'
            '${_sse('result', _okResult)}',
      );
      final events = await repo.routeSituation('bỏng tay').toList();

      final req = cap.request!;
      expect(req.method, 'POST');
      expect(
        req.url.toString(),
        'http://10.0.2.2:8000/v1/route-situation?stream=true',
      );
      expect(req.headers['Accept'], 'text/event-stream');
      expect(req.headers['X-API-Key'], 'demo-token');
      expect(jsonDecode(cap.body!), {'text': 'bỏng tay'});

      expect(events.whereType<AiRouteStatus>().map((e) => e.stage), [
        AiRouteStage.received,
        AiRouteStage.retrieved,
        AiRouteStage.aiSelecting,
      ]);
      expect(events.whereType<AiRouteDelta>().single.length, 5);
      final r = (events.last as AiRouteFinal).result;
      expect(r.category, AiRouteCategory.burns);
      expect(r.protocolCode, 'burns_thermal_chemical');
      expect(r.sources.single.sourceId, 'IFRC-2025');
      expect(r.uncertain, isFalse);
    },
  );

  test('không gửi X-API-Key khi để trống', () async {
    final cap = _Captured();
    await _repo(
      cap,
      sse: _sse('result', _okResult),
    ).routeSituation('a').toList();
    expect(cap.request!.headers.containsKey('X-API-Key'), isFalse);
  });

  test('SSE bị cắt giữa ký tự UTF-8 và giữa dòng vẫn parse đúng', () async {
    final bytes = utf8.encode(
      '${_sse('status', {'stage': 'received'})}'
      '${_sse('result', {..._okResult, 'confidence_note': 'chọn phác đồ bỏng'})}',
    );
    final chunks = [
      for (var i = 0; i < bytes.length; i += 7)
        bytes.sublist(i, (i + 7).clamp(0, bytes.length)),
    ];
    final events = await _repo(
      _Captured(),
      chunks: chunks,
    ).routeSituation('x').toList();
    expect(
      (events.last as AiRouteFinal).result.confidenceNote,
      'chọn phác đồ bỏng',
    );
  });

  test('sự kiện error -> AiRouteException (timeout/server)', () async {
    final s1 = _repo(
      _Captured(),
      sse: _sse('error', {
        'code': 'llm_timeout',
        'message': 'm',
        'fallback': 'use_local_triage',
      }),
    ).routeSituation('x');
    expect(await _failureKind(s1), AiRouteFailureKind.timeout);
    final s2 = _repo(
      _Captured(),
      sse: _sse('error', {'code': 'llm_protocol_not_allowed', 'message': 'm'}),
    ).routeSituation('x');
    expect(await _failureKind(s2), AiRouteFailureKind.server);
  });

  test('HTTP lỗi: 502 -> server (đọc mã lỗi), 504 -> timeout', () async {
    final body = jsonEncode({
      'error': {
        'code': 'llm_unavailable',
        'message': 'm',
        'fallback': 'use_local_triage',
      },
    });
    try {
      await _repo(
        _Captured(),
        status: 502,
        sse: body,
      ).routeSituation('x').toList();
      fail('phải lỗi');
    } on AiRouteException catch (e) {
      expect(e.kind, AiRouteFailureKind.server);
      expect(e.code, 'llm_unavailable');
    }
    expect(
      await _failureKind(
        _repo(_Captured(), status: 504, sse: body).routeSituation('x'),
      ),
      AiRouteFailureKind.timeout,
    );
  });

  test('result sai schema -> invalidResponse', () async {
    final bad = [
      {..._okResult, 'diagnosis': 'x'}, // thừa trường
      {..._okResult, 'category': 'snake_bite'}, // category lạ
      {
        ..._okResult,
        'sources': ['IFRC'],
      }, // sources sai kiểu
      {..._okResult, 'uncertain': 'no'},
      Map.of(_okResult)..remove('protocol_code'), // thiếu trường
    ];
    for (final r in bad) {
      final s = _repo(_Captured(), sse: _sse('result', r)).routeSituation('x');
      expect(
        await _failureKind(s),
        AiRouteFailureKind.invalidResponse,
        reason: '$r',
      );
    }
    final notJson = _repo(
      _Captured(),
      sse: 'event: result\ndata: {oops\n\n',
    ).routeSituation('x');
    expect(await _failureKind(notJson), AiRouteFailureKind.invalidResponse);
  });

  test('luồng kết thúc không có result -> invalidResponse', () async {
    final s = _repo(
      _Captured(),
      sse: _sse('status', {'stage': 'received'}),
    ).routeSituation('x');
    expect(await _failureKind(s), AiRouteFailureKind.invalidResponse);
  });

  test('không kết nối được (ClientException) -> network', () async {
    final repo = HttpAiRouterRepository(
      baseUrl: 'http://10.0.2.2:8000',
      clientFactory: () =>
          MockClient((_) => throw http.ClientException('Failed host lookup')),
    );
    expect(
      await _failureKind(repo.routeSituation('x')),
      AiRouteFailureKind.network,
    );
  });

  test('chưa cấu hình AI_BASE_URL -> notConfigured', () async {
    expect(
      await _failureKind(
        const DisabledAiRouterRepository().routeSituation('x'),
      ),
      AiRouteFailureKind.notConfigured,
    );
  });
}

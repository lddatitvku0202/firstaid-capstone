import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/entities/ai_route.dart';
import '../../domain/entities/source_citation.dart';
import '../../domain/repositories/ai_router_repository.dart';

/// Dùng khi app chưa được cấu hình AI_BASE_URL: luôn báo notConfigured
/// để use case chuyển sang sàng lọc tĩnh.
class DisabledAiRouterRepository implements AiRouterRepository {
  const DisabledAiRouterRepository();

  @override
  Stream<AiRouteEvent> routeSituation(String text) =>
      Stream.error(const AiRouteException(AiRouteFailureKind.notConfigured));
}

/// Gọi `POST {baseUrl}/v1/route-situation?stream=true` (SSE).
///
/// Chỉ sự kiện `result` được dùng để ra quyết định và được validate chặt
/// (đúng 5 trường, đúng kiểu). `delta` chỉ được đếm độ dài, không parse.
class HttpAiRouterRepository implements AiRouterRepository {
  HttpAiRouterRepository({
    required this.baseUrl,
    this.apiKey = '',
    http.Client Function()? clientFactory,
  }) : _clientFactory = clientFactory ?? http.Client.new;

  final String baseUrl;

  /// Token tùy chọn (header X-API-Key). Nhúng trong app nên KHÔNG phải bí mật.
  final String apiKey;
  final http.Client Function() _clientFactory;

  Uri get endpoint {
    final base = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    return Uri.parse('$base/v1/route-situation?stream=true');
  }

  @override
  Stream<AiRouteEvent> routeSituation(String text) async* {
    // Mỗi yêu cầu một client: hủy subscription => đóng client => hủy kết nối.
    final client = _clientFactory();
    try {
      final request = http.Request('POST', endpoint)
        ..headers.addAll({
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'text/event-stream',
          if (apiKey.isNotEmpty) 'X-API-Key': apiKey,
        })
        ..body = jsonEncode({'text': text});

      final http.StreamedResponse response;
      try {
        response = await client.send(request);
      } on Object {
        // ClientException, lỗi TLS, DNS...: coi như không tới được máy chủ.
        throw const AiRouteException(AiRouteFailureKind.network);
      }

      if (response.statusCode != 200) {
        final body = await _readBody(response);
        throw AiRouteException(
          _kindForStatus(response.statusCode),
          code: _errorCode(body),
        );
      }

      String? event;
      final data = StringBuffer();
      final lines = response.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter());
      try {
        await for (final line in lines) {
          if (line.isEmpty) {
            if (event != null || data.isNotEmpty) {
              final parsed = parseSseEvent(event ?? 'message', data.toString());
              if (parsed != null) {
                yield parsed;
                if (parsed is AiRouteFinal) return;
              }
            }
            event = null;
            data.clear();
          } else if (line.startsWith(':')) {
            continue; // comment / keep-alive
          } else if (line.startsWith('event:')) {
            event = line.substring(6).trim();
          } else if (line.startsWith('data:')) {
            if (data.isNotEmpty) data.write('\n');
            data.write(line.substring(5).trimLeft());
          }
        }
        // Sự kiện cuối không có dòng trống kết thúc.
        if (data.isNotEmpty) {
          final parsed = parseSseEvent(event ?? 'message', data.toString());
          if (parsed != null) yield parsed;
          if (parsed is AiRouteFinal) return;
        }
      } on http.ClientException {
        throw const AiRouteException(AiRouteFailureKind.network);
      } on FormatException {
        throw const AiRouteException(AiRouteFailureKind.invalidResponse);
      }
      // Luồng kết thúc mà không có result/error.
      throw const AiRouteException(AiRouteFailureKind.invalidResponse);
    } finally {
      client.close();
    }
  }

  static Future<String> _readBody(http.StreamedResponse r) async {
    try {
      return await r.stream.bytesToString();
    } on Object {
      return '';
    }
  }

  static AiRouteFailureKind _kindForStatus(int status) =>
      status == 504 ? AiRouteFailureKind.timeout : AiRouteFailureKind.server;

  static String? _errorCode(String body) {
    try {
      final obj = jsonDecode(body);
      if (obj is Map && obj['error'] is Map) {
        final code = (obj['error'] as Map)['code'];
        return code is String ? code : null;
      }
    } on FormatException {
      return null;
    }
    return null;
  }
}

const _stageByWire = {
  'received': AiRouteStage.received,
  'rules_matched': AiRouteStage.rulesMatched,
  'retrieved': AiRouteStage.retrieved,
  'llm_started': AiRouteStage.aiSelecting,
};

/// Chuyển một sự kiện SSE thành [AiRouteEvent]. Sự kiện/giai đoạn không biết
/// trả null (bỏ qua). Sự kiện `error` ném [AiRouteException].
AiRouteEvent? parseSseEvent(String event, String data) {
  switch (event) {
    case 'status':
      final obj = _decodeObject(data);
      final stage = obj == null ? null : _stageByWire[obj['stage']];
      return stage == null ? null : AiRouteStatus(stage);
    case 'delta':
      final obj = _decodeObject(data);
      final text = obj?['text'];
      return AiRouteDelta(text is String ? text.length : 0);
    case 'result':
      final obj = _decodeObject(data);
      if (obj == null) {
        throw const AiRouteException(AiRouteFailureKind.invalidResponse);
      }
      return AiRouteFinal(parseRouteResult(obj));
    case 'error':
      final obj = _decodeObject(data);
      final code = obj?['code'];
      throw AiRouteException(
        code == 'llm_timeout'
            ? AiRouteFailureKind.timeout
            : AiRouteFailureKind.server,
        code: code is String ? code : null,
      );
    default:
      return null;
  }
}

Map<String, Object?>? _decodeObject(String data) {
  try {
    final obj = jsonDecode(data);
    return obj is Map<String, Object?> ? obj : null;
  } on FormatException {
    return null;
  }
}

const _resultKeys = {
  'category',
  'protocol_code',
  'confidence_note',
  'sources',
  'uncertain',
};

/// Validate chặt kết quả cuối: đúng 5 trường, đúng kiểu, category hợp lệ.
AiRouteResult parseRouteResult(Map<String, Object?> obj) {
  const invalid = AiRouteException(AiRouteFailureKind.invalidResponse);
  if (obj.keys.toSet().length != _resultKeys.length ||
      !obj.keys.every(_resultKeys.contains)) {
    throw invalid;
  }
  final category = obj['category'];
  final code = obj['protocol_code'];
  final note = obj['confidence_note'];
  final sources = obj['sources'];
  final uncertain = obj['uncertain'];
  if (category is! String ||
      (code != null && code is! String) ||
      note is! String ||
      sources is! List ||
      uncertain is! bool) {
    throw invalid;
  }
  final parsedCategory = AiRouteCategory.fromWire(category);
  if (parsedCategory == null) throw invalid;
  final citations = <SourceCitation>[];
  for (final s in sources) {
    if (s is! Map) throw invalid;
    final id = s['source_id'];
    final pages = s['pages'];
    if (id is! String || pages is! String) throw invalid;
    citations.add(SourceCitation(sourceId: id, pages: pages));
  }
  return AiRouteResult(
    category: parsedCategory,
    protocolCode: code as String?,
    confidenceNote: note,
    sources: citations,
    uncertain: uncertain,
  );
}

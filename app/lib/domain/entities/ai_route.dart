import 'source_citation.dart';

/// Nhóm định tuyến do máy chủ AI trả về (khớp schema backend).
/// `call115Now` chỉ do quy tắc xác định phía server tạo ra (không qua LLM).
enum AiRouteCategory {
  cardiacArrestCpr('cardiac_arrest_cpr'),
  choking('choking'),
  bleedingWounds('bleeding_wounds'),
  burns('burns'),
  call115Now('call_115_now'),
  outOfScope('out_of_scope');

  const AiRouteCategory(this.wireName);

  /// Tên trên API; với 4 chủ đề, trùng `topicId` của phác đồ.
  final String wireName;

  static AiRouteCategory? fromWire(String value) {
    for (final c in values) {
      if (c.wireName == value) return c;
    }
    return null;
  }
}

/// Kết quả định tuyến cuối đã được server validate. App chỉ dùng
/// `protocolCode` để mở phác đồ cục bộ; KHÔNG hiển thị `confidenceNote`
/// (văn bản do LLM sinh).
class AiRouteResult {
  const AiRouteResult({
    required this.category,
    required this.protocolCode,
    required this.confidenceNote,
    required this.sources,
    required this.uncertain,
  });

  final AiRouteCategory category;
  final String? protocolCode;
  final String confidenceNote;
  final List<SourceCitation> sources;
  final bool uncertain;
}

/// Giai đoạn xử lý (từ sự kiện SSE `status`).
enum AiRouteStage { sending, received, rulesMatched, retrieved, aiSelecting }

/// Sự kiện từ luồng SSE.
sealed class AiRouteEvent {
  const AiRouteEvent();
}

class AiRouteStatus extends AiRouteEvent {
  const AiRouteStatus(this.stage);
  final AiRouteStage stage;
}

/// Mảnh đầu ra tạm CHƯA validate: chỉ dùng độ dài để báo tiến trình.
class AiRouteDelta extends AiRouteEvent {
  const AiRouteDelta(this.length);
  final int length;
}

class AiRouteFinal extends AiRouteEvent {
  const AiRouteFinal(this.result);
  final AiRouteResult result;
}

enum AiRouteFailureKind {
  /// Không kết nối được máy chủ (mất mạng, DNS, có sóng nhưng không có Internet).
  network,
  timeout,

  /// Server trả lỗi (HTTP != 200 hoặc sự kiện `error`).
  server,

  /// Phản hồi sai định dạng/schema.
  invalidResponse,

  /// App chưa được cấu hình AI_BASE_URL.
  notConfigured,
}

class AiRouteException implements Exception {
  const AiRouteException(this.kind, {this.code});

  final AiRouteFailureKind kind;

  /// Mã lỗi ổn định từ server (vd `llm_timeout`), nếu có.
  final String? code;

  @override
  String toString() => 'AiRouteException($kind, code: $code)';
}

# ĐỒNG BỘ (R-28): sửa danh sách từ khóa nguy cấp ở đây thì phải sửa y hệt app/lib/domain/usecases/detect_emergency_keywords.dart (bản port Dart chạy trên máy).
"""Tiền kiểm quy tắc xác định: "gọi 115" KHÔNG phụ thuộc LLM.

Các cụm từ khóa lấy theo điều kiện gọi 115 của chính các phác đồ trong app
(IFRC-2025 p159/p162 CPR, p241 hóc dị vật, p256 chảy máu nặng) và cây sàng lọc
của app. Danh sách từ khóa do nhóm tự viết, CHƯA được rà soát lâm sàng
(not_clinically_reviewed). Thiết kế thiên về báo động thừa (false positive) hơn
là bỏ sót; không dùng phủ định thông minh.

Rule KHÔNG đoán tuổi: không rõ nhóm tuổi thì protocol_code = None, uncertain = True
(app cần hỏi thêm bằng luồng sàng lọc cục bộ).
"""

from __future__ import annotations

from dataclasses import dataclass

from .retrieval import ProtocolIndex
from .schemas import RouteResult, Source
from .textnorm import normalize

# Cụm đã chuẩn hóa (không dấu). Khớp theo ranh giới từ.
UNRESPONSIVE_OR_NOT_BREATHING = (
    "khong tho", "ngung tho", "ngung tim", "tim ngung", "tho bat thuong",
    "khong con tho", "ngung tuan hoan", "khong phan ung", "bat tinh",
    "khong tinh", "khong tho binh thuong",
)
CHOKING_CANNOT_COUGH = (
    "khong ho duoc", "khong the ho", "khong noi duoc", "khong the noi",
    "khong tho duoc", "khong the tho", "tac tho", "nghet tho", "tim tai",
    "khong keu duoc", "khong khoc duoc",
)
CHOKING_CONTEXT = ("nghen", "hoc", "mac co", "ket hong", "sac")
SEVERE_BLEEDING = (
    "mau phun", "phun mau", "chay mau nhieu", "mat nhieu mau", "khong cam duoc mau",
    "mau khong cam", "mau chay thanh dong", "mau chay ao at", "tham uot bang",
    "mau chay khong ngung", "mau chay xoi xa",
)
INFANT_WORDS = (
    "so sinh", "em be", "duoi 1 tuoi", "thang tuoi", "be nho", "con nho", "tre so sinh",
)
CHILD_WORDS = ("tre em", "be gai", "be trai", "cau be", "co be", "con toi", "be nha toi", "be")
ADULT_WORDS = (
    "nguoi lon", "thanh nien", "thanh thieu nien", "dan ong", "phu nu", "ong cu",
    "ba cu", "ong noi", "ba noi", "nguoi gia", "cu ong", "cu ba",
)

SAFE_NOTE_RULE = (
    "Tình huống có dấu hiệu nguy cấp theo quy tắc cố định của ứng dụng: gọi 115 ngay. "
    "Kết quả này không đến từ AI và không phải chẩn đoán."
)


def _has(norm: str, phrases: tuple[str, ...]) -> bool:
    padded = f" {norm} "
    return any(f" {p} " in padded for p in phrases)


@dataclass(frozen=True)
class RuleMatch:
    rule: str  # cpr | choking | bleeding
    protocol_code: str | None


def check_emergency(text: str) -> RuleMatch | None:
    norm = normalize(text)
    infant = _has(norm, INFANT_WORDS)
    child = _has(norm, CHILD_WORDS)
    adult = _has(norm, ADULT_WORDS)

    if _has(norm, UNRESPONSIVE_OR_NOT_BREATHING) and not _has(norm, CHOKING_CONTEXT):
        # cpr_baby_child bao gồm em bé và trẻ em; người lớn xung đột với trẻ => không đoán.
        if (infant or child) and not adult:
            return RuleMatch("cpr", "cpr_baby_child")
        if adult and not (infant or child):
            return RuleMatch("cpr", "cpr_adult_adolescent")
        return RuleMatch("cpr", None)

    if _has(norm, CHOKING_CANNOT_COUGH):
        if infant and not adult:
            return RuleMatch("choking", "choking_baby")
        if (adult or "tre em" in norm) and not infant:
            return RuleMatch("choking", "choking_adult_child")
        return RuleMatch("choking", None)

    if _has(norm, SEVERE_BLEEDING):
        return RuleMatch("bleeding", "bleeding_wounds_severe")

    # Không thở/không phản ứng kèm ngữ cảnh hóc dị vật: coi như hóc.
    if _has(norm, UNRESPONSIVE_OR_NOT_BREATHING) and _has(norm, CHOKING_CONTEXT):
        if infant and not adult:
            return RuleMatch("choking", "choking_baby")
        if (adult or "tre em" in norm) and not infant:
            return RuleMatch("choking", "choking_adult_child")
        return RuleMatch("choking", None)
    return None


def rule_result(match: RuleMatch, index: ProtocolIndex) -> RouteResult:
    sources: list[Source] = []
    if match.protocol_code and match.protocol_code in index.by_code:
        sources = [
            Source(source_id=s, pages=p)
            for s, p in index.by_code[match.protocol_code].citations
        ]
        code = match.protocol_code
    else:
        code = None
    return RouteResult(
        category="call_115_now",
        protocol_code=code,
        confidence_note=SAFE_NOTE_RULE,
        sources=sources,
        uncertain=code is None,
    )

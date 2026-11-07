"""Chuẩn hóa văn bản tiếng Việt: chữ thường, bỏ dấu, đ -> d, tách token."""

from __future__ import annotations

import re
import unicodedata

_TOKEN_RE = re.compile(r"[a-z0-9]+")


def normalize(text: str) -> str:
    """Chữ thường, bỏ dấu, chỉ còn a-z0-9 và khoảng trắng đơn."""
    lowered = text.lower().replace("đ", "d")
    decomposed = unicodedata.normalize("NFD", lowered)
    stripped = "".join(c for c in decomposed if unicodedata.category(c) != "Mn")
    return " ".join(_TOKEN_RE.findall(stripped))


# Từ dừng tiếng Việt thông dụng (không dấu), nhóm tự liệt kê; chỉ dùng cho truy xuất.
STOPWORDS = frozenset(
    "toi minh ban anh chi em la bi duoc va o cua cho khi nay hom qua do day kia nhu the "
    "co khong rat qua lam roi dang se da vua nen thi ma nhung hay hoac de den tu trong "
    "tren duoi mot cac nhung nhieu it vao ra len xuong lai cung con gi nao sao the nao "
    "oi a nha nhe ah u hu ngay".split()
)


def tokens(text: str) -> list[str]:
    """Unigram + bigram (bigram giúp bắt cụm như 'bong nuoc'); bỏ từ dừng."""
    uni = [t for t in normalize(text).split() if t not in STOPWORDS]
    bi = [f"{a}_{b}" for a, b in zip(uni, uni[1:])]
    return uni + bi

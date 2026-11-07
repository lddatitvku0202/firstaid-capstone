"""RAG-lite: BM25 thuần Python trên protocols_index.json (không cần embedding/mạng)."""

from __future__ import annotations

import json
import math
from collections import Counter
from dataclasses import dataclass
from pathlib import Path

from .textnorm import tokens


@dataclass(frozen=True)
class IndexedProtocol:
    code: str
    title: str
    topic_id: str
    age_group: str
    citations: tuple[tuple[str, str], ...]  # (source_id, pages)
    text: str
    aliases: tuple[str, ...]


@dataclass(frozen=True)
class Hit:
    protocol: IndexedProtocol
    score: float


class ProtocolIndex:
    """Chỉ chứa các mục verified (build_index.py đã lọc; ở đây lọc lại cho chắc)."""

    def __init__(self, entries: list[dict], meta: dict | None = None, k1: float = 1.5, b: float = 0.75):
        self.meta = meta or {}
        self.protocols: list[IndexedProtocol] = []
        for e in entries:
            if e.get("source_verification") != "verified":
                continue
            self.protocols.append(
                IndexedProtocol(
                    code=e["code"],
                    title=e["title"],
                    topic_id=e["topic_id"],
                    age_group=e["age_group"],
                    citations=tuple((c["source_id"], c["pages"]) for c in e["citations"]),
                    text=e["text"],
                    aliases=tuple(e.get("aliases", [])),
                )
            )
        self.by_code = {p.code: p for p in self.protocols}
        self._k1, self._b = k1, b
        # Alias được lặp 3 lần để có trọng số cao hơn thân văn bản dài.
        self._docs = [
            tokens(f"{p.title} {' '.join(p.aliases) * 3} {p.text}") for p in self.protocols
        ]
        self._tf = [Counter(d) for d in self._docs]
        self._len = [len(d) for d in self._docs]
        self._avg = (sum(self._len) / len(self._len)) if self._len else 0.0
        df: Counter[str] = Counter()
        for d in self._docs:
            df.update(set(d))
        n = len(self._docs)
        self._idf = {t: math.log(1 + (n - c + 0.5) / (c + 0.5)) for t, c in df.items()}

    @classmethod
    def from_file(cls, path: Path) -> "ProtocolIndex":
        data = json.loads(Path(path).read_text(encoding="utf-8"))
        meta = {k: v for k, v in data.items() if k != "protocols"}
        return cls(data["protocols"], meta)

    @property
    def codes(self) -> list[str]:
        return [p.code for p in self.protocols]

    def search(self, query: str, top_k: int = 3) -> list[Hit]:
        q = tokens(query)
        if not q or not self.protocols:
            return []
        hits: list[Hit] = []
        for i, p in enumerate(self.protocols):
            score = 0.0
            tf = self._tf[i]
            norm = 1 - self._b + self._b * (self._len[i] / self._avg if self._avg else 1)
            for t in set(q):
                f = tf.get(t, 0)
                if f:
                    score += self._idf[t] * f * (self._k1 + 1) / (f + self._k1 * norm)
            if score > 0:
                hits.append(Hit(p, score))
        hits.sort(key=lambda h: (-h.score, h.protocol.code))
        return hits[:top_k]

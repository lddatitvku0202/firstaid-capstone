from __future__ import annotations

import json
from pathlib import Path

import pytest

from app.config import Settings
from app.llm import TransientLlmError
from app.retrieval import ProtocolIndex
from app.router_service import RouterService

INDEX_PATH = Path(__file__).resolve().parent.parent / "data" / "protocols_index.json"


@pytest.fixture(scope="session")
def index() -> ProtocolIndex:
    return ProtocolIndex.from_file(INDEX_PATH)


def make_settings(**kw) -> Settings:
    # _env_file=None: test không đọc backend/.env và không cần key.
    base = dict(
        gemini_api_key="",
        llm_retry_backoff_s=0.0,
        llm_timeout_s=1.0,
        llm_max_attempts=2,
    )
    base.update(kw)
    return Settings(_env_file=None, **base)


class FakeLlm:
    """Mô phỏng Gemini. `responses`: danh sách (chuỗi JSON | Exception) theo từng lần gọi."""

    def __init__(self, responses):
        self.responses = list(responses)
        self.calls = 0
        self.prompts: list[str] = []

    def _next(self):
        r = self.responses[min(self.calls, len(self.responses) - 1)]
        self.calls += 1
        if isinstance(r, Exception):
            raise r
        return r

    async def generate(self, prompt, schema, system):
        self.prompts.append(prompt)
        return self._next()

    async def stream(self, prompt, schema, system):
        self.prompts.append(prompt)
        r = self._next()
        mid = len(r) // 2
        yield r[:mid]
        yield r[mid:]


def ok_json(code="burns_thermal_chemical", category="burns", pages="288-290", **over) -> str:
    obj = {
        "category": category,
        "protocol_code": code,
        "confidence_note": "Mô tả khớp chủ đề phác đồ đã chọn.",
        "sources": [{"source_id": "IFRC-2025", "pages": pages}],
        "uncertain": False,
    }
    obj.update(over)
    return json.dumps(obj, ensure_ascii=False)


@pytest.fixture
def make_service(index):
    def _make(responses, **settings_kw):
        llm = FakeLlm(responses)
        return RouterService(index, llm, make_settings(**settings_kw)), llm

    return _make


__all__ = ["FakeLlm", "ok_json", "make_settings", "TransientLlmError"]

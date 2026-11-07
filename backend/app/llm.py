"""Gọi Gemini qua SDK chính thức `google-genai` (đã kiểm tra API bằng inspect trên bản
cài thật: client.aio.models.generate_content / generate_content_stream,
types.GenerateContentConfig(system_instruction, response_mime_type,
response_json_schema, temperature, max_output_tokens, http_options)).
"""

from __future__ import annotations

import asyncio
from collections.abc import AsyncIterator
from typing import Protocol

from .schemas import RouteError


class LlmClient(Protocol):
    async def generate(self, prompt: str, schema: dict, system: str) -> str: ...

    def stream(self, prompt: str, schema: dict, system: str) -> AsyncIterator[str]: ...


class TransientLlmError(Exception):
    """Lỗi tạm thời (429/5xx/mạng): có thể retry có giới hạn."""


class GeminiClient:
    def __init__(self, api_key: str, model: str, timeout_s: float):
        if not api_key:
            raise RouteError("llm_not_configured", "Chưa cấu hình GEMINI_API_KEY.", 503)
        from google import genai  # import muộn: test không cần SDK/key
        from google.genai import types

        self._types = types
        self._model = model
        self._timeout_s = timeout_s
        self._client = genai.Client(
            api_key=api_key,
            http_options=types.HttpOptions(timeout=int(timeout_s * 1000)),
        )

    def _config(self, schema: dict, system: str):
        return self._types.GenerateContentConfig(
            system_instruction=system,
            response_mime_type="application/json",
            response_json_schema=schema,
            temperature=0.0,
            max_output_tokens=600,
        )

    @staticmethod
    def _map(exc: Exception) -> Exception:
        from google.genai import errors

        if isinstance(exc, errors.ServerError):
            return TransientLlmError(f"HTTP {getattr(exc, 'code', '?')} (server error)")
        if isinstance(exc, errors.ClientError):
            if getattr(exc, "code", None) == 429:
                return TransientLlmError("HTTP 429 (rate limited)")
            return RouteError(
                "llm_unavailable",
                f"Gemini từ chối yêu cầu (HTTP {getattr(exc, 'code', '?')}).",
                502,
                detail=f"HTTP {getattr(exc, 'code', '?')} (client error)",
            )
        return TransientLlmError(type(exc).__name__)

    async def generate(self, prompt: str, schema: dict, system: str) -> str:
        try:
            resp = await asyncio.wait_for(
                self._client.aio.models.generate_content(
                    model=self._model, contents=prompt, config=self._config(schema, system)
                ),
                timeout=self._timeout_s + 1,
            )
        except asyncio.TimeoutError as e:
            raise TransientLlmError("timeout") from e
        except Exception as e:  # noqa: BLE001 - chuyển thành lỗi miền
            raise self._map(e) from e
        return resp.text or ""

    async def stream(self, prompt: str, schema: dict, system: str) -> AsyncIterator[str]:
        try:
            agen = await self._client.aio.models.generate_content_stream(
                model=self._model, contents=prompt, config=self._config(schema, system)
            )
            async for chunk in agen:
                if chunk.text:
                    yield chunk.text
        except asyncio.TimeoutError as e:
            raise TransientLlmError("timeout") from e
        except Exception as e:  # noqa: BLE001
            raise self._map(e) from e

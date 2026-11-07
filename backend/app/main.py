"""FastAPI: POST /v1/route-situation (JSON hoặc SSE), GET /healthz."""

from __future__ import annotations

import json
import logging
import secrets
import uuid
from collections.abc import AsyncIterator

from fastapi import Depends, FastAPI, Header, HTTPException, Request
from fastapi.exceptions import RequestValidationError
from fastapi.responses import JSONResponse, StreamingResponse

from .config import Settings, get_settings
from .llm import GeminiClient, LlmClient
from .retrieval import ProtocolIndex
from .router_service import Event, RouterService
from .schemas import RouteError, RouteRequest, RouteResult

logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(name)s %(message)s")

app = FastAPI(title="FirstAid routing service", version="0.1.0")

_service: RouterService | None = None


def build_service(settings: Settings, llm: LlmClient | None = None) -> RouterService:
    index = ProtocolIndex.from_file(settings.index_path)
    if llm is None and settings.gemini_api_key:
        llm = GeminiClient(settings.gemini_api_key, settings.gemini_model, settings.llm_timeout_s)
    return RouterService(index, llm, settings)


def get_service() -> RouterService:
    """Dependency (test override được)."""
    global _service
    if _service is None:
        _service = build_service(get_settings())
    return _service


def check_auth(
    x_api_key: str | None = Header(default=None),
    settings: Settings = Depends(get_settings),
) -> None:
    if settings.api_auth_token and not (
        x_api_key and secrets.compare_digest(x_api_key, settings.api_auth_token)
    ):
        raise HTTPException(status_code=401, detail="unauthorized")


@app.exception_handler(RouteError)
async def _route_error_handler(_: Request, exc: RouteError) -> JSONResponse:
    return JSONResponse(status_code=exc.http_status, content=exc.body())


@app.exception_handler(RequestValidationError)
async def _validation_handler(_: Request, exc: RequestValidationError) -> JSONResponse:
    # Không phản chiếu nội dung người dùng trong lỗi.
    return JSONResponse(
        status_code=422,
        content={
            "error": {
                "code": "invalid_request",
                "message": "Yêu cầu không hợp lệ: cần text từ 1 đến 1000 ký tự.",
                "fallback": "use_local_triage",
            }
        },
    )


@app.get("/healthz")
async def healthz() -> dict:
    return {"status": "ok"}


def _sse(event: str, data: dict) -> str:
    return f"event: {event}\ndata: {json.dumps(data, ensure_ascii=False)}\n\n"


async def _sse_stream(svc: RouterService, text: str) -> AsyncIterator[str]:
    async for ev in svc.route_events(text, stream=True):
        if ev.kind == "result":
            res: RouteResult = ev.data["result"]
            yield _sse("result", res.model_dump())
        elif ev.kind == "error":
            yield _sse("error", ev.data.body()["error"])
        else:
            yield _sse(ev.kind, ev.data)


@app.post("/v1/route-situation", dependencies=[Depends(check_auth)])
async def route_situation(
    body: RouteRequest,
    stream: bool = False,
    svc: RouterService = Depends(get_service),
):
    """Kết quả cuối luôn là JSON đã validate. stream=true: SSE gồm các sự kiện
    status | delta (mảnh tạm CHƯA validate, chỉ để hiển thị tiến trình) | result | error.
    App chỉ được dùng sự kiện `result`."""
    if stream:
        return StreamingResponse(
            _sse_stream(svc, body.text),
            media_type="text/event-stream",
            headers={"Cache-Control": "no-cache", "X-Request-Id": uuid.uuid4().hex[:8]},
        )
    outcome = await svc.route(body.text)
    if outcome.error is not None:
        raise outcome.error
    assert outcome.result is not None
    return JSONResponse(
        content=outcome.result.model_dump(),
        headers={"X-Route-Source": outcome.source},
    )

import json

import pytest
from fastapi.testclient import TestClient

from app.config import get_settings
from app.main import app, get_service
from app.router_service import RouterService
from tests.conftest import FakeLlm, make_settings, ok_json

BURN = {"text": "con tôi bị bỏng nước sôi ở tay"}


@pytest.fixture
def client_factory(index):
    def _make(responses, **kw):
        settings = make_settings(**kw)
        svc = RouterService(index, FakeLlm(responses), settings)
        app.dependency_overrides[get_service] = lambda: svc
        app.dependency_overrides[get_settings] = lambda: settings
        return TestClient(app)

    yield _make
    app.dependency_overrides.clear()


def test_healthz(client_factory):
    assert client_factory([ok_json()]).get("/healthz").json() == {"status": "ok"}


def test_route_thanh_cong(client_factory):
    r = client_factory([ok_json()]).post("/v1/route-situation", json=BURN)
    assert r.status_code == 200
    assert r.headers["x-route-source"] == "llm"
    assert set(r.json()) == {"category", "protocol_code", "confidence_note", "sources", "uncertain"}
    assert r.json()["protocol_code"] == "burns_thermal_chemical"


def test_rule_115_qua_http(client_factory):
    r = client_factory([ok_json()]).post(
        "/v1/route-situation", json={"text": "người lớn bất tỉnh không thở"}
    )
    assert r.status_code == 200
    assert r.headers["x-route-source"] == "rules"
    assert r.json()["category"] == "call_115_now"


@pytest.mark.parametrize("body", [{}, {"text": ""}, {"text": "   "}, {"text": "a" * 1001}, {"text": "x", "y": 1}])
def test_request_sai_tra_422_khong_phan_chieu(client_factory, body):
    r = client_factory([ok_json()]).post("/v1/route-situation", json=body)
    assert r.status_code == 422
    assert r.json()["error"]["code"] == "invalid_request"
    assert r.json()["error"]["fallback"] == "use_local_triage"
    assert "aaaa" not in r.text


def test_llm_loi_tra_ma_de_app_fallback(client_factory):
    r = client_factory(["không phải json"]).post("/v1/route-situation", json=BURN)
    assert r.status_code == 502
    assert r.json()["error"]["code"] == "llm_invalid_json"
    assert r.json()["error"]["fallback"] == "use_local_triage"


def test_auth_token_tuy_chon(client_factory):
    c = client_factory([ok_json()], api_auth_token="s3cret")
    assert c.post("/v1/route-situation", json=BURN).status_code == 401
    ok = c.post("/v1/route-situation", json=BURN, headers={"X-API-Key": "s3cret"})
    assert ok.status_code == 200


def parse_sse(text: str):
    events = []
    for block in text.strip().split("\n\n"):
        ev, data = block.split("\n", 1)
        events.append((ev.removeprefix("event: "), json.loads(data.removeprefix("data: "))))
    return events


def test_sse_co_status_delta_va_result_da_validate(client_factory):
    r = client_factory([ok_json()]).post("/v1/route-situation?stream=true", json=BURN)
    assert r.headers["content-type"].startswith("text/event-stream")
    ev = parse_sse(r.text)
    kinds = [k for k, _ in ev]
    assert kinds[0] == "status" and "delta" in kinds and kinds[-1] == "result"
    final = ev[-1][1]
    assert final["protocol_code"] == "burns_thermal_chemical"
    # các delta ghép lại chính là JSON LLM trả về
    assert json.loads("".join(d["text"] for k, d in ev if k == "delta"))["protocol_code"] == final["protocol_code"]


def test_sse_loi_validate_khong_phat_result(client_factory):
    r = client_factory([ok_json(code="khong_ton_tai")]).post(
        "/v1/route-situation?stream=true", json=BURN
    )
    ev = parse_sse(r.text)
    assert ev[-1][0] == "error"
    assert ev[-1][1]["code"] == "llm_protocol_not_allowed"
    assert "result" not in [k for k, _ in ev]


def test_sse_rule_khong_co_delta(client_factory):
    r = client_factory([ok_json()]).post(
        "/v1/route-situation?stream=true", json={"text": "máu phun ra từ tay"}
    )
    kinds = [k for k, _ in parse_sse(r.text)]
    assert "delta" not in kinds and kinds[-1] == "result"

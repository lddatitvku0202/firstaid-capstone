import asyncio
import json

import pytest

from app.llm import TransientLlmError
from app.router_service import (
    NOTE_FALLBACK, NOTE_OUT_OF_SCOPE, RouterService, validate_llm_output,
)
from app.schemas import RouteError, RouteResult
from tests.conftest import FakeLlm, make_settings, ok_json

BURN_TEXT = "con tôi bị bỏng nước sôi ở tay"


def hits_for(index, text=BURN_TEXT):
    return index.search(text, 3)


# ---------- validate_llm_output ----------
def test_hop_le(index):
    res = validate_llm_output(ok_json(), hits_for(index), index)
    assert res.protocol_code == "burns_thermal_chemical"
    assert res.uncertain is False


@pytest.mark.parametrize(
    "raw,code",
    [
        ("không phải json", "llm_invalid_json"),
        ("{}", "llm_schema_violation"),
        (ok_json(extra_field=1), "llm_schema_violation"),
        (ok_json(category="khong_co"), "llm_schema_violation"),
        (ok_json(code="khong_ton_tai"), "llm_protocol_not_allowed"),
        (ok_json(category="call_115_now"), "llm_schema_violation"),  # chỉ rule được phát
        (ok_json(category="choking"), "llm_schema_violation"),  # lệch chủ đề
        (ok_json(pages="999"), "llm_invalid_sources"),  # trang không có trong phác đồ
        (ok_json(sources=[]), "llm_invalid_sources"),
        (ok_json(code=None, category="out_of_scope", sources=[], uncertain=False),
         "llm_schema_violation"),
        (ok_json(code=None, category="burns", sources=[], uncertain=True),
         "llm_schema_violation"),
    ],
)
def test_validation_tra_ma_loi(index, raw, code):
    with pytest.raises(RouteError) as e:
        validate_llm_output(raw, hits_for(index), index)
    assert e.value.code == code


def test_ma_hop_le_nhung_khong_thuoc_ung_vien(index):
    # cpr_adult_adolescent có trong allowlist nhưng không phải ứng viên của câu bỏng
    raw = ok_json(code="cpr_adult_adolescent", category="cardiac_arrest_cpr", pages="159-162")
    with pytest.raises(RouteError) as e:
        validate_llm_output(raw, hits_for(index), index)
    assert e.value.code == "llm_protocol_not_allowed"


def test_null_hop_le_la_out_of_scope(index):
    raw = ok_json(code=None, category="out_of_scope", sources=[], uncertain=True)
    res = validate_llm_output(raw, hits_for(index), index)
    assert res.protocol_code is None and res.uncertain


def test_ghi_chu_co_thuoc_bi_thay(index):
    raw = ok_json(confidence_note="Nên uống paracetamol 500 mg và chẩn đoán là bỏng độ 2.")
    res = validate_llm_output(raw, hits_for(index), index)
    assert res.confidence_note == NOTE_FALLBACK


# ---------- service ----------
def run(coro):
    return asyncio.run(coro)


def test_rule_khong_goi_llm(make_service):
    svc, llm = make_service([ok_json()])
    out = run(svc.route("người lớn bất tỉnh, không thở"))
    assert out.source == "rules"
    assert out.result.category == "call_115_now"
    assert llm.calls == 0


def test_rule_chay_duoc_khi_khong_co_llm(index):
    svc = RouterService(index, None, make_settings())
    out = run(svc.route("máu phun ra từ tay"))
    assert out.source == "rules" and out.error is None


def test_cong_truy_xuat_khong_goi_llm_khi_khong_khop(make_service):
    svc, llm = make_service([ok_json()])
    out = run(svc.route("hôm nay trời đẹp quá"))
    assert out.source == "gate"
    assert out.result.uncertain is True
    assert out.result.protocol_code is None
    assert out.result.confidence_note == NOTE_OUT_OF_SCOPE
    assert llm.calls == 0


def test_llm_thanh_cong(make_service):
    svc, llm = make_service([ok_json()])
    out = run(svc.route(BURN_TEXT))
    assert out.source == "llm"
    assert out.result.protocol_code == "burns_thermal_chemical"
    assert llm.calls == 1
    # văn bản người dùng nằm trong thẻ dữ liệu
    assert "<tinh_huong>" in llm.prompts[0]


def test_retry_gioi_han_roi_thanh_cong(make_service):
    svc, llm = make_service([TransientLlmError("500"), ok_json()])
    out = run(svc.route(BURN_TEXT))
    assert out.result is not None and llm.calls == 2


def test_het_retry_tra_loi_unavailable(make_service):
    svc, llm = make_service([TransientLlmError("500")], llm_max_attempts=3)
    out = run(svc.route(BURN_TEXT))
    assert out.error.code == "llm_unavailable"
    assert out.error.http_status == 502
    assert llm.calls == 3  # giới hạn đúng số lần


def test_timeout_tra_ma_504(make_service):
    svc, _ = make_service([TransientLlmError("timeout")])
    out = run(svc.route(BURN_TEXT))
    assert out.error.code == "llm_timeout" and out.error.http_status == 504


def test_llm_that_su_treo_bi_cat_boi_timeout(index):
    class Hang(FakeLlm):
        async def generate(self, prompt, schema, system):
            await asyncio.sleep(60)

    svc = RouterService(
        index, Hang([]), make_settings(llm_timeout_s=0.05, llm_max_attempts=1)
    )
    out = run(svc.route(BURN_TEXT))
    assert out.error.code == "llm_timeout"


def test_chua_cau_hinh_key(index):
    svc = RouterService(index, None, make_settings())
    out = run(svc.route(BURN_TEXT))
    assert out.error.code == "llm_not_configured" and out.error.http_status == 503


def test_llm_tra_json_hong_khong_retry(make_service):
    svc, llm = make_service(["{hong"])
    out = run(svc.route(BURN_TEXT))
    assert out.error.code == "llm_invalid_json"
    assert llm.calls == 1


def test_log_khong_chua_noi_dung_nguoi_dung(make_service, caplog):
    svc, _ = make_service([ok_json()])
    with caplog.at_level("INFO", logger="firstaid.route"):
        run(svc.route(BURN_TEXT))
        run(svc.route("người lớn bất tỉnh, không thở"))
    text = "\n".join(r.getMessage() for r in caplog.records)
    assert "route ok" in text
    assert "bỏng" not in text and "nước sôi" not in text and "bất tỉnh" not in text


def test_ket_qua_cuoi_chi_co_5_truong(make_service):
    svc, _ = make_service([ok_json()])
    out = run(svc.route(BURN_TEXT))
    assert set(out.result.model_dump()) == {
        "category", "protocol_code", "confidence_note", "sources", "uncertain",
    }
    assert isinstance(out.result, RouteResult)
    json.dumps(out.result.model_dump())

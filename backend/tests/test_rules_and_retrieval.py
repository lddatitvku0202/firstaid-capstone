import pytest

from app.rules import check_emergency, rule_result
from app.textnorm import normalize
from app.schemas import RouteResult


def test_normalize_bo_dau():
    assert normalize("Bé bị Nghẹn, KHÔNG thở được!") == "be bi nghen khong tho duoc"
    assert normalize("đau đầu") == "dau dau"


@pytest.mark.parametrize(
    "text,rule,code",
    [
        ("Người lớn bất tỉnh, không thở", "cpr", "cpr_adult_adolescent"),
        ("em bé 3 tháng tuổi không thở", "cpr", "cpr_baby_child"),
        ("bé nhà tôi không phản ứng gì", "cpr", "cpr_baby_child"),
        ("bố tôi ngừng tim", "cpr", None),  # không rõ tuổi => không đoán
        ("em bé sơ sinh bị nghẹn, không khóc được", "choking", "choking_baby"),
        ("người lớn hóc xương, không nói được", "choking", "choking_adult_child"),
        ("hóc đồ ăn, không thở được", "choking", None),
        ("máu phun ra từ cánh tay", "bleeding", "bleeding_wounds_severe"),
        ("chảy máu nhiều không cầm được", "bleeding", "bleeding_wounds_severe"),
    ],
)
def test_rule_precheck_goi_115(text, rule, code):
    m = check_emergency(text)
    assert m is not None
    assert m.rule == rule
    assert m.protocol_code == code


@pytest.mark.parametrize(
    "text",
    [
        "bị bỏng nước sôi ở tay",
        "hôm nay trời đẹp quá",
        "đau bụng nhẹ từ sáng",
        "bé ho sặc sữa nhưng vẫn ho được",
    ],
)
def test_rule_khong_kich_hoat(text):
    assert check_emergency(text) is None


def test_rule_result_dung_schema_va_nguon(index):
    m = check_emergency("người lớn bất tỉnh không thở")
    res = rule_result(m, index)
    assert isinstance(res, RouteResult)
    assert res.category == "call_115_now"
    assert res.protocol_code == "cpr_adult_adolescent"
    assert res.uncertain is False
    assert {(s.source_id, s.pages) for s in res.sources} == {("IFRC-2025", "159-162")}


def test_rule_khong_ro_tuoi_la_uncertain(index):
    res = rule_result(check_emergency("bố tôi ngừng tim"), index)
    assert res.category == "call_115_now"
    assert res.protocol_code is None
    assert res.uncertain is True
    assert res.sources == []


def test_index_chi_chua_muc_verified(index):
    assert index.codes  # không rỗng
    assert set(index.codes) == {
        "bleeding_wounds_severe", "burns_thermal_chemical", "choking_adult_child",
        "choking_baby", "cpr_adult_adolescent", "cpr_baby_child",
    }
    assert index.meta["skipped_not_verified"] == []


def test_index_loc_muc_unverified():
    from app.retrieval import ProtocolIndex

    entry = {
        "code": "x_unverified", "title": "x", "topic_id": "burns", "age_group": "all",
        "citations": [{"source_id": "S", "pages": "1"}], "text": "bong", "aliases": [],
        "source_verification": "unverified",
    }
    assert ProtocolIndex([entry]).codes == []


def test_retrieval_bong_nuoc_soi(index):
    hits = index.search("con tôi bị bỏng nước sôi ở tay", 3)
    assert hits[0].protocol.code == "burns_thermal_chemical"


def test_retrieval_khong_khop_thi_rong(index):
    assert index.search("hôm nay trời đẹp quá", 3) == []
    assert index.search("   ", 3) == []

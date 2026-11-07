"""Bộ đánh giá pipeline định tuyến. Chạy từ thư mục backend/ :

  python eval/run_eval.py --mode retrieval      # offline: quy tắc 115 + cổng truy xuất (KHÔNG gọi API)
  python eval/run_eval.py --mode fallback-sim   # offline: mô phỏng lỗi LLM bằng fake (KHÔNG gọi API)
  python eval/run_eval.py --mode llm --confirm-real-api   # GỌI GEMINI THẬT, tốn quota, cần GEMINI_API_KEY
  python eval/run_eval.py --list-models --confirm-real-api  # liệt kê model thật (gọi API)

Nhãn trong cases.jsonl do nhóm tự gán (label_source = team_self_assigned_needs_review),
cần người dùng rà lại. Kết quả lưu vào docs/evidence/ai/ kèm timestamp, model, phiên bản.
Số đo chỉ có ý nghĩa với tập này: không phải độ chính xác tổng quát.
"""

from __future__ import annotations

import argparse
import asyncio
import hashlib
import json
import platform
import statistics
import subprocess
import sys
import time
from datetime import datetime
from pathlib import Path

BACKEND = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(BACKEND))

from app.config import Settings  # noqa: E402
from app.llm import GeminiClient, TransientLlmError  # noqa: E402
from app.retrieval import ProtocolIndex  # noqa: E402
from app.router_service import RouterService  # noqa: E402
from app.rules import check_emergency  # noqa: E402

CASES = BACKEND / "eval" / "cases.jsonl"
OUT_DIR = BACKEND.parent / "docs" / "evidence" / "ai"
LLM_ERRORS_SCHEMA = {"llm_invalid_json", "llm_schema_violation"}
LLM_ERRORS_INFRA = {"llm_timeout", "llm_unavailable", "llm_not_configured"}


def load_cases() -> list[dict]:
    return [json.loads(l) for l in CASES.read_text(encoding="utf-8").splitlines() if l.strip()]


def pct(n: int, d: int) -> dict:
    return {"num": n, "den": d, "rate": (round(n / d, 4) if d else None)}


def percentile(values: list[float], q: float) -> float | None:
    if not values:
        return None
    s = sorted(values)
    k = max(0, min(len(s) - 1, int(round(q * (len(s) - 1)))))
    return round(s[k], 2)


def lat(values: list[float]) -> dict:
    return {"n": len(values), "p50_ms": percentile(values, 0.5), "p95_ms": percentile(values, 0.95)}


def meta(mode: str, settings: Settings, index: ProtocolIndex) -> dict:
    try:
        import google.genai as g

        sdk = getattr(g, "__version__", "unknown")
    except Exception:  # noqa: BLE001
        sdk = "not-installed"
    try:
        commit = subprocess.run(
            ["git", "rev-parse", "--short", "HEAD"], capture_output=True, text=True, cwd=BACKEND
        ).stdout.strip()
    except Exception:  # noqa: BLE001
        commit = ""
    return {
        "timestamp": datetime.now().astimezone().isoformat(timespec="seconds"),
        "mode": mode,
        "model": settings.gemini_model if mode == "llm" else "n/a (không gọi LLM)",
        "google_genai_version": sdk,
        "python": platform.python_version(),
        "git_commit": commit or "n/a",
        "index_source_data_version": index.meta.get("source_data_version"),
        "index_source_sha256": index.meta.get("source_sha256"),
        "cases_sha256": hashlib.sha256(CASES.read_bytes()).hexdigest(),
        "settings": {
            "retrieval_top_k": settings.retrieval_top_k,
            "retrieval_min_score": settings.retrieval_min_score,
            "llm_timeout_s": settings.llm_timeout_s,
            "llm_max_attempts": settings.llm_max_attempts,
        },
        "label_note": "Nhãn do nhóm tự gán, cần người dùng rà lại; không phải bộ kiểm chuẩn độc lập.",
    }


# ------------------------------------------------------------------ retrieval (offline)
def eval_retrieval(cases: list[dict], index: ProtocolIndex, settings: Settings) -> dict:
    rows = []
    rule_lat: list[float] = []
    for c in cases:
        t0 = time.perf_counter()
        m = check_emergency(c["text"])
        hits = [] if m else [
            h for h in index.search(c["text"], settings.retrieval_top_k)
            if h.score >= settings.retrieval_min_score
        ]
        ms = (time.perf_counter() - t0) * 1000
        rule_lat.append(ms)
        rows.append({
            "id": c["id"], "kind": c["kind"], "rule_fired": m is not None,
            "rule_code": m.protocol_code if m else None,
            "candidates": [h.protocol.code for h in hits],
            "expected": c["expected_protocol_code"], "expect_call_115": c["expect_call_115"],
        })
    c115 = [r for r in rows if r["expect_call_115"]]
    non115 = [r for r in rows if not r["expect_call_115"]]
    rule_code_ok = [r for r in c115 if r["rule_fired"] and r["rule_code"] == r["expected"]]
    coded = [r for r in rows if not r["rule_fired"] and r["expected"]]
    unexpected = [r for r in rows if not r["expected"] and not r["rule_fired"]]
    return {
        "rule_recall_on_expect_call_115": pct(sum(r["rule_fired"] for r in c115), len(c115)),
        "rule_code_matches_label_when_fired": pct(len(rule_code_ok), sum(r["rule_fired"] for r in c115)),
        "rule_false_positive_on_non_115": pct(sum(r["rule_fired"] for r in non115), len(non115)),
        "retrieval_recall_at_k_non_rule_cases_with_label": pct(
            sum(r["expected"] in r["candidates"] for r in coded), len(coded)),
        "retrieval_top1_non_rule_cases_with_label": pct(
            sum(bool(r["candidates"]) and r["candidates"][0] == r["expected"] for r in coded), len(coded)),
        "gate_blocks_cases_without_label": pct(
            sum(not r["candidates"] for r in unexpected), len(unexpected)),
        "gate_wrongly_blocks_cases_with_label": pct(sum(not r["candidates"] for r in coded), len(coded)),
        "latency_in_process_ms": lat(rule_lat),
        "rows": rows,
        "caveat": "Quy tắc và danh sách alias do cùng nhóm viết và nhãn do nhóm tự gán: số đo có tính vòng tròn, "
                  "chỉ cho thấy hành vi, không chứng minh độ chính xác.",
    }


# ------------------------------------------------------------------ fallback-sim (offline)
class SimLlm:
    def __init__(self, behavior: str):
        self.behavior = behavior

    async def generate(self, prompt, schema, system):
        b = self.behavior
        if b == "timeout":
            raise TransientLlmError("timeout")
        if b == "http500":
            raise TransientLlmError("server 500")
        if b == "http429":
            raise TransientLlmError("rate limited")
        if b == "hang":
            await asyncio.sleep(30)
        if b == "bad_json":
            return "đây không phải json"
        if b == "bad_code":
            return json.dumps({"category": "burns", "protocol_code": "ma_bia_ra", "confidence_note": "x",
                               "sources": [{"source_id": "IFRC-2025", "pages": "288-290"}], "uncertain": False})
        if b == "bad_sources":
            return json.dumps({"category": "burns", "protocol_code": "burns_thermal_chemical",
                               "confidence_note": "x", "sources": [{"source_id": "NGUON-BIA", "pages": "1"}],
                               "uncertain": False})
        if b == "extra_field":
            return json.dumps({"category": "burns", "protocol_code": "burns_thermal_chemical",
                               "confidence_note": "x", "sources": [{"source_id": "IFRC-2025", "pages": "288-290"}],
                               "uncertain": False, "dosage": "500mg"})
        raise AssertionError(b)

    async def stream(self, prompt, schema, system):
        yield await self.generate(prompt, schema, system)


SIM_EXPECT = {
    "timeout": "llm_timeout", "hang": "llm_timeout", "http500": "llm_unavailable",
    "http429": "llm_unavailable", "bad_json": "llm_invalid_json", "bad_code": "llm_protocol_not_allowed",
    "bad_sources": "llm_invalid_sources", "extra_field": "llm_schema_violation",
}


async def eval_fallback_sim(index: ProtocolIndex, settings: Settings) -> dict:
    fast = settings.model_copy(update={"llm_retry_backoff_s": 0.0, "llm_timeout_s": 0.2, "llm_max_attempts": 2})
    rows = []
    for behavior, expected in SIM_EXPECT.items():
        svc = RouterService(index, SimLlm(behavior), fast)
        out = await svc.route("con tôi bị bỏng nước sôi ở tay")
        rows.append({
            "scenario": behavior, "expected_error": expected,
            "got_error": out.error.code if out.error else None,
            "http_status": out.error.http_status if out.error else None,
            "fallback_hint": out.error.body()["error"]["fallback"] if out.error else None,
            "pass": bool(out.error and out.error.code == expected and out.result is None),
        })
    svc = RouterService(index, SimLlm("http500"), fast)
    out = await svc.route("người lớn bất tỉnh, không thở")
    rows.append({
        "scenario": "llm_down_but_rule_115", "expected_error": None, "got_error": None,
        "pass": bool(out.result and out.source == "rules" and out.result.category == "call_115_now"),
    })
    svc = RouterService(index, None, fast)
    out = await svc.route("con tôi bị bỏng nước sôi ở tay")
    rows.append({
        "scenario": "no_api_key", "expected_error": "llm_not_configured",
        "got_error": out.error.code if out.error else None, "pass": bool(out.error and out.error.code == "llm_not_configured"),
    })
    return {"scenarios": pct(sum(r["pass"] for r in rows), len(rows)), "rows": rows,
            "caveat": "Mô phỏng bằng fake LLM; KHÔNG phải hành vi của Gemini thật hay mạng thật."}


# ------------------------------------------------------------------ llm (API thật)
async def eval_llm(cases: list[dict], index: ProtocolIndex, settings: Settings, delay: float, limit: int | None) -> dict:
    client = GeminiClient(settings.gemini_api_key, settings.gemini_model, settings.llm_timeout_s)
    svc = RouterService(index, client, settings)
    rows = []
    for c in (cases[:limit] if limit else cases):
        out = await svc.route(c["text"])
        res = out.result
        rows.append({
            "id": c["id"], "kind": c["kind"], "source": out.source, "latency_ms": round(out.latency_ms, 1),
            "pred_code": res.protocol_code if res else None, "pred_uncertain": res.uncertain if res else None,
            "pred_category": res.category if res else None,
            "error": out.error.code if out.error else None,
            # Chi tiết lỗi hạ tầng (vd. "HTTP 429 (rate limited)") và đầu ra thô của LLM
            # khi validate lỗi (cắt tối đa 200 ký tự). Chỉ có trong file eval.
            "error_detail": out.error.detail if out.error else None,
            "raw_llm_output": out.error.raw_output if out.error else None,
            "expected": c["expected_protocol_code"], "expect_uncertain": c["expect_uncertain"],
            "expect_call_115": c["expect_call_115"],
        })
        if out.source == "llm" or out.error:
            await asyncio.sleep(delay)
    answered = [r for r in rows if r["error"] is None]
    reached_llm = [r for r in rows if r["source"] == "llm" or (r["error"] and r["error"].startswith("llm_") and r["error"] != "llm_not_configured")]
    parsed_ok = [r for r in reached_llm if r["error"] not in LLM_ERRORS_SCHEMA | LLM_ERRORS_INFRA]
    with_code = [r for r in parsed_ok if r["pred_code"]]
    src_bad = [r for r in reached_llm if r["error"] == "llm_invalid_sources"]
    infra = [r for r in rows if r["error"] in LLM_ERRORS_INFRA]
    return {
        "code_exact_all_cases_errors_count_wrong": pct(
            sum(r["error"] is None and r["pred_code"] == r["expected"] for r in rows), len(rows)),
        "code_exact_answered_only": pct(
            sum(r["pred_code"] == r["expected"] for r in answered), len(answered)),
        "uncertain_agreement_answered": pct(
            sum(r["pred_uncertain"] == r["expect_uncertain"] for r in answered), len(answered)),
        "llm_output_passes_schema": pct(
            len(reached_llm) - sum(r["error"] in LLM_ERRORS_SCHEMA for r in reached_llm) - len(infra), len(reached_llm) - len(infra)),
        "llm_sources_valid_when_code_given": pct(len(with_code), len(with_code) + len(src_bad)),
        "infra_failures_fallback_rate": pct(len(infra), len(rows)),
        "rule_path_cases": pct(sum(r["source"] == "rules" for r in rows), len(rows)),
        "gate_path_cases": pct(sum(r["source"] == "gate" for r in rows), len(rows)),
        "latency_llm_path_ms": lat([r["latency_ms"] for r in rows if r["source"] == "llm"]),
        "latency_rules_gate_ms": lat([r["latency_ms"] for r in rows if r["source"] in ("rules", "gate")]),
        "rows": rows,
        "caveat": "Độ trễ đo trong tiến trình tại máy chạy (gồm mạng tới Gemini), không gồm hop HTTP tới backend. "
                  "Mẫu nhỏ; p95 trên ~vài chục mẫu không ổn định.",
    }


def list_models(settings: Settings) -> list[str]:
    from google import genai

    c = genai.Client(api_key=settings.gemini_api_key)
    return sorted(m.name for m in c.models.list())


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--mode", choices=["retrieval", "fallback-sim", "llm"])
    ap.add_argument("--confirm-real-api", action="store_true", help="bắt buộc cho mode llm và --list-models")
    ap.add_argument("--list-models", action="store_true")
    ap.add_argument("--delay", type=float, default=1.0, help="giây nghỉ giữa các lần gọi API")
    ap.add_argument("--limit", type=int, default=None)
    ap.add_argument("--no-save", action="store_true")
    a = ap.parse_args()

    settings = Settings()
    index = ProtocolIndex.from_file(settings.index_path)
    cases = load_cases()

    if a.list_models:
        if not a.confirm_real_api or not settings.gemini_api_key:
            print("Cần --confirm-real-api và GEMINI_API_KEY.")
            return 2
        print("\n".join(list_models(settings)))
        return 0
    if not a.mode:
        ap.error("cần --mode")
    if a.mode == "llm" and not (a.confirm_real_api and settings.gemini_api_key):
        print("Mode llm gọi Gemini thật (tốn quota). Cần --confirm-real-api và GEMINI_API_KEY. CHƯA ĐO.")
        return 2

    if a.mode == "retrieval":
        body = eval_retrieval(cases, index, settings)
    elif a.mode == "fallback-sim":
        body = asyncio.run(eval_fallback_sim(index, settings))
    else:
        body = asyncio.run(eval_llm(cases, index, settings, a.delay, a.limit))

    result = {"meta": meta(a.mode, settings, index), "n_cases": len(cases), "results": body}
    text = json.dumps(result, ensure_ascii=False, indent=2)
    if not a.no_save:
        OUT_DIR.mkdir(parents=True, exist_ok=True)
        stamp = datetime.now().strftime("%Y%m%d-%H%M%S")
        path = OUT_DIR / f"eval-{a.mode}-{stamp}.json"
        path.write_text(text + "\n", encoding="utf-8")
        print(f"saved {path}")
    summary = {k: v for k, v in body.items() if k not in ("rows",)}
    print(json.dumps(summary, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    sys.exit(main())

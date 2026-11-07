# FirstAid backend: định tuyến tình huống tới mã phác đồ

FastAPI + RAG-lite (BM25) + Gemini. AI **chỉ chọn mã phác đồ có sẵn**; không chẩn đoán, không kê thuốc, không sinh hướng dẫn sơ cứu. Nội dung sơ cứu luôn lấy từ phác đồ trong app (Drift), không từ LLM.

Trạng thái: code và test mock đã chạy (pytest, xem `docs/evidence/tests/`). Chưa gọi Gemini thật (chưa đo), chưa deploy, chưa build Docker (máy không có Docker).

## Chạy local (PowerShell, đường dẫn có dấu cách phải để trong nháy)
```powershell
cd "D:\Start Github\firstaid-capstone\backend"
python -m venv .venv                     # Python 3.10
.\.venv\Scripts\python -m pip install -r requirements-dev.txt
Copy-Item .env.example .env              # rồi điền GEMINI_API_KEY (file .env đã gitignore)
.\.venv\Scripts\python scripts\build_index.py   # sinh data/protocols_index.json từ app/assets
.\.venv\Scripts\python -m pytest -v      # không cần key
.\.venv\Scripts\python -m uvicorn app.main:app --reload
```

## API
`POST /v1/route-situation` body `{"text": "<1-1000 ký tự>"}`. Thêm `?stream=true` để nhận SSE.

Kết quả (cố định 5 trường):
```json
{"category": "burns", "protocol_code": "burns_thermal_chemical",
 "confidence_note": "…", "sources": [{"source_id": "IFRC-2025", "pages": "288-290"}], "uncertain": false}
```
- `category`: `cardiac_arrest_cpr | choking | bleeding_wounds | burns | call_115_now | out_of_scope`. `call_115_now` chỉ do quy tắc xác định (không qua LLM).
- `protocol_code = null` đi với `uncertain = true` (mơ hồ, thiếu tuổi, ngoài phạm vi, hoặc không đủ nguồn).
- Header `X-Route-Source`: `rules | llm | gate` (gate = truy xuất không đủ điểm, không gọi LLM).

Lỗi (để app fallback sang sàng lọc cục bộ): `{"error": {"code", "message", "fallback": "use_local_triage"}}`

| Mã | HTTP | Ý nghĩa |
|---|---|---|
| invalid_request | 422 | text rỗng/quá dài/thừa trường |
| llm_not_configured | 503 | thiếu GEMINI_API_KEY |
| llm_timeout | 504 | LLM quá thời gian (sau retry) |
| llm_unavailable | 502 | lỗi tạm thời 429/5xx/mạng (sau retry) hoặc Gemini từ chối |
| llm_invalid_json / llm_schema_violation | 502 | đầu ra LLM không đúng schema |
| llm_protocol_not_allowed | 502 | mã không thuộc ứng viên truy xuất/allowlist |
| llm_invalid_sources | 502 | sources không khớp trích dẫn của phác đồ |

SSE: sự kiện `status` (tiến trình), `delta` (mảnh đầu ra LLM **chưa validate**, chỉ để hiển thị tiến trình, không được parse để ra quyết định), `result` (JSON đã validate đầy đủ) hoặc `error`. App chỉ dùng `result`.

## Pipeline
Xem sơ đồ trong `docs/reports/R3_AI_Offline_Testing.md`. Tóm tắt: validate input → quy tắc 115 (`app/rules.py`) → BM25 trên `protocols_index.json` (chỉ mục `verified`) → cổng điểm tối thiểu → Gemini chọn mã trong ứng viên (JSON schema) → validate (schema, allowlist, ứng viên, chủ đề, sources) → trả kết quả.

## Cấu hình (biến môi trường / `backend/.env`)
`GEMINI_API_KEY` (bắt buộc cho đường LLM), `GEMINI_MODEL` (mặc định `gemini-2.5-flash`, **tên chưa được xác minh bằng API trong repo**; xem model thật bằng `python eval/run_eval.py --list-models --confirm-real-api`), `API_AUTH_TOKEN` (tùy chọn, header `X-API-Key`). Token nhúng trong app không phải bí mật thật, chỉ giảm lạm dụng ngẫu nhiên; endpoint công khai vẫn có rủi ro cạn quota (xem risk-register).

## Log và dữ liệu nhạy cảm
Log chỉ ghi request id, nguồn xử lý, mã phác đồ, `uncertain`, độ dài văn bản và thời gian; **không ghi nội dung người dùng** (có test). Không lưu yêu cầu. Lưu ý: nội dung tình huống vẫn được gửi tới Gemini (dịch vụ bên thứ ba) khi đi đường LLM.

## Đánh giá
`eval/cases.jsonl` (35 ca, nhãn **do nhóm tự gán, cần người dùng rà lại**) và `eval/run_eval.py`:
```powershell
.\.venv\Scripts\python eval\run_eval.py --mode retrieval      # offline, không gọi API
.\.venv\Scripts\python eval\run_eval.py --mode fallback-sim   # offline, fake LLM
.\.venv\Scripts\python eval\run_eval.py --mode llm --confirm-real-api   # GỌI GEMINI THẬT, tốn quota
```
Kết quả lưu ở `docs/evidence/ai/eval-<mode>-<timestamp>.json` (kèm model, phiên bản SDK, sha256 của dữ liệu và bộ ca). Mode `llm` đã chạy 2 lần (2026-11-08, gemini-2.5-flash): `eval-llm-20261108-020235.json` (lần 1) và `eval-llm-20261108-021429.json` (lần 2, sau khi sửa định dạng nguồn trong prompt). Lần 2: nguồn hợp lệ 5/5, đúng mã 18/20, độ trễ đường LLM p50 2698 ms / p95 3244 ms, nhưng 14/35 ca (40%) lỗi hạ tầng HTTP 429 (rate limit) nên chỉ 6 ca có đầu ra LLM. **Mẫu rất nhỏ, chưa chạy với retry/backoff đủ dài** (cấu hình hiện tại: tối đa 2 lần gọi, backoff 0,5 s), nên các tỷ lệ chưa ổn định và hai lượt không so sánh trực tiếp được. Time to first token của SSE **CHƯA ĐO** (eval dùng chế độ không stream). Chi tiết: R3 mục 1.

## Docker và deploy
```powershell
docker build -t firstaid-backend .
docker run --rm -p 8000:8000 -e GEMINI_API_KEY=... firstaid-backend
```
**Chưa build/chạy thử Docker và chưa deploy** (máy phát triển không có Docker; chưa chọn nền tảng). Nền tảng tương thích dự kiến: Render, Railway, Fly.io (đều chạy Docker image và cấp biến `PORT`; Dockerfile đã đọc `PORT`). Các bước cụ thể sẽ được viết sau khi chọn nền tảng. Nguyên tắc chung: đặt `GEMINI_API_KEY` trong phần secrets/environment của nền tảng, không đưa vào image, kiểm tra `GET /healthz`.

## Giới hạn đã biết
- Danh sách từ khóa quy tắc 115, alias truy xuất và từ dừng do nhóm tự viết, chưa rà soát lâm sàng. Quy tắc thiên về báo động thừa và không hiểu phủ định.
- Chỉ phủ 4 chủ đề của 6 phác đồ; mọi thứ khác là `out_of_scope`. Ví dụ "bị rắn cắn" chỉ được trả `out_of_scope` nếu cổng/LLM làm đúng.
- BM25 trên 6 tài liệu, không hiểu ngữ nghĩa, nhạy với cách diễn đạt (xem kết quả eval retrieval).
- Ngưỡng điểm tối thiểu 2.0 do nhóm chọn thủ công từ vài ví dụ, chưa kiểm định trên tập tách riêng.

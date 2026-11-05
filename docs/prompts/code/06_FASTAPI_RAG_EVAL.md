# PROMPT 06 — FastAPI + Gemini + RAG-lite + validation + bộ đánh giá AI

Đọc CLAUDE.md. Dùng Plan mode. Python hiện có là 3.10.11: tạo venv trong backend/.venv, kiểm tra thư viện tương thích 3.10 trước khi chốt.

## Thiết kế
1. backend/ (FastAPI + pydantic). POST /v1/route-situation: nhận mô tả tình huống (text) -> JSON schema cố định {category, protocol_code, confidence_note, sources[], uncertain: bool}. Hỗ trợ streaming (SSE) trạng thái/đoạn giải thích ngắn; kết quả cuối vẫn phải validate đủ JSON trước khi dùng.
2. Retrieval (RAG-lite) trên backend/data/protocols_index.json sinh từ app/assets/protocols (BM25 hoặc embedding đơn giản). Không đủ nguồn phù hợp thì uncertain=true, không bịa.
3. Gọi Gemini bằng GEMINI_API_KEY trong biến môi trường; kiểm tra tài liệu SDK chính thức hiện hành, không đoán tên API. Có .env.example. Không hardcode.
4. Validation: schema pydantic; protocol_code thuộc allowlist; sources tồn tại; sai thì trả mã lỗi để app fallback. System prompt: không chẩn đoán, không kê thuốc, chỉ chọn mã phác đồ. Chỉ nạp các mục có source_verification=verified.
5. Tiền kiểm quy tắc xác định (từ khóa nguy cấp) -> "gọi 115" không phụ thuộc LLM.
6. Log không chứa dữ liệu nhạy cảm; timeout và retry giới hạn.
7. Dockerfile + hướng dẫn deploy (hỏi người dùng nền tảng: Render/Railway/Fly...). Chưa deploy được thì ghi rõ.
8. Bộ đánh giá: backend/eval/cases.jsonl (đề xuất 30-40 mô tả tình huống đa dạng, có nhãn protocol_code mong đợi, gồm câu mơ hồ và ngoài phạm vi; ĐÁNH DẤU là nhãn do nhóm tự gán, người dùng cần rà lại) + backend/eval/run_eval.py đo: tỷ lệ đúng mã, tỷ lệ vượt schema, tỷ lệ nguồn hợp lệ, độ trễ p50/p95, hành vi fallback khi lỗi API. Lưu kết quả vào docs/evidence/ai/ kèm timestamp, model, phiên bản.
9. pytest cho validation và quy tắc xác định (chạy được không cần key, dùng mock). Chạy pytest, lưu log. Chỉ chạy run_eval khi người dùng đã cấp key; chưa chạy thì ghi "CHƯA ĐO".
10. Cập nhật R3 mục AI (sơ đồ pipeline Mermaid; bảng metric chỉ điền số đã đo; metric RAM không áp dụng cho cloud AI thì ghi rõ lý do), R4 chương 4, decision-log (vì sao RAG-lite, vì sao AI chỉ trả mã), evidence-ledger.

## Điều kiện dừng
Không tự commit. Commit đề xuất: "feat: fastapi rag-lite routing service with validation and eval harness".

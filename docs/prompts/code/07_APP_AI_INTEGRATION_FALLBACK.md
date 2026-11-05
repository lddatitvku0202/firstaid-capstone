# PROMPT 07 — Nối app với AI + fallback

Đọc CLAUDE.md. Dùng Plan mode.

1. Domain: use case RouteSituation + interface AiRouterRepository. Data: client HTTP gọi /v1/route-situation (base URL qua --dart-define), hỗ trợ SSE.
2. Presentation: màn "Mô tả tình huống": ô nhập, trạng thái đang xử lý, kết quả = mở phác đồ từ Drift theo protocol_code (không hiển thị văn bản y khoa do LLM sinh). Hiện nguồn + cảnh báo "kết quả tham khảo".
3. Fallback: mất mạng, timeout, lỗi, uncertain, mã không có trong allowlist local, hoặc từ khóa nguy cấp -> chuyển sang cây quyết định tĩnh / Gọi 115. Có nút bỏ qua ngay, người dùng không phải chờ AI.
4. Thông báo quyền riêng tư: văn bản mô tả được gửi lên máy chủ; xin đồng ý trước lần gọi đầu.
5. Test: unit test use case với fake repository (thành công, uncertain, timeout, mã sai); widget test các trạng thái. Chạy analyze + test, lưu log.
6. Cập nhật R3, R4, traceability. Ghi "[CHỜ NGƯỜI DÙNG QUAY VIDEO]" cho kịch bản: online -> AI -> tắt mạng -> fallback.

Không tự commit. Commit đề xuất: "feat: connect app to ai routing with safe fallback".

# PROMPT 10 — Tổng hợp R1–R4, slide, checklist nộp

Đọc CLAUDE.md, mọi file trong docs/ và git log thật. Dùng Plan mode.

1. Rà evidence-ledger.md và traceability: đối chiếu mọi tuyên bố trong docs/reports/*.md với bằng chứng. Liệt kê tuyên bố không có bằng chứng; sửa thành "chưa hoàn thành" hoặc xóa, không bịa.
2. Hoàn thiện R1, R2, R3, R4 đúng cấu trúc template gốc (R4: 6 chương, 25-40 trang, gồm Dark Mode, FPS, test, chỉ số AI, CI/CD, bài học, hướng phát triển; các mục P2 như vision triage, bản đồ cộng đồng, cảm biến CPR chỉ ghi ở Future Work). Giữ ghi chú "bổ sung muộn, nộp gộp" ở R1-R3. Ghi rõ Figma là prototype định hướng luồng, giao diện cuối là app đã chạy. Nhúng ảnh từ docs/evidence nếu có; chỗ chưa có ghi rõ.
3. Slide 10-12 trang (Markdown hoặc pptx) từ R4.
4. README.md: giới thiệu, kiến trúc, cài đặt, chạy app/backend, chạy test, cấu trúc thư mục, build release.
5. submission-checklist.md đối chiếu Q1-Q19; liệt kê việc người dùng phải tự cung cấp (Q1-Q6, Q9 thành viên và %, Q17, link Figma, video, APK, Drive). Không điền thông tin cá nhân hay link giả.
6. Xuất PDF R1-R4 vào dist/FirstAid_Capstone_Submission/. Máy CHƯA có pandoc: dùng Python (pip install markdown) chuyển Markdown sang HTML rồi in PDF bằng Chrome headless (C:\Program Files (x86)\Google\Chrome\Application\chrome.exe --headless --print-to-pdf), hoặc hướng dẫn cài pandoc nếu người dùng muốn. Báo file nào xuất thành công, file nào lỗi. Bên cạnh PDF để slide và thư mục Evidence/.
7. In "Danh sách còn thiếu trước khi nộp" theo mức độ ưu tiên.

Không tự commit. Commit đề xuất: "docs: final reports, slides and submission checklist".

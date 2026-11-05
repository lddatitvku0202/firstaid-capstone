# Cách dùng bộ prompt Claude Code (00-10)

Đặt cả thư mục này vào `docs/prompts/code/` trong repo. Trong khung chat Claude Code gõ đúng một dòng, ví dụ:

    Đọc docs/prompts/code/00_BOOTSTRAP_RULES_AND_DOCS.md và thực hiện. Dùng Plan mode.

## Quy trình mỗi prompt
1. Bật Plan mode, đọc kế hoạch, duyệt rồi mới cho chạy.
2. Sau khi chạy xong: xem `git diff`, tự chạy lại lệnh test/analyze, đọc output.
3. Tự commit (Claude Code không tự commit). Mỗi prompt một commit, rồi `git push`.
4. Chỉ sang prompt kế tiếp khi prompt hiện tại đã ổn.

## Thứ tự
00 -> 01 -> (02 cần tài liệu y khoa trong docs/source/medical/) -> 03 -> 04 -> 05 -> 06 -> 07 -> 08 -> 09 -> 10
- Prompt 09 (CI/Fastlane) có thể làm ngay sau 01 để pipeline xanh sớm.
- Prompt 03 trở đi nên có điện thoại Android thật để chụp ảnh/quay video/đo FPS.

## Việc chỉ bạn làm được (Claude Code không làm thay)
- Chụp ảnh sáng/tối, quay video demo 3-5 phút trên máy thật, đo FPS bằng DevTools.
- Lấy tài liệu y khoa từ nguồn chính thức và đặt vào docs/source/medical/.
- Tạo Supabase project, Gemini API key, hosting FastAPI, keystore + GitHub Secrets.
- Điền biểu mẫu Q1-Q19, đặt link Drive/Figma ở chế độ công khai.

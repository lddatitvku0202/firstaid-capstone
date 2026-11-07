> Báo cáo bổ sung muộn, nộp gộp theo hướng dẫn của giảng viên; nội dung phản ánh trạng thái thực tế tại thời điểm viết.

# [REPORT 1] PROJECT PROPOSAL & INTERACTIVE WIREFRAME PROTOTYPE
**Course:** Cross-Platform Mobile App Development  
**Project Title:** FirstAid – Ứng dụng trợ lý sơ cứu khẩn cấp ngoại tuyến và kết nối hỗ trợ cộng đồng / Offline-First Emergency First Aid Assistant & Community Support App  
**Team Name:** [CHƯA CÓ BẰNG CHỨNG: tên nhóm do người dùng cung cấp] • **Academic Term:** Semester 1 (2026 - 2027) • **Deadline:** Week 4

---

## 1. PROJECT MOTIVATION & PROBLEM STATEMENT
### 1.1. Context & Practical Problem Space
Nguồn: docs/source/description/FirstAid_Mo_ta_de_tai_hieu_chinh_Capstone.docx (mục 1-2).
Trong tình huống sơ cứu khẩn cấp, người chứng kiến có thể hoảng loạn, quên trình tự, khó đánh giá thông tin trên Internet, gặp mẹo truyền miệng nguy hiểm hoặc không có mạng ổn định để tra cứu.

### 1.2. Target User Personas
* **Primary Persona:** Người dân, sinh viên, người đi đường, gia đình, người làm việc ngoài hiện trường, tình nguyện viên (theo mô tả đề tài). [CHƯA CÓ BẰNG CHỨNG: persona chi tiết (tuổi, nghề nghiệp, pain points) chưa được nhóm viết.]
* **Typical User Story:** Mở nhanh chế độ khẩn cấp (không cần đăng nhập) → trả lời câu hỏi sàng lọc ngắn → xem các bước có đọc to → gọi 115 / soạn SMS kèm vị trí để người dùng xác nhận.

---

## 2. SYSTEM SCOPE & FUNCTIONAL SPECIFICATIONS
| # | Feature Category | Concrete Feature | Priority | Business Logic & Scope |
|:---:|---|---|:---:|---|
| 1 | Core | Chế độ khẩn cấp một chạm | Must-Have | Không cần tài khoản; câu hỏi sàng lọc theo luồng quyết định đã kiểm duyệt. |
| 2 | Offline | Cẩm nang sơ cứu offline | Must-Have | Drift/SQLite; TTS đọc từng bước; hiển thị nguồn và phiên bản. |
| 3 | Location | SOS và vị trí | Must-Have | Gọi 115; lấy tọa độ khi được cấp quyền; mở SMS soạn sẵn, không gửi âm thầm. |
| 4 | AI | AI hỗ trợ tìm đúng hướng dẫn | Must-Have | Streaming LLM + RAG qua FastAPI; chỉ định tuyến tới phác đồ có sẵn; offline dùng luồng quyết định tĩnh. |
| 5 | Core | Bộ đếm nhịp CPR | Should-Have | Metronome 100-120 nhịp/phút; không tuyên bố đo độ sâu ép tim. |
| 6 | Extension | Bản đồ điểm hỗ trợ; cộng đồng tình nguyện viên | Could-Have | Mở rộng, chưa cam kết ở MVP. |

### Luồng người dùng và màn hình đã triển khai (UI, chưa chạy trên máy thật)
Cài đặt trong `app/lib/presentation/`; Figma chỉ là tham chiếu luồng, giao diện thực tế có thể khác prototype.

```mermaid
flowchart TD
  Home["Home: nút KHẨN CẤP, chip mạng"] --> Triage["Sàng lọc (cây quyết định tĩnh)"]
  Home --> Handbook["Cẩm nang + tìm kiếm local"]
  Home --> CPR["CPR (mở thẳng phác đồ)"]
  Home --> Settings["Cài đặt: sáng/tối/hệ thống, cỡ chữ"]
  Triage --> Guide["Hướng dẫn từng bước + Đọc to"]
  Triage --> Call115["Gọi 115 ngay (mở trình quay số)"]
  Handbook --> Guide
  CPR --> Guide
  Guide --> Call115
```

| Màn hình | Nội dung chính | Trạng thái |
|---|---|---|
| Home | Nút KHẨN CẤP lớn (icon + chữ), chip mạng (icon + chữ), lối vào cẩm nang/CPR/cài đặt; "Mô tả tình huống" bị tắt vì AI chưa triển khai | Có test widget |
| Sàng lọc | Câu hỏi Có/Không lần lượt; nút "Gọi 115 ngay" ở mọi bước | Có test widget |
| Hướng dẫn từng bước | Một hành động mỗi bước, Đọc to (vi-VN), KHÔNG ĐƯỢC LÀM, nguồn + phiên bản + cảnh báo chưa thẩm định | Có test widget; TTS thật chưa kiểm chứng trên máy |
| Cẩm nang | Danh sách + tìm kiếm local không dấu | Có test widget |
| Cài đặt | Sáng/Tối/Hệ thống, cỡ chữ, lưu qua SharedPreferences | Có test widget; chưa kiểm chứng lưu qua khởi động lại trên máy |

Luồng SOS (Prompt 04): Home hoặc màn sàng lọc → "SOS: gửi vị trí" → màn giải thích quyền vị trí → lấy vị trí (hoặc bỏ qua) → xem trước vị trí và nội dung tin nhắn, ghi chú tùy chọn → "Xác nhận và mở tin nhắn" (mở ứng dụng SMS với nội dung soạn sẵn, người dùng tự bấm Gửi). Xử lý: từ chối quyền, từ chối vĩnh viễn (mở cài đặt ứng dụng), GPS tắt (mở cài đặt vị trí), hết thời gian chờ; luôn có "Gọi 115 ngay". Không bắt đăng nhập.

### Giới hạn của SOS (cần nêu khi trình bày)
- Tọa độ GPS lấy được khi không có Internet (cần máy thu nhìn thấy tín hiệu GPS; trong nhà hoặc lần định vị đầu có thể chậm hoặc hết thời gian chờ).
- Tile bản đồ và địa chỉ chữ cần Internet: app KHÔNG hiển thị bản đồ hay địa chỉ chữ. Liên kết bản đồ trong nội dung tin nhắn chỉ mở được khi người nhận có Internet; tọa độ số vẫn đọc được.
- Gọi 115 và nhắn tin cần sóng di động (SIM còn sóng). "Mất Internet" không đồng nghĩa "mất sóng": có thể gọi/nhắn được dù không có Internet, và ngược lại.
- App không tự gửi tin nhắn (không xin quyền SEND_SMS): chỉ mở ứng dụng tin nhắn với nội dung soạn sẵn, người nhận để trống, người dùng tự chọn và tự bấm Gửi.
- Chưa có nguồn xác nhận 115 nhận SMS nên không mặc định gửi tin tới 115; nút "Gọi 115 ngay" chỉ mở trình quay số.
- Chưa kiểm chứng trên điện thoại thật.

Nhóm chưa triển khai ở bước này: AI mô tả tình huống, bộ đếm nhịp CPR, màn bản đồ. [CHƯA CÓ BẰNG CHỨNG: video SOS trên máy thật: [CHỜ NGƯỜI DÙNG QUAY MÀN HÌNH].] [CHƯA CÓ BẰNG CHỨNG: ảnh chụp sáng/tối trên máy thật, xem docs/evidence/screenshots/emergency_ui.md.]

---

## 3. TECH STACK & INITIAL ARCHITECTURE
* **Framework:** Flutter 3.x (Dart 3) • **State Management:** Riverpod 2
* **Backend:** Supabase (BaaS) + FastAPI (AI orchestration) • **Local DB:** Drift (SQLite) • **AI Engine:** Streaming LLM API (Gemini) + RAG-lite
* **🔗 Figma Prototype URL:** https://www.figma.com/design/jOBAMpW4SDwM9r6R3aKDg3/FirstAid-%E2%80%93-Mobile-App-Prototype?node-id=0-1&t=MaVpZ0hz9emCILPi-1  
  [CHƯA CÓ BẰNG CHỨNG: quyền chia sẻ "Anyone with the link can view" chưa được kiểm tra.]

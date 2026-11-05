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

---

## 3. TECH STACK & INITIAL ARCHITECTURE
* **Framework:** Flutter 3.x (Dart 3) • **State Management:** Riverpod 2
* **Backend:** Supabase (BaaS) + FastAPI (AI orchestration) • **Local DB:** Drift (SQLite) • **AI Engine:** Streaming LLM API (Gemini) + RAG-lite
* **🔗 Figma Prototype URL:** https://www.figma.com/design/jOBAMpW4SDwM9r6R3aKDg3/FirstAid-%E2%80%93-Mobile-App-Prototype?node-id=0-1&t=MaVpZ0hz9emCILPi-1  
  [CHƯA CÓ BẰNG CHỨNG: quyền chia sẻ "Anyone with the link can view" chưa được kiểm tra.]

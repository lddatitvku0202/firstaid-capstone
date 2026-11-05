> Báo cáo bổ sung muộn, nộp gộp theo hướng dẫn của giảng viên; nội dung phản ánh trạng thái thực tế tại thời điểm viết.

# [REPORT 2] DETAILED ARCHITECTURE & CORE FEATURE IMPLEMENTATION
**Course:** Cross-Platform Mobile App Development  
**Project Title:** FirstAid  
**Team Name:** [CHƯA CÓ BẰNG CHỨNG: tên nhóm] • **Academic Term:** Semester 1 (2026 - 2027) • **Deadline:** Week 8

---

## 1. CLEAN ARCHITECTURE IMPLEMENTATION
* **Presentation Layer:** `app/lib/presentation/{screens,widgets,providers,theme,router}` — Material 3, go_router, màn Home rỗng với nút SOS (icon + chữ). Riverpod wiring ở `app/lib/core/di/providers.dart`.
* **Domain Layer:** `app/lib/domain/{entities,repositories,usecases}` — Dart thuần. Entity: FirstAidProtocol, ProtocolStep, TriageNode, EmergencyCase, SosMessage (+ 3 enum trạng thái nguồn). Use case: GetOfflineProtocols, GetProtocolByCode, StartEmergencyFlow, PrepareSosMessage.
* **Data Layer:** Drift/SQLite local datasource (`app/lib/data/datasources/local/`), seed loader từ asset JSON, parser `data/models/seed_parser.dart`, `DriftProtocolRepository`, `DriftEmergencyRepository`. [CHƯA CÓ BẰNG CHỨNG: Supabase datasource chưa triển khai.]

### Sơ đồ phụ thuộc
```mermaid
flowchart LR
  Presentation --> Domain
  Data --> Domain
  Core["core/di (composition root)"] --> Presentation
  Core --> Data
  Core --> Domain
```
Domain không import Presentation/Data/Flutter/Drift/Supabase/http/Riverpod; được kiểm bằng `app/test/architecture/domain_isolation_test.dart`.

### Cây thư mục (từ lệnh `find lib test -type f`, 2026-11-05)
```
lib/core/di/providers.dart
lib/core/utils/.gitkeep
lib/data/datasources/{local,remote}/.gitkeep
lib/data/models/.gitkeep
lib/data/repositories/in_memory_{emergency,protocol}_repository.dart
lib/domain/entities/{emergency_case,first_aid_protocol,protocol_step,sos_message,source_status,triage_node}.dart
lib/domain/repositories/{emergency,protocol}_repository.dart
lib/domain/usecases/{get_offline_protocols,get_protocol_by_code,prepare_sos_message,start_emergency_flow}.dart
lib/main.dart
lib/presentation/{providers/.gitkeep,router/app_router.dart,screens/home_screen.dart,theme/app_theme.dart,widgets/sos_button.dart}
test/architecture/domain_isolation_test.dart
test/widget_test.dart
```
Log kiểm tra: `docs/evidence/tests/skeleton-checks-20261105-224643.log` (pub get, format, analyze, test đều exit=0; 3 test pass).

### Dữ liệu phác đồ và lưu trữ cục bộ (Prompt 02)
- Nguồn nội dung: IFRC-2025 (`verified` trong `docs/source/medical/source_register.csv`); bản tóm lược/dịch tiếng Việt do nhóm thực hiện, `clinical_review = not_clinically_reviewed`. Nguồn Việt Nam (VN-MOH-636-2025, VN-BYT-MOET-TNTT-2022) CHƯA đối chiếu vì PDF không trích được text.
- Asset: `app/assets/protocols/protocols_v1.json` (6 phác đồ: bleeding_wounds_severe, burns_thermal_chemical, choking_adult_child, choking_baby, cpr_adult_adolescent, cpr_baby_child) và `app/assets/triage/triage_v1.json` (cây quyết định tĩnh, không phải AI).
- Drift schema v1: bảng `protocols`, `protocol_steps`, `triage_nodes`, `meta`. Seed ở lần chạy đầu và khi `data_version` đổi (hiện `1.0.0+1.0.0`). Dữ liệu y tế chỉ đọc với UI.
- UI hiển thị nguồn (source_id + trang), phiên bản và cảnh báo khi `clinical_review != reviewed`.
- Log kiểm tra: `docs/evidence/tests/drift-seed-checks-20261106-010345.log` (format, analyze "No issues found", 17 test pass; mọi lệnh exit=0).

---

## 2. DATABASE SCHEMA & SECURITY POLICIES
* [CHƯA CÓ BẰNG CHỨNG: ERD chưa được tạo.]
* [CHƯA CÓ BẰNG CHỨNG: chính sách RLS chưa được viết/kiểm thử.]

---

## 3. CORE FEATURE IMPLEMENTATION PROGRESS
* **🔗 GitHub Tag / Branch M2:** [CHƯA CÓ BẰNG CHỨNG: chưa có tag/branch]
* **🎥 Milestone 2 Video Demo (2–3 minutes):** [CHƯA CÓ BẰNG CHỨNG: chưa có video]

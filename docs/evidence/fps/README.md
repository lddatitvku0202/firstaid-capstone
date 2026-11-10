# Đo FPS / frame time trên máy thật (người dùng tự chạy)

Trạng thái: **[CHỜ SỐ ĐO THẬT]**. Chưa có số đo FPS nào. Không điền số từ emulator hay debug mode.
Ghi kết quả vào [fps-measurements.md](fps-measurements.md) và docs/evidence-ledger.md.

## Vì sao phải đo đúng cách
- Chỉ **profile mode** trên **điện thoại thật** cho số đại diện. Debug mode chậm hơn nhiều (JIT, assert); emulator dùng GPU giả lập.
- Ngân sách mỗi khung hình phụ thuộc tần số quét: 60 Hz → 16,7 ms; 90 Hz → 11,1 ms; 120 Hz → 8,3 ms. Ghi lại tần số quét của máy. Nếu muốn so với mục tiêu 60fps, đặt màn hình về 60 Hz (Cài đặt → Màn hình → Tần số làm mới) và ghi lại đã đặt như vậy.
- Đo mỗi kịch bản ít nhất 3 lần, ghi cả 3; không chọn lần đẹp nhất.

## Chuẩn bị
1. Cắm điện thoại, bật USB debugging (xem [../android-device-run.md](../android-device-run.md)). Sạc pin > 50%, tắt chế độ tiết kiệm pin, đóng app khác.
2. PowerShell:

```powershell
cd "D:\Start Github\firstaid-capstone\app"
flutter devices          # lấy <ID>
adb shell getprop ro.product.model
adb shell getprop ro.build.version.release
adb shell dumpsys display | Select-String "refreshRate" | Select-Object -First 3
```

Ghi model, phiên bản Android, tần số quét vào bảng.

## Cách A (khuyến nghị, lặp lại được): perf test tự động
Kịch bản có sẵn trong `app/integration_test/perf_test.dart` (giao diện Sáng và Tối):
- `guide_steps_*`: hướng dẫn CPR, bấm Tiếp 6 lần rồi Trước 6 lần.
- `handbook_search_scroll_*`: Cẩm nang, gõ tìm "bong", xóa, cuộn lên xuống 3 lần.
- `triage_flow_*`: KHẨN CẤP → 3 câu trả lời → kết quả CPR.

```powershell
flutter drive --profile --no-dds -d <ID> --driver=test_driver/perf_driver.dart --target=integration_test/perf_test.dart *> "..\docs\evidence\fps\perf-drive-<YYYYMMDD-HHMMSS>.log"
```

- `--no-dds` là bắt buộc (nếu thiếu sẽ lỗi "Failed to connect to VM Service").
- Kết quả nằm ở `app/build/<tên kịch bản>.json` (6 file). Sao chép chúng vào `docs/evidence/fps/<ngày>/`.
- Trong mỗi JSON, chép **nguyên văn** các trường sau vào bảng:
  - `frame_count`
  - `average_frame_build_time_millis`, `90th_percentile_frame_build_time_millis`, `worst_frame_build_time_millis`, `missed_frame_build_budget_count`
  - `average_frame_rasterizer_time_millis`, `90th_percentile_frame_rasterizer_time_millis`, `worst_frame_rasterizer_time_millis`, `missed_frame_rasterizer_budget_count`
- Số frame jank = số frame vượt ngân sách. Ghi riêng build và raster như JSON báo, không tự cộng nếu không chắc hai tập có trùng frame hay không.
- Lưu ý: "missed budget" đếm frame vượt **16 ms cố định** (`kBuildBudget` trong `flutter_test/lib/src/frame_timing_summarizer.dart` của Flutter 3.47.6, có TODO tự tính theo tần số quét), không theo tần số quét của máy. Trên máy 90/120 Hz, frame dưới 16 ms vẫn có thể trễ so với ngân sách thật; khi đó dùng `frame_build_times`/`frame_rasterizer_times` trong JSON hoặc DevTools để đánh giá, và ghi rõ trong bảng.

## Cách B: DevTools Performance (thao tác tay, để có ảnh chụp)
1. `flutter run --profile -d <ID>` (thêm `--dart-define-from-file=.env` nếu cần AI). Chờ dòng "The Flutter DevTools debugger and profiler ... is available at: http://127.0.0.1:...". Mở link đó.
2. Mở tab **Performance**. Biểu đồ "Flutter frames" có mỗi cột là một frame: phần build (UI thread) và raster. Cột vượt ngân sách bị tô đỏ, đó là jank.
3. Bấm **Clear**, rồi trên điện thoại thực hiện kịch bản (danh sách bên dưới). Mỗi kịch bản khoảng 10–20 giây.
4. Ghi số frame, số frame tô đỏ (jank), và FPS trung bình **nếu phiên bản DevTools hiển thị**. Nếu không hiển thị, ghi "DevTools không hiển thị", không tự tính. Chụp màn hình biểu đồ, lưu `docs/evidence/fps/<kịch-bản>-<theme>-<ngày>.png`.
5. Có thể bật thêm overlay hiệu năng trên máy: khi đang `flutter run`, bấm phím `P`. Chụp ảnh nếu cần.

Kịch bản thao tác tay (làm cả Sáng và Tối):
- K1 Home → KHẨN CẤP → trả lời tới kết quả → "Xem hướng dẫn từng bước" → Tiếp/Trước nhiều lần.
- K2 Cẩm nang: gõ tìm kiếm từng ký tự, cuộn nhanh danh sách.
- K3 Cài đặt: kéo thanh cỡ chữ qua lại, đổi Sáng/Tối.
- K4 Mô tả tình huống khi bật chế độ máy bay → thẻ fallback → sàng lọc.
- K5 (nếu có backend) Mô tả tình huống online → chờ tiến trình streaming → kết quả.

## Sau khi đo
- Điền [fps-measurements.md](fps-measurements.md): mỗi lần đo một dòng, kèm đường dẫn log/JSON/ảnh.
- Thêm một dòng vào docs/evidence-ledger.md (ngày đo thật).
- Trong R3/R4, thay "[CHỜ SỐ ĐO THẬT]" bằng số đã ghi, kèm đường dẫn.

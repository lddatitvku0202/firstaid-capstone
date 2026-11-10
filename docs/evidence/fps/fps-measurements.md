# Số đo FPS / frame time (máy thật, profile mode)

**[CHỜ SỐ ĐO THẬT]**: chưa có số nào. Người dùng điền sau khi chạy theo [README.md](README.md). Không điền số từ emulator, debug mode, hay ước lượng.

## Thiết bị
| ID | Model | Android | Tần số quét đang đặt | Ngày đo | Ghi chú (pin, nhiệt, chế độ tiết kiệm pin) |
|---|---|---|---|---|---|
| D1 | [CHỜ SỐ ĐO THẬT] | | | | |

## Cách A: perf test tự động (`flutter drive --profile --no-dds`)
Chép nguyên văn từ `build/<kịch bản>.json`. Lần = 1, 2, 3.

| Thiết bị | Kịch bản (reportKey) | Lần | frame_count | build avg / p90 / worst (ms) | missed build budget | raster avg / p90 / worst (ms) | missed raster budget | File JSON / log |
|---|---|---|---|---|---|---|---|---|
| D1 | guide_steps_light | 1 | [CHỜ SỐ ĐO THẬT] | | | | | |
| D1 | guide_steps_dark | 1 | [CHỜ SỐ ĐO THẬT] | | | | | |
| D1 | handbook_search_scroll_light | 1 | [CHỜ SỐ ĐO THẬT] | | | | | |
| D1 | handbook_search_scroll_dark | 1 | [CHỜ SỐ ĐO THẬT] | | | | | |
| D1 | triage_flow_light | 1 | [CHỜ SỐ ĐO THẬT] | | | | | |
| D1 | triage_flow_dark | 1 | [CHỜ SỐ ĐO THẬT] | | | | | |

## Cách B: DevTools Performance (thao tác tay)
| Thiết bị | Màn hình / kịch bản | Theme | Số frame | Frame jank (tô đỏ) | FPS trung bình (nếu DevTools hiển thị) | Ảnh chụp |
|---|---|---|---|---|---|---|
| D1 | K1 Sàng lọc → hướng dẫn từng bước | Sáng | [CHỜ SỐ ĐO THẬT] | | | |
| D1 | K1 Sàng lọc → hướng dẫn từng bước | Tối | [CHỜ SỐ ĐO THẬT] | | | |
| D1 | K2 Cẩm nang: tìm + cuộn | Sáng | [CHỜ SỐ ĐO THẬT] | | | |
| D1 | K2 Cẩm nang: tìm + cuộn | Tối | [CHỜ SỐ ĐO THẬT] | | | |
| D1 | K3 Cài đặt: kéo cỡ chữ, đổi theme | Sáng | [CHỜ SỐ ĐO THẬT] | | | |
| D1 | K4 Mô tả tình huống offline → fallback | Sáng | [CHỜ SỐ ĐO THẬT] | | | |
| D1 | K5 Mô tả tình huống online (streaming) | Sáng | [CHỜ SỐ ĐO THẬT] | | | |

## Kết luận
[CHỜ SỐ ĐO THẬT]. Chỉ viết kết luận (vd "đạt 60fps ở kịch bản X") khi số trong bảng cho thấy điều đó, và nêu rõ thiết bị cùng tần số quét.

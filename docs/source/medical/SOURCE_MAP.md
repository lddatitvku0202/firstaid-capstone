# Bản đồ nguồn y khoa FirstAid (đã mở và đối chiếu 6 file)

Ngày kiểm tra: 2026-11-05. Phương pháp: đọc trang bìa, trang bản quyền, mục lục; tìm từ khóa theo từng trang; xem ảnh một trang của file 636. Số trang là CHỈ SỐ TRANG PDF trừ khi ghi "trang in".

## 1. Đính chính so với báo cáo tìm kiếm trước
- Tài liệu trẻ em/học sinh: bìa ghi cả **Bộ Y tế (Bệnh viện Nhi Trung ương)** và **Bộ GDĐT (Vụ Giáo dục thể chất)**, năm 2022. Tôi đã ghi sai khi nói "chỉ Bộ GDĐT".
- Quyết định 636/QĐ-BYT đã xác nhận: ký **21/02/2025**, ban hành "Tài liệu huấn luyện sơ cứu, cấp cứu tại nơi làm việc".
- File IFRC 2016 bạn tải là **bản tiếng Anh**, không phải bản dịch tiếng Việt.
- Hội Chữ thập đỏ Việt Nam: vẫn chưa có tài liệu riêng. IFRC là tổ chức quốc tế của phong trào Chữ thập đỏ. Báo cáo nên ghi "IFRC", không ghi "Hội Chữ thập đỏ Việt Nam".

## 2. Nguồn nên dùng làm chính
| Vai trò | Nguồn | Lý do |
|---|---|---|
| Chính (tiếng Việt, chính thức) | VN-MOH-636-2025 | Mới nhất (2025), do Bộ Y tế ban hành, có bác sĩ và Trung tâm cấp cứu 115 Hà Nội trong ban soạn |
| Chính (quốc tế, đủ 4 chủ đề) | IFRC-2025 | Mới nhất, có cả hóc dị vật người lớn, trẻ em, em bé |
| Chính cho trẻ em | VN-BYT-MOET-TNTT-2022 | Có hóc dị vật trẻ em, Heimlich, chảy máu, bỏng ở trẻ |
| Phụ | VN-MOH-QLKCB-TNGT-2013 | Chỉ cho an toàn hiện trường và gọi hỗ trợ. Cũ |
| Lưu trữ, không trích cho phác đồ | IFRC-2020, IFRC-2016-EN | Đã bị bản 2025 thay thế |

## 3. Chủ đề MVP và vị trí
| Chủ đề | IFRC 2025 | VN 636 (2025) | BV Nhi TW/Bộ GDĐT (2022) |
|---|---|---|---|
| Gọi 115 | p114 (General approach) | p10 | p9 |
| CPR người lớn | p158-185 (nhịp 100-120 ở p162) | p24-29 (nhịp ở p25-26) | p18-26 (nhịp p25, cho mọi lứa tuổi) |
| CPR trẻ em, em bé | p186-195 (p187-188) | chưa kiểm tra | p25, p108 |
| Chảy máu | p256-266 (Severe bleeding) | p35-41 | p38-56 (Bài 4) |
| Bỏng | p288-298 | ~p70-75 (cần kiểm tra) | p84-90 (Bài 8) |
| Hóc dị vật | p238-244 (Choking) | KHÔNG có mục riêng | p58-66 (Bài 5, chỉ trẻ em; Heimlich p61, p66) |

Hóc dị vật người lớn chỉ có ở IFRC 2025. Nếu muốn nguồn tiếng Việt cho mục này thì cần thêm tài liệu khác.

## 4. Xung đột và lưu ý
1. **Nhịp ép tim:** IFRC 2025, 636 (2025) và BV Nhi TW (2022) đều ghi **100-120 lần/phút**. Tài liệu TNGT 2013 ghi "ít nhất 100". Dùng 100-120. Tôi đã xem ảnh trang 636 (trang in 18) xác nhận "Tần số: 100-120 lần/phút", sâu "ít nhất 5 cm (tốt nhất 5-6 cm)".
2. **Bản 636 là bản quét có watermark ThuVienPhapLuat**, OCR sai nhiều chữ. Phải xem ảnh trang trước khi trích. Không phải file tải từ trang gốc của Bộ.
3. **"verified" ở đây nghĩa là:** bìa và front matter xác nhận cơ quan, năm, số hiệu. Chưa xác minh bản sao này khớp bản gốc trên trang của cơ quan ban hành.
4. **Bản quyền:** ba file IFRC cho phép sao chép phi thương mại và nêu nguồn. Các file Việt Nam không thấy điều khoản riêng (đặt `unknown`). Dự án học thuật, không thương mại, chỉ tóm lược có trích dẫn. Không commit PDF lên repo Public.
5. **Chưa có ai rà soát chuyên môn phần tóm lược của nhóm.** Nguồn do bác sĩ biên soạn không đồng nghĩa phần nhóm diễn đạt lại đã được thẩm định. Giữ `clinical_review = not_clinically_reviewed` và hiện cảnh báo trong app.
6. Giảng viên không bắt buộc bộ dữ liệu cụ thể, nên nhóm tự chọn nguồn như bảng mục 2.

## 5. Đề xuất cho Prompt 02
- Chủ đề: bleeding_wounds, burns, choking, cardiac_arrest_cpr.
- Mỗi bước phải có citation (source_id + trang PDF).
- Hóc dị vật: tách rõ người lớn (IFRC 2025) và trẻ em (BV Nhi TW 2022). Hai tài liệu có thể khác chi tiết kỹ thuật; để Claude Code ghi lại điểm khác thay vì tự chọn.
- Nhịp ép tim 100-120 trích từ IFRC 2025 p162 và 636 p26.

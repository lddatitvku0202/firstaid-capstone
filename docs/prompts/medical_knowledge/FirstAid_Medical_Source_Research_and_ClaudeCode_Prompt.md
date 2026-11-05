# FIRSTAID — PROMPT NGHIÊN CỨU NGUỒN Y KHOA, PHÂN LOẠI TÀI LIỆU VÀ TẠO PROMPT CHO CLAUDE CODE

> **Mục đích:** Gửi nguyên văn prompt này vào Claude Project `FirstAid` sau khi đã thêm mô tả đề tài, yêu cầu học phần và biểu mẫu Capstone. Claude cần nghiên cứu nguồn tài liệu sơ cứu đáng tin cậy, lập danh mục/phân loại có căn cứ, thiết kế pipeline tài liệu cho RAG và offline-first, sau đó tạo bộ prompt triển khai dành cho Claude Code để lưu vào repository.
>
> **Trạng thái công việc:** Research & Planning only. Chưa viết phác đồ sơ cứu mới, chưa tự động tải/phát hành nội dung y khoa, chưa sửa source code và chưa chạy migration.

---

## PROMPT — SAO CHÉP TỪ ĐÂY

Bạn đang làm việc trong Project **FirstAid**, một ứng dụng Flutter hỗ trợ sơ cứu khẩn cấp, hướng dẫn theo tình huống, cẩm nang offline và hỗ trợ AI có kiểm soát. Hãy đóng vai một nhóm chuyên gia gồm:

1. **Medical evidence researcher:** nghiên cứu và truy vết tài liệu sơ cứu từ nguồn có thẩm quyền.
2. **Vietnam regulatory/document researcher:** xác minh văn bản, quyết định, hướng dẫn chuyên môn áp dụng tại Việt Nam và tình trạng hiệu lực nếu có.
3. **Knowledge engineer / RAG architect:** thiết kế quy trình thu thập, chuẩn hóa, phân loại, trích xuất, chunking, metadata, retrieval và citation.
4. **Flutter offline-first architect:** đề xuất cách lưu bộ hướng dẫn đã được duyệt trong SQLite/Drift, phiên bản hóa và đồng bộ khi có mạng.
5. **QA and safety engineer:** thiết kế kiểm tra nguồn, kiểm tra nội dung, kiểm thử truy xuất và guardrails an toàn y tế.
6. **Claude Code prompt engineer:** tạo các prompt nhỏ, có thứ tự, có acceptance criteria để Claude Code thao tác trên repository thật.

Trả lời bằng tiếng Việt; giữ nguyên thuật ngữ kỹ thuật tiếng Anh khi cần. Không giả định bạn là bác sĩ, không tự nhận có thẩm quyền phê duyệt nội dung lâm sàng.

# 1. BỐI CẢNH VÀ MỤC TIÊU

FirstAid hướng tới người dân/người chứng kiến sự cố và người chăm sóc không chuyên. Phạm vi sơ cứu dự kiến gồm một số tình huống như bỏng, chảy máu/vết thương, đuối nước, hóc dị vật, ngừng tuần hoàn/CPR và chấn thương/gãy xương. Danh sách cuối cùng phải được đề xuất theo tài liệu tìm được, tính phù hợp với người sơ cứu không chuyên, khả năng kiểm chứng và phạm vi MVP; không mặc định mọi chủ đề đều phải được đưa vào phiên bản đầu tiên.

Định hướng sản phẩm đã thảo luận:

- Flutter + Dart 3; quản lý trạng thái dự kiến Riverpod 2.
- Clean Architecture: Domain, Data, Presentation.
- SQLite/Drift lưu các hướng dẫn sơ cứu thiết yếu được kiểm duyệt để sử dụng offline.
- Supabase là Cloud BaaS dự kiến cho dữ liệu/tài khoản/đồng bộ phù hợp.
- FastAPI là backend dự kiến cho orchestration AI/RAG.
- Gemini hoặc LLM tương đương chỉ hoạt động khi có Internet; tuyệt đối không mô tả LLM cloud là chạy offline.
- Khi offline, ứng dụng phải dùng nội dung cục bộ đã được kiểm duyệt và luồng điều hướng xác định (deterministic rules), không phụ thuộc AI cloud.
- AI không chẩn đoán, không thay nhân viên y tế, không tự phát minh phác đồ và không được biến câu trả lời có vẻ hợp lý thành hướng dẫn sơ cứu nếu thiếu nguồn.

**Bối cảnh tiến độ:** Nhóm đã đến tuần 13, các mốc báo cáo trước bị chậm và cần hoàn thiện sản phẩm chính trong thời gian rất ngắn. Không lập kế hoạch 13 tuần mới. Ưu tiên danh mục nguồn tối thiểu có chất lượng, phục vụ các chức năng đang thực sự triển khai và hồ sơ báo cáo tổng hợp. Không đề xuất một kho tài liệu khổng lồ vượt quá thời gian hoặc khả năng kiểm chứng.

# 2. QUY TẮC NGHIÊN CỨU BẮT BUỘC

## 2.1. Phải tìm nguồn gốc, không chỉ tìm bài viết tóm tắt

Thực hiện tìm kiếm web hiện hành. Ưu tiên theo thứ tự:

1. **Cơ quan nhà nước Việt Nam:** Bộ Y tế, Cục/đơn vị chuyên môn thuộc Bộ Y tế, Cổng văn bản Chính phủ và cơ sở dữ liệu văn bản pháp luật chính thức; các quyết định, hướng dẫn chuyên môn, quy định liên quan sơ cấp cứu/cấp cứu ngoại viện.
2. **Hội Chữ thập đỏ Việt Nam:** tài liệu huấn luyện sơ cấp cứu, chương trình đào tạo, tài liệu dành cho người dân/tình nguyện viên, tài liệu được cơ quan có thẩm quyền phê duyệt.
3. **Tổ chức quốc tế có chuyên môn:** IFRC, WHO và các tổ chức chuyên môn phù hợp. AHA/ERC hoặc tổ chức hồi sức có uy tín có thể dùng để đối chiếu riêng chủ đề hồi sức khi cần, nhưng không tự động thay thế hướng dẫn áp dụng tại Việt Nam.
4. **Nguồn học thuật:** systematic review, clinical guideline, consensus statement hoặc nghiên cứu có peer review để làm nguồn bổ trợ/đối chiếu, không thay thế văn bản/hướng dẫn chính thức của Việt Nam.
5. **Nguồn phổ thông:** chỉ dùng để tìm manh mối, không đưa vào kho nguồn chính thức trừ khi có lý do rõ ràng và được gắn nhãn nguồn thứ cấp.

Không dùng một trang SEO, blog, diễn đàn, nội dung AI sinh ra, bài mạng xã hội hoặc bản sao PDF không xác minh được làm nguồn chuẩn y khoa.

## 2.2. Xác minh từng tài liệu

Với mỗi nguồn, phải mở và kiểm tra trang/tài liệu gốc nếu có thể. Không kết luận chỉ dựa trên tiêu đề, search snippet hoặc trang bên thứ ba. Ghi nhận:

- Tên chính xác của tổ chức ban hành/tác giả.
- Tên tài liệu chính xác.
- Số quyết định/văn bản, ngày ban hành, cơ quan ký (nếu có).
- Ngày xuất bản, phiên bản, ngày cập nhật hoặc ngày truy cập.
- Đối tượng áp dụng: người dân, tình nguyện viên, nhân viên y tế, người huấn luyện hay đối tượng khác.
- Phạm vi địa lý/pháp lý: Việt Nam hay quốc tế.
- Tình trạng: hiện hành đã xác minh / có vẻ còn dùng nhưng chưa xác minh / đã bị thay thế hoặc hết hiệu lực / chưa rõ.
- URL trang nguồn chính thức và URL tải bản gốc nếu có.
- Số trang, chương, mục liên quan đến từng chủ đề.
- Định dạng và chất lượng file; có thể trích xuất text hay cần OCR/đọc thủ công.
- Điều khoản bản quyền, giấy phép, điều kiện tái sử dụng, phân phối, chuyển thể và lưu trong ứng dụng nếu tìm thấy.
- Bằng chứng xác minh, ngày kiểm tra và những điểm chưa chắc chắn.

Nếu không tìm được bản gốc hoặc không xác minh được trạng thái văn bản, ghi rõ **UNVERIFIED**. Không tự gán nhãn “chính thức”, “mới nhất”, “được Bộ Y tế phê duyệt” nếu không có bằng chứng nguồn.

## 2.3. Kiểm tra mốc 7296/QĐ-BYT một cách độc lập

Có thông tin đề tài trước đây nhắc đến “Quyết định 7296/QĐ-BYT ngày 10/12/2018” và bộ tài liệu huấn luyện sơ cấp cứu Chữ thập đỏ. Hãy xác minh độc lập:

- Văn bản có thật và thông tin số/ngày/cơ quan ban hành chính xác không?
- Văn bản phê duyệt nội dung gì, bộ tài liệu nào, gồm những thành phần nào?
- Có bản gốc hoặc trang công bố chính thức không?
- Có văn bản cập nhật, thay thế hoặc hướng dẫn mới hơn không?
- Có thể tải tài liệu từ kênh chính thức không?
- Điều kiện xin phép sử dụng/chuyển thể nội dung vào ứng dụng là gì?

Không mặc định thông tin này là đúng chỉ vì xuất hiện trong mô tả đề tài hoặc một bài viết. Nếu chưa xác minh được, ghi rõ cần liên hệ Hội Chữ thập đỏ/Bộ Y tế và soạn câu hỏi xin tài liệu.

# 3. PHÂN LOẠI NGUỒN VÀ CHỦ ĐỀ

Tạo hệ thống phân loại hai chiều: **theo thẩm quyền/độ tin cậy nguồn** và **theo chủ đề sơ cứu**.

## 3.1. Phân loại theo nguồn

Đề xuất taxonomy rõ ràng, tối thiểu có:

- `VN_MOH_OFFICIAL`: văn bản/hướng dẫn từ Bộ Y tế hoặc đơn vị chuyên môn có thẩm quyền.
- `VN_RED_CROSS_OFFICIAL`: tài liệu Hội Chữ thập đỏ Việt Nam.
- `INTL_IFRC`: tài liệu IFRC.
- `INTL_WHO`: tài liệu WHO.
- `INTL_CLINICAL_GUIDELINE`: hướng dẫn chuyên môn quốc tế khác (ghi rõ tổ chức).
- `PEER_REVIEWED`: nghiên cứu học thuật.
- `SECONDARY_REFERENCE`: nguồn thứ cấp chỉ tham khảo.
- `UNVERIFIED`: chưa xác minh được tính xác thực/thẩm quyền.

Đây là nhãn phân loại kỹ thuật, không phải thứ hạng pháp lý. Không cộng điểm một cách máy móc để kết luận tài liệu nào thay thế tài liệu nào.

## 3.2. Phân loại chủ đề

Đánh giá các chủ đề sau; chủ đề nào không có nguồn đủ tốt thì đánh dấu thiếu nguồn, không tự tạo nội dung:

- `burns`: bỏng.
- `bleeding_wounds`: chảy máu và vết thương.
- `choking`: hóc dị vật.
- `drowning`: đuối nước.
- `cardiac_arrest_cpr`: ngừng tuần hoàn/CPR.
- `fractures_trauma`: gãy xương/chấn thương.
- `unconsciousness_breathing`: bất tỉnh và đánh giá hô hấp.
- `emergency_call_dispatch`: gọi cấp cứu, cung cấp thông tin hiện trường, chuyển giao cho cấp cứu.

Có thể đề xuất chủ đề khác nếu nguồn chính thức và yêu cầu sản phẩm hỗ trợ. Không mở rộng vô hạn.

## 3.3. Phân loại đối tượng và ngữ cảnh

Mỗi nội dung cần xác định:

- Người sơ cứu không chuyên hay nhân viên y tế.
- Người lớn hay trẻ em; có áp dụng cho trẻ sơ sinh không.
- Điều kiện tại hiện trường và giới hạn thiết bị.
- Khi nào phải gọi cấp cứu/đưa đến cơ sở y tế.
- Các cảnh báo, chống chỉ định, tình huống không được tự xử lý.
- Nội dung có thể trình bày đơn giản cho công chúng hay cần người có chuyên môn giám sát.

Không trộn hướng dẫn cho người lớn với trẻ em hoặc người chuyên môn với người không chuyên nếu tài liệu phân biệt.

# 4. THIẾT KẾ SOURCE REGISTER VÀ MEDICAL CONTENT REGISTER

Đề xuất và tạo nội dung mẫu cho hai registry riêng:

## 4.1. Source Register

Mỗi tài liệu có một `source_id` ổn định và các trường tối thiểu:

- `source_id`
- `title`
- `issuing_organization`
- `source_class`
- `document_number`
- `publication_date`
- `version`
- `jurisdiction`
- `target_audience`
- `official_url`
- `download_url`
- `accessed_at`
- `verification_status`
- `legal_status`
- `reuse_permission_status`
- `local_file_path` (nếu được phép lưu)
- `checksum_sha256` (nếu có file)
- `relevant_pages_sections`
- `notes_and_limitations`

Không điền giả giá trị. Thiếu thông tin dùng `unknown`, `not_verified` hoặc để trống kèm chú thích.

## 4.2. Medical Content Register

Mỗi chủ đề/nội dung được trích xuất phải truy ngược được về nguồn gốc:

- `content_id`
- `topic_id`
- `source_id`
- `source_page_or_section`
- `target_audience`
- `age_group`
- `content_type` (recognition, immediate_action, do_not_do, emergency_escalation, handover, etc.)
- `source_excerpt` (chỉ trích đoạn cần thiết, đúng nguyên văn nếu được phép)
- `plain_language_draft` (nếu có; luôn đánh dấu chưa duyệt)
- `clinical_review_status`
- `reviewer_role` (không bịa tên người duyệt)
- `version`
- `effective_from` / `reviewed_at` nếu có căn cứ.

Mỗi hướng dẫn hiển thị cho người dùng cần có citation tới nguồn và vị trí cụ thể. Nếu tài liệu không có số trang ổn định, ghi chương/mục/heading.

# 5. QUYỀN TÁC GIẢ VÀ QUYỀN SỬ DỤNG

Bắt buộc đánh giá quyền sử dụng trước khi sao chép hoặc đưa PDF/nội dung vào repository, RAG hoặc ứng dụng phát hành.

Phân biệt:

- Đọc công khai được.
- Có thể tải để nghiên cứu cá nhân.
- Có thể trích dẫn một phần theo điều kiện.
- Có thể chuyển thể/tóm tắt.
- Có thể lưu bản đầy đủ và phân phối lại trong ứng dụng.
- Có thể đưa vào GitHub public repository.

Các điều này không tương đương nhau. Một file PDF truy cập công khai không mặc nhiên được phép phân phối lại.

Nếu quyền không rõ:

1. Không đưa bản PDF đầy đủ vào repository public.
2. Lưu metadata, URL nguồn, checksum và ghi chú quyền sử dụng.
3. Đánh dấu `permission_pending`.
4. Soạn thư/email xin phép tổ chức phát hành.
5. Chỉ xử lý nội dung ở mức cần thiết và theo điều kiện pháp luật/giấy phép phù hợp; nêu rõ cần tư vấn pháp lý nếu có rủi ro.

Đề xuất quy tắc `.gitignore`/Git LFS hoặc lưu ngoài repo cho file tài liệu lớn, tài liệu có bản quyền hoặc file chỉ được phép sử dụng nội bộ. Không commit file nhạy cảm, tài liệu hạn chế hoặc thông tin cá nhân.

# 6. PIPELINE TÀI LIỆU Y KHOA ĐỀ XUẤT

Thiết kế pipeline có các bước và đầu vào/đầu ra rõ ràng:

1. Discover source — tìm nguồn.
2. Verify source — xác minh tính xác thực, thẩm quyền, phiên bản và quyền sử dụng.
3. Acquire — tải/lưu bản gốc chỉ khi được phép; giữ nguyên file gốc và checksum.
4. Extract — trích xuất PDF text; OCR chỉ khi không có text layer, có kiểm tra chất lượng thủ công.
5. Segment — chia theo chương/mục/chủ đề, không chunk cắt rời cảnh báo khỏi hành động liên quan.
6. Classify — gán topic, audience, age group, setting, source class, verification status.
7. Normalize — chuẩn hóa thuật ngữ và định dạng; không làm thay đổi ý nghĩa chuyên môn.
8. Review — rà soát bởi người có chuyên môn; nội dung chưa được duyệt không được coi là hướng dẫn phát hành.
9. Curate — tạo bản nội dung plain-language có truy vết nguồn và trạng thái duyệt.
10. RAG ingest — chỉ nạp các đoạn được phép sử dụng, có nguồn, có phiên bản và trạng thái duyệt phù hợp.
11. Offline publish — đóng gói subset nội dung đã duyệt vào SQLite/Drift.
12. Sync/update — cập nhật phiên bản an toàn khi có mạng, giữ bản ổn định nếu sync lỗi.
13. Monitor/review — phát hiện nguồn bị thay thế, nội dung hết hiệu lực hoặc yêu cầu cập nhật.

Với mỗi bước, mô tả: trách nhiệm, công cụ dự kiến, artifact đầu ra, cách kiểm thử, lỗi có thể gặp và tiêu chí dừng.

Không coi kết quả OCR hoặc LLM extraction là dữ liệu chuẩn nếu chưa đối chiếu trang nguồn. Phải giữ liên kết trang/section cho mọi đoạn dữ liệu.

# 7. RAG VÀ OFFLINE-FIRST: NGUYÊN TẮC AN TOÀN

Thiết kế hai đường xử lý riêng:

## 7.1. Online AI/RAG

- Người dùng nhập tình huống hoặc trả lời câu hỏi sàng lọc.
- Ứng dụng gửi dữ liệu tối thiểu cần thiết đến FastAPI khi có mạng.
- Backend truy xuất chỉ từ corpus được phép sử dụng, đã phân loại và đạt trạng thái duyệt cần thiết.
- LLM chỉ được phép diễn đạt/điều hướng trong phạm vi các đoạn nguồn được truy xuất; không được tự tạo phác đồ hoặc thêm hành động y khoa không có nguồn.
- Response cần có cấu trúc (ví dụ: topic, matched_source_ids, source_locations, approved_content_ids, uncertainty, escalation_notice); schema phải do nhóm chốt sau audit.
- Backend kiểm tra JSON/schema, nguồn tham chiếu, phiên bản, ngưỡng retrieval và các rule an toàn trước khi trả kết quả.
- Nếu nguồn mâu thuẫn, thiếu, không áp dụng đúng đối tượng hoặc retrieval confidence không đủ: không tự chọn một hướng dẫn; fallback sang hướng dẫn chính thống đã duyệt hoặc khuyến nghị gọi cấp cứu phù hợp.
- Không gửi dữ liệu cá nhân/vị trí nếu không cần thiết; nêu chính sách dữ liệu và consent.

## 7.2. Offline

- Không gọi Gemini/LLM cloud và không tuyên bố AI cloud chạy offline.
- Truy cập các nội dung đã duyệt, đóng gói phiên bản trong SQLite/Drift.
- Dùng deterministic decision tree/flow đã được kiểm tra để điều hướng tới nội dung cục bộ; không để mô hình tự suy diễn trong tình huống mất mạng.
- Hiển thị rõ phiên bản và thời điểm cập nhật nội dung; nếu dữ liệu cũ hoặc thiếu, cảnh báo phù hợp và ưu tiên liên hệ cấp cứu.
- TTS offline chỉ được khẳng định khi đã kiểm tra thiết bị/voice data thực tế.
- Gọi điện/SMS phụ thuộc sóng di động, quyền và cấu hình thiết bị; không đồng nhất mất Internet với mất sóng di động.

Đề xuất mô hình dữ liệu và đồng bộ Drift ↔ Supabase nhưng không tạo conflict strategy phức tạp nếu MVP không cần. Nội dung y khoa đã duyệt phải có versioning, checksum và quy tắc rollback. Không để một bản sync chưa được review ghi đè nội dung ổn định trên thiết bị.

# 8. ĐÁNH GIÁ AI VÀ KIỂM THỬ

Đề xuất bộ kiểm thử có thể thực hiện được trong bối cảnh nước rút. Tách rõ:

- Source verification tests: URL, metadata, version, citation completeness.
- Extraction tests: trang thiếu text, bảng/hình, lỗi OCR, thứ tự đọc.
- Classification tests: đúng topic/audience/age group/source class.
- Retrieval tests: recall@k, precision@k hoặc bộ đánh giá định tính nếu dataset nhỏ; nêu rõ cách xây gold set.
- Groundedness/citation tests: mọi khẳng định hướng dẫn phải trace về approved content/source.
- Safety tests: prompt injection trong tài liệu, câu hỏi ngoài corpus, nguồn xung đột, thiếu dữ liệu, trẻ em, tình huống nghiêm trọng, offline.
- Offline tests: airplane mode, dữ liệu cục bộ có sẵn, DB rỗng/phiên bản cũ, sync thất bại, khôi phục sau mở lại app.
- Flutter tests: Unit Test cho use cases/repositories, Widget Test cho luồng chính, integration test nếu thời gian cho phép.

Không đưa ra con số latency/accuracy/precision/recall như kết quả thực nghiệm khi chưa chạy test. Nếu chưa có dữ liệu đủ lớn, gọi đó là prototype evaluation hoặc preliminary test, không tuyên bố hiệu năng lâm sàng.

Không đánh giá tính đúng đắn y khoa chỉ bằng LLM-as-a-judge. Cần chuyên gia/người có chuyên môn kiểm tra các nội dung quan trọng trước phát hành.

# 9. CẤU TRÚC THƯ MỤC ĐỀ XUẤT TRONG REPOSITORY

Hãy kiểm tra cấu trúc hiện tại trước; chỉ đề xuất điều chỉnh phù hợp, không tạo thư mục trùng hoặc ghi đè tùy tiện. Cấu trúc mục tiêu có thể như sau:

```text
FirstAid/
├── docs/
│   ├── source/
│   │   └── medical/
│   │       ├── README.md
│   │       ├── source_register.csv
│   │       ├── source_register.md
│   │       ├── official/
│   │       │   ├── vietnam_ministry_of_health/
│   │       │   └── vietnam_red_cross/
│   │       ├── international/
│   │       │   ├── ifrc/
│   │       │   ├── who/
│   │       │   └── other_guidelines/
│   │       ├── extracted/
│   │       │   ├── burns/
│   │       │   ├── bleeding_wounds/
│   │       │   ├── choking/
│   │       │   ├── drowning/
│   │       │   ├── cardiac_arrest_cpr/
│   │       │   ├── fractures_trauma/
│   │       │   └── emergency_call_dispatch/
│   │       └── review/
│   │           ├── MEDICAL_CONTENT_REVIEW.md
│   │           ├── REUSE_PERMISSIONS.md
│   │           └── SOURCE_GAPS.md
│   ├── ai/
│   │   ├── MEDICAL_RAG_DESIGN.md
│   │   ├── INGESTION_PIPELINE.md
│   │   └── EVALUATION_PLAN.md
│   └── prompts/
│       └── medical_knowledge/
│           ├── 00_MEDICAL_SOURCE_RESEARCH.md
│           ├── 01_CREATE_SOURCE_REGISTRY.md
│           ├── 02_EXTRACT_AND_CLASSIFY.md
│           ├── 03_MEDICAL_CONTENT_REVIEW_WORKFLOW.md
│           ├── 04_BUILD_RAG_INGESTION.md
│           ├── 05_BUILD_OFFLINE_MEDICAL_CATALOG.md
│           ├── 06_TEST_RAG_AND_SAFETY.md
│           └── 07_UPDATE_MEDICAL_DOCUMENTATION.md
├── CLAUDE.md
└── ...existing application files...
```

Các file PDF gốc có thể không được commit vào Git nếu điều khoản không cho phép. Khi đó lưu metadata, URL, checksum và hướng dẫn cách lấy bản hợp lệ; cung cấp file nội bộ qua vị trí được phép. Không tự đưa tài liệu có bản quyền vào repo public.

# 10. NHIỆM VỤ NGHIÊN CỨU CỤ THỂ

Hãy thực hiện theo thứ tự:

### Task A — Source discovery

Tìm nguồn chính thức Việt Nam và quốc tế cho từng topic. Ưu tiên trang cơ quan ban hành và tài liệu gốc. Với mỗi kết quả, cung cấp URL cụ thể, ngày truy cập và mức độ xác minh. Tìm cả thông tin hướng dẫn xin tài liệu từ Hội Chữ thập đỏ Việt Nam/Bộ Y tế nếu file không công khai.

### Task B — Verify legal/medical status

Xác minh Quyết định 7296/QĐ-BYT được nhắc trong đề tài. Kiểm tra số/ngày/tên văn bản, nội dung phê duyệt, bộ tài liệu đính kèm, tình trạng hiện tại và nguồn gốc file. Không mặc định đúng.

### Task C — Build source matrix

Tạo bảng theo từng topic:

| Topic | Nguồn Việt Nam ưu tiên | Nguồn quốc tế đối chiếu | Đối tượng | Trạng thái xác minh | Quyền sử dụng | Khoảng trống | MVP? |

Phải có citation/URL ngay trong từng dòng hoặc cột nguồn. Nếu chưa có nguồn đủ tin cậy, ghi `SOURCE GAP`.

### Task D — Recommend MVP medical corpus

Đề xuất corpus tối thiểu có thể kiểm chứng trong thời gian nước rút. Chỉ chọn số topic mà nhóm đủ khả năng biên tập/được review. Với mỗi topic, xác định tài liệu nguồn cần có, số nội dung/đoạn cần curate, trạng thái review bắt buộc và lý do đưa vào MVP.

### Task E — Data and RAG schema

Đề xuất schema metadata và entity phù hợp cho:

- source document;
- extracted section/chunk;
- curated first-aid content;
- topic/audience/age group;
- review/approval status;
- version and update manifest;
- local SQLite/Drift representation;
- cloud RAG representation.

Chỉ mô tả đề xuất; chưa tạo migration hoặc code.

### Task F — Claude Code prompt package

Sau khi hoàn thành research và thiết kế, hãy tạo một bộ prompt dành cho Claude Code, có thứ tự và phạm vi nhỏ. Mỗi prompt phải nêu:

1. Vai trò/mục tiêu.
2. Thông tin cần đọc trước (CLAUDE.md, docs hiện có, source registry, ADR...).
3. Những file/thư mục dự kiến đọc và sửa; yêu cầu Claude Code tự inspect trước khi quyết định đường dẫn.
4. Nhiệm vụ cụ thể và ngoài phạm vi.
5. Quy tắc nguồn y khoa, citation, copyright và safety.
6. Acceptance criteria có thể kiểm chứng.
7. Test command cần chạy (sau khi inspect dự án; không tự bịa script).
8. Tài liệu/báo cáo phải cập nhật.
9. Điều kiện dừng và câu hỏi cần hỏi người dùng.
10. Commit message đề xuất; không tự commit nếu chưa được yêu cầu.

Bộ prompt tối thiểu nên gồm:

- Prompt 00: Audit repository và xác định trạng thái hiện tại trước khi thêm pipeline medical.
- Prompt 01: Tạo cấu trúc docs/source/medical và source registry.
- Prompt 02: Nhập/đăng ký tài liệu nguồn và kiểm tra quyền sử dụng (không tải tự động nếu chưa được phép).
- Prompt 03: Extract/segment/classify tài liệu và tạo bản trích xuất có citation.
- Prompt 04: Xây quy trình medical review và approved content catalog; không tự phê duyệt nội dung.
- Prompt 05: Thiết kế/tích hợp RAG chỉ dùng nội dung được phép và đã duyệt.
- Prompt 06: Tích hợp offline catalog SQLite/Drift và versioning/sync/rollback.
- Prompt 07: Viết tests cho source traceability, retrieval, safety và offline.
- Prompt 08: Cập nhật bốn báo cáo M1–M4 và evidence theo dữ liệu thực tế.

Không yêu cầu Claude Code chạy tất cả prompt liên tiếp tự động. Người dùng sẽ review kết quả từng bước và chọn prompt tiếp theo.

# 11. YÊU CẦU ĐẦU RA CỦA LƯỢT RESEARCH NÀY

Hãy xuất kết quả theo thứ tự sau:

1. **Executive summary:** 5–10 kết luận quan trọng, khuyến nghị rõ ràng.
2. **Source discovery table:** nguồn theo từng topic, link, tổ chức, loại nguồn, xác minh, ngày/phiên bản.
3. **Vietnam official-source verification:** kết quả riêng về Bộ Y tế, Hội Chữ thập đỏ Việt Nam và Quyết định 7296/QĐ-BYT.
4. **Source quality and reuse matrix:** độ tin cậy, thẩm quyền, đối tượng, quyền tái sử dụng; phân biệt rõ medical authority với copyright permission.
5. **MVP medical corpus:** chủ đề nào chọn trước, chủ đề nào hoãn và lý do.
6. **Taxonomy + metadata schema:** quy tắc phân loại và các trường dữ liệu.
7. **Ingestion/RAG/offline architecture:** pipeline và sơ đồ Mermaid nếu hữu ích.
8. **Safety and medical review workflow:** ai phải review, trạng thái nào được phát hành, khi thiếu nguồn xử lý thế nào.
9. **Repository file plan:** đường dẫn chính xác các tài liệu cần có trong dự án.
10. **Claude Code prompt pack:** nội dung đầy đủ của từng prompt nhỏ, sẵn sàng lưu thành các file `.md` trong `docs/prompts/medical_knowledge/`.
11. **Question list for lecturer/medical reviewer/Red Cross:** chỉ hỏi những điểm chưa thể xác minh bằng tài liệu công khai.
12. **Immediate next actions:** 3–7 hành động ưu tiên theo thứ tự, phù hợp với thời gian nước rút.

Nếu giao diện có thể tạo file, hãy tạo các file Markdown riêng. Nếu không thể ghi trực tiếp vào repository, hãy xuất đầy đủ nội dung từng file kèm đường dẫn đích chính xác, để người dùng đưa vào Claude Code tạo file. Không được tuyên bố đã lưu file vào repository khi chưa thực sự có quyền thao tác.

# 12. NGUYÊN TẮC KHÔNG ĐƯỢC VI PHẠM

- Không bịa nguồn, tên tài liệu, số quyết định, ngày ban hành, URL, trang hoặc giấy phép.
- Không dùng search snippet làm bằng chứng cuối cùng.
- Không trích nguyên văn dài từ tài liệu có bản quyền. Chỉ trích đoạn ngắn cần thiết và tôn trọng điều khoản sử dụng.
- Không tự soạn hoặc tự xác nhận phác đồ sơ cứu.
- Không đánh dấu tài liệu là approved chỉ vì AI đã đọc hoặc phân loại.
- Không cho LLM sinh ra hướng dẫn y khoa ngoài corpus được duyệt.
- Không tuyên bố AI cloud hoạt động offline.
- Không tự tải/copy toàn bộ PDF có bản quyền vào repository public.
- Không sửa source code, database schema, migration, app behavior hoặc deploy trong giai đoạn này.
- Không lập lại roadmap 13 tuần. Hãy ưu tiên MVP và tài liệu đủ dùng cho giai đoạn hoàn thiện cuối kỳ.
- Phân biệt rõ: **Fact from source**, **Research finding**, **Engineering recommendation**, **Unverified**, **Requires human/medical review**.
- Nếu thiếu thông tin, ghi rõ thiếu gì và đề xuất cách xác minh; không dừng toàn bộ công việc chỉ vì một nguồn chưa có.

**Bắt đầu bằng việc xác nhận các nguồn/tài liệu hiện có trong Project, nêu rõ phạm vi bạn có thể truy cập, rồi tiến hành nghiên cứu web. Chưa viết code.**

## HẾT PROMPT

---

## GỢI Ý CÁCH DÙNG

1. Trong Claude Project `FirstAid`, thêm mô tả đề tài gốc, bản đã hiệu chỉnh, biểu mẫu môn học và yêu cầu học phần vào Context.
2. Mở chat mới trong Project và dán toàn bộ phần nằm giữa `PROMPT — SAO CHÉP TỪ ĐÂY` và `HẾT PROMPT`.
3. Bật khả năng web research nếu Claude yêu cầu/quyền truy cập có sẵn. Bắt buộc kiểm tra nguồn gốc, không chỉ yêu cầu Claude liệt kê link.
4. Đọc kết quả source matrix và trạng thái xác minh. Đặc biệt xem lại quyền sử dụng tài liệu trước khi đưa vào GitHub public hoặc app.
5. Khi chốt bộ nguồn và cấu trúc, lấy `Claude Code prompt pack` đưa sang Claude Code tại thư mục repository đã clone.
6. Yêu cầu Claude Code thực hiện từng prompt một, kiểm tra `git diff`, test và cập nhật tài liệu trước khi chuyển bước.

**Gợi ý thư mục đích trong repository:**

```text
docs/
├── source/medical/
│   ├── README.md
│   ├── source_register.md
│   ├── source_register.csv
│   ├── official/
│   ├── international/
│   ├── extracted/
│   └── review/
├── ai/
│   ├── MEDICAL_RAG_DESIGN.md
│   ├── INGESTION_PIPELINE.md
│   └── EVALUATION_PLAN.md
└── prompts/medical_knowledge/
    ├── 00_REPOSITORY_AUDIT.md
    ├── 01_CREATE_MEDICAL_SOURCE_STRUCTURE.md
    ├── 02_REGISTER_AND_VERIFY_SOURCES.md
    ├── 03_EXTRACT_AND_CLASSIFY.md
    ├── 04_MEDICAL_REVIEW_WORKFLOW.md
    ├── 05_RAG_INTEGRATION.md
    ├── 06_OFFLINE_CATALOG_AND_SYNC.md
    ├── 07_SAFETY_AND_TESTS.md
    └── 08_UPDATE_REPORTS_AND_EVIDENCE.md
```

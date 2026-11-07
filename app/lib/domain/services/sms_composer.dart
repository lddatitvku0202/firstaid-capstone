/// Mở ứng dụng nhắn tin với nội dung soạn sẵn. KHÔNG tự gửi: người dùng xem
/// và tự bấm gửi trong ứng dụng nhắn tin.
abstract interface class SmsComposer {
  /// [recipient] có thể để trống để người dùng tự chọn người nhận.
  Future<bool> openSmsDraft(String body, {String? recipient});
}

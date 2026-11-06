/// Mở trình quay số với số cho trước. Người dùng tự bấm gọi; không tự gọi.
abstract interface class DialerService {
  /// Trả về true nếu mở được trình quay số.
  Future<bool> openDialer(String number);
}

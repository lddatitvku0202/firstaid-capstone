enum TtsAvailability {
  /// Thiết bị báo có giọng vi-VN.
  available,

  /// Engine TTS có nhưng không có giọng vi-VN.
  vietnameseMissing,

  /// Không khởi tạo được engine TTS.
  unavailable,
}

abstract interface class TtsService {
  /// Kiểm tra giọng vi-VN trên thiết bị. Không suy diễn việc TTS chạy offline.
  Future<TtsAvailability> checkVietnamese();
  Future<void> speak(String text);
  Future<void> stop();
}

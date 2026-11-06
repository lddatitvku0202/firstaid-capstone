import 'package:flutter_tts/flutter_tts.dart';

import '../../domain/services/tts_service.dart';

const _viVn = 'vi-VN';

class FlutterTtsService implements TtsService {
  FlutterTtsService([FlutterTts? tts]) : _tts = tts ?? FlutterTts();

  final FlutterTts _tts;

  @override
  Future<TtsAvailability> checkVietnamese() async {
    try {
      final available = await _tts.isLanguageAvailable(_viVn);
      if (available == true) {
        await _tts.setLanguage(_viVn);
        return TtsAvailability.available;
      }
      return TtsAvailability.vietnameseMissing;
    } on Object {
      return TtsAvailability.unavailable;
    }
  }

  @override
  Future<void> speak(String text) async {
    await _tts.stop();
    await _tts.speak(text);
  }

  @override
  Future<void> stop() async {
    await _tts.stop();
  }
}

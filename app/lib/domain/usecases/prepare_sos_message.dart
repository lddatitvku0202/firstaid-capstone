import '../entities/sos_message.dart';

/// Chỉ soạn nội dung để người dùng kiểm tra; KHÔNG tự gửi.
class PrepareSosMessage {
  const PrepareSosMessage();

  static const maxNoteLength = 160;

  SosMessage call({
    double? latitude,
    double? longitude,
    String? note,
    required DateTime now,
  }) {
    final hasLocation = latitude != null && longitude != null;
    final buffer = StringBuffer('Tôi cần hỗ trợ khẩn cấp (FirstAid). ');
    buffer.write('Thời gian: ${_format(now)}. ');
    if (hasLocation) {
      final lat = latitude.toStringAsFixed(6);
      final lon = longitude.toStringAsFixed(6);
      buffer.write('Vị trí GPS: $lat, $lon');
      buffer.write(' (https://maps.google.com/?q=$lat,$lon).');
    } else {
      buffer.write('Vị trí: chưa có.');
    }

    var truncated = false;
    final trimmed = note?.trim() ?? '';
    if (trimmed.isNotEmpty) {
      var n = trimmed.replaceAll(RegExp(r'\s+'), ' ');
      if (n.length > maxNoteLength) {
        n = '${n.substring(0, maxNoteLength - 1)}…';
        truncated = true;
      }
      buffer.write(' Ghi chú: $n');
    }

    return SosMessage(
      body: buffer.toString(),
      latitude: hasLocation ? latitude : null,
      longitude: hasLocation ? longitude : null,
      noteTruncated: truncated,
    );
  }

  static String _format(DateTime t) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(t.day)}/${two(t.month)}/${t.year} ${two(t.hour)}:${two(t.minute)}';
  }
}

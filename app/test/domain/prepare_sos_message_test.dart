import 'package:app/data/services/url_launcher_sms_composer.dart';
import 'package:app/domain/usecases/prepare_sos_message.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const uc = PrepareSosMessage();
  final now = DateTime(2026, 11, 7, 9, 5);

  test('có tọa độ: nội dung có thời gian, tọa độ 6 chữ số, không tự gửi', () {
    final m = uc.call(latitude: 16.0544, longitude: 108.2022, now: now);
    expect(m.hasLocation, isTrue);
    expect(m.body, contains('07/11/2026 09:05'));
    expect(m.body, contains('16.054400, 108.202200'));
    expect(m.body, isNot(contains('Ghi chú')));
    expect(m.noteTruncated, isFalse);
  });

  test('không có tọa độ: ghi rõ chưa có vị trí', () {
    final m = uc.call(now: now);
    expect(m.hasLocation, isFalse);
    expect(m.latitude, isNull);
    expect(m.body, contains('Vị trí: chưa có'));
  });

  test('chỉ có một nửa tọa độ được coi là không có vị trí', () {
    final m = uc.call(latitude: 16.0, now: now);
    expect(m.hasLocation, isFalse);
    expect(m.body, contains('chưa có'));
  });

  test('ghi chú ngắn được thêm, khoảng trắng thừa được gọn', () {
    final m = uc.call(note: '  Tầng 3,\n  phòng 12  ', now: now);
    expect(m.body, endsWith('Ghi chú: Tầng 3, phòng 12'));
    expect(m.noteTruncated, isFalse);
  });

  test('ghi chú dài bị cắt và đánh dấu', () {
    final long = 'a' * 500;
    final m = uc.call(note: long, now: now);
    expect(m.noteTruncated, isTrue);
    final note = m.body.split('Ghi chú: ').last;
    expect(note.length, PrepareSosMessage.maxNoteLength);
    expect(note, endsWith('…'));
  });

  test('ghi chú rỗng/chỉ khoảng trắng bị bỏ qua', () {
    expect(uc.call(note: '   ', now: now).body, isNot(contains('Ghi chú')));
  });

  test('URI sms: để trống người nhận, mã hóa %20 và ký tự đặc biệt', () {
    final uri = buildSmsUri('Cần hỗ trợ & vị trí: 1,2');
    expect(uri.scheme, 'sms');
    expect(uri.path, isEmpty);
    expect(uri.toString(), isNot(contains('+')));
    expect(uri.toString(), contains('%20'));
    expect(uri.toString(), contains('%26'));
    final back = Uri.decodeComponent(uri.query.substring('body='.length));
    expect(back, 'Cần hỗ trợ & vị trí: 1,2');
  });
}

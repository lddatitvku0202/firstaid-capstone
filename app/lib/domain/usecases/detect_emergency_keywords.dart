import 'search_protocols.dart' show normalizeForSearch;

/// Tiền kiểm "gọi 115" chạy TRÊN MÁY, trước khi gửi gì lên mạng.
///
/// Bản port 1-1 của `backend/app/rules.py` (cùng danh sách cụm, cùng thứ tự
/// luật) để app và server cho kết quả giống nhau. Từ khóa lấy theo điều kiện
/// gọi 115 của các phác đồ trong app; do nhóm tự viết, CHƯA rà soát lâm sàng
/// (not_clinically_reviewed). Thiên về báo động thừa, không hiểu phủ định,
/// KHÔNG đoán tuổi (không rõ tuổi thì protocolCode = null).
/// Sửa danh sách ở đây thì phải sửa cả backend/app/rules.py.
class EmergencyKeywordMatch {
  const EmergencyKeywordMatch(this.rule, this.protocolCode);

  /// cpr | choking | bleeding
  final String rule;
  final String? protocolCode;
}

const _unresponsiveOrNotBreathing = [
  'khong tho', 'ngung tho', 'ngung tim', 'tim ngung', 'tho bat thuong', //
  'khong con tho', 'ngung tuan hoan', 'khong phan ung', 'bat tinh',
  'khong tinh', 'khong tho binh thuong',
];
const _chokingCannotCough = [
  'khong ho duoc', 'khong the ho', 'khong noi duoc', 'khong the noi', //
  'khong tho duoc', 'khong the tho', 'tac tho', 'nghet tho', 'tim tai',
  'khong keu duoc', 'khong khoc duoc',
];
const _chokingContext = ['nghen', 'hoc', 'mac co', 'ket hong', 'sac'];
const _severeBleeding = [
  'mau phun', 'phun mau', 'chay mau nhieu', 'mat nhieu mau', //
  'khong cam duoc mau', 'mau khong cam', 'mau chay thanh dong',
  'mau chay ao at', 'tham uot bang', 'mau chay khong ngung',
  'mau chay xoi xa',
];
const _infantWords = [
  'so sinh', 'em be', 'duoi 1 tuoi', 'thang tuoi', 'be nho', 'con nho', //
  'tre so sinh',
];
const _childWords = [
  'tre em', 'be gai', 'be trai', 'cau be', 'co be', 'con toi', 'be nha toi', //
  'be',
];
const _adultWords = [
  'nguoi lon', 'thanh nien', 'thanh thieu nien', 'dan ong', 'phu nu', //
  'ong cu', 'ba cu', 'ong noi', 'ba noi', 'nguoi gia', 'cu ong', 'cu ba',
];

final _nonToken = RegExp(r'[^a-z0-9]+');

/// Dấu kết hợp (khi bàn phím gửi chữ dạng tách dấu NFD).
final _combiningMarks = RegExp(
  '[${String.fromCharCode(0x0300)}-${String.fromCharCode(0x036F)}]',
);

/// Chữ thường, bỏ dấu, chỉ còn a-z0-9 và khoảng trắng đơn (giống textnorm.py).
String normalizeForRules(String text) =>
    normalizeForSearch(text.replaceAll(_combiningMarks, ''))
        .split(_nonToken)
        .where((t) => t.isNotEmpty)
        .join(' ');

bool _has(String norm, List<String> phrases) {
  final padded = ' $norm ';
  return phrases.any((p) => padded.contains(' $p '));
}

EmergencyKeywordMatch? detectEmergencyKeywords(String text) {
  final norm = normalizeForRules(text);
  final infant = _has(norm, _infantWords);
  final child = _has(norm, _childWords);
  final adult = _has(norm, _adultWords);
  final unresponsive = _has(norm, _unresponsiveOrNotBreathing);
  final chokingContext = _has(norm, _chokingContext);

  EmergencyKeywordMatch choking() {
    if (infant && !adult) {
      return const EmergencyKeywordMatch('choking', 'choking_baby');
    }
    if ((adult || norm.contains('tre em')) && !infant) {
      return const EmergencyKeywordMatch('choking', 'choking_adult_child');
    }
    return const EmergencyKeywordMatch('choking', null);
  }

  if (unresponsive && !chokingContext) {
    if ((infant || child) && !adult) {
      return const EmergencyKeywordMatch('cpr', 'cpr_baby_child');
    }
    if (adult && !(infant || child)) {
      return const EmergencyKeywordMatch('cpr', 'cpr_adult_adolescent');
    }
    return const EmergencyKeywordMatch('cpr', null);
  }
  if (_has(norm, _chokingCannotCough)) return choking();
  if (_has(norm, _severeBleeding)) {
    return const EmergencyKeywordMatch('bleeding', 'bleeding_wounds_severe');
  }
  if (unresponsive && chokingContext) return choking();
  return null;
}

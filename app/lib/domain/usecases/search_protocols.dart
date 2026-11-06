import '../entities/first_aid_protocol.dart';
import '../repositories/protocol_repository.dart';

const _from =
    'àáảãạăằắẳẵặâầấẩẫậèéẻẽẹêềếểễệìíỉĩịòóỏõọôồốổỗộơờớởỡợùúủũụưừứửữựỳýỷỹỵđ';
const _to =
    'aaaaaaaaaaaaaaaaaeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyyd';

/// Bỏ dấu tiếng Việt và hạ chữ thường để tìm kiếm.
String normalizeForSearch(String input) {
  final lower = input.toLowerCase();
  final buffer = StringBuffer();
  for (final rune in lower.runes) {
    final ch = String.fromCharCode(rune);
    final i = _from.indexOf(ch);
    buffer.write(i >= 0 ? _to[i] : ch);
  }
  return buffer.toString();
}

/// Tìm kiếm local trên tiêu đề, mã và nội dung bước. Không gọi mạng.
class SearchProtocols {
  const SearchProtocols(this._repository);
  final ProtocolRepository _repository;

  Future<List<FirstAidProtocol>> call(String query) async {
    final all = await _repository.getOfflineProtocols();
    final q = normalizeForSearch(query.trim());
    if (q.isEmpty) return all;
    return [
      for (final p in all)
        if (_matches(p, q)) p,
    ];
  }

  bool _matches(FirstAidProtocol p, String q) {
    final haystack = normalizeForSearch(
      '${p.title} ${p.code} ${p.topicId} ${p.steps.map((s) => s.text).join(' ')}',
    );
    return haystack.contains(q);
  }
}

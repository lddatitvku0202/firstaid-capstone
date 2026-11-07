/// So sánh phiên bản dạng "1.2.3" (số, phân tách bằng dấu chấm).
/// Trả về số âm nếu a nhỏ hơn b, 0 nếu bằng, số dương nếu a lớn hơn b. Phần không phải số coi là 0.
int compareVersions(String a, String b) {
  List<int> parse(String v) => [
    for (final part in v.split('.')) int.tryParse(part.trim()) ?? 0,
  ];
  final pa = parse(a);
  final pb = parse(b);
  final n = pa.length > pb.length ? pa.length : pb.length;
  for (var i = 0; i < n; i++) {
    final x = i < pa.length ? pa[i] : 0;
    final y = i < pb.length ? pb[i] : 0;
    if (x != y) return x.compareTo(y);
  }
  return 0;
}

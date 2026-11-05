class ProtocolStep {
  const ProtocolStep({required this.order, required this.text, this.citation});

  final int order;
  final String text;

  /// Trích dẫn nguồn; null nghĩa là chưa có nguồn (UNVERIFIED_PLACEHOLDER).
  final String? citation;
}

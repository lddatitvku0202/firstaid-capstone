/// Trích dẫn nguồn: source_id (khớp source_register.csv) + trang/mục.
class SourceCitation {
  const SourceCitation({required this.sourceId, required this.pages});

  final String sourceId;
  final String pages;

  @override
  String toString() => '$sourceId p$pages';
}

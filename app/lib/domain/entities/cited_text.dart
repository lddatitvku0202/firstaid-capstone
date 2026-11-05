/// Một dòng nội dung kèm nguồn (dùng cho do_not, điều kiện gọi 115).
class CitedText {
  const CitedText({required this.text, this.citation});

  final String text;
  final String? citation;
}

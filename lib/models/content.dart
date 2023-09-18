class Content {
  const Content({required this.title, this.text, this.images});

  final String title;
  final String? text;
  final List<String>? images;

  bool get isImage => images is List && text is! String;
  bool get hasContent => (text is String && text!.isNotEmpty) || (images is List && images!.isNotEmpty);
}

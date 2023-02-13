import 'dart:convert';

class BookData {
  const BookData({required this.chapters, required this.sinopse, required this.categories, this.type});

  final List chapters;
  final String sinopse;
  final List<String> categories;

  final String? type;

  Map<String, dynamic> toMap() {
    return {'chapters': chapters, 'sinopse': sinopse, 'categories': categories, 'type': type};
  }

  String toJson() => json.encode(toMap());

  factory BookData.fromMap(Map<String, dynamic> map) {
    return BookData(
      type: map['type'],
      sinopse: map['sinopse'],
      chapters: map['chapters'],
      categories: map['categories'],
    );
  }

  factory BookData.fromJson(String source) => BookData.fromMap(json.decode(source) as Map<String, dynamic>);
}

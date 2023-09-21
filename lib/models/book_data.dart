import 'dart:convert';

import 'package:anr/models/book.dart';
import 'package:anr/models/chapter.dart';

class BookData {
  const BookData({
    required this.book,
    required this.sinopse,
    required this.chapters,
    required this.categories,
    this.type,
  });

  final Book book;
  final String sinopse;
  final List<String> categories;
  final List<Chapter> chapters;
  final String? type;

  Map<String, dynamic> toMap() {
    return {'book': book.toMap(), 'sinopse': sinopse, 'chapters': chapters, 'categories': categories, 'type': type};
  }

  String toJson() => json.encode(toMap());

  factory BookData.fromMap(Map<String, dynamic> map) {
    return BookData(
      type: map['type'],
      sinopse: map['sinopse'],
      chapters: map['chapters'] is List<Chapter> ? map['chapters'].map((e) => e.toMap()).toList() : map['chapters'],
      categories: map['categories'],
      book: map['book'] is Book ? map['book'] : Book.fromMap(map['book']),
    );
  }

  factory BookData.fromJson(String source) => BookData.fromMap(json.decode(source) as Map<String, dynamic>);
}

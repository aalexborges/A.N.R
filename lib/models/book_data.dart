import 'dart:convert';

import 'package:anr/models/book_item.dart';
import 'package:anr/models/chapter.dart';

class BookData {
  const BookData({
    required this.sinopse,
    required this.bookItem,
    required this.categories,
    required this.chapters,
    this.type,
  });

  final BookItem bookItem;

  final String sinopse;
  final List<String> categories;
  final List<Chapter> chapters;
  final String? type;

  Map<String, dynamic> toMap() {
    return {'sinopse': sinopse, 'categories': categories, 'bookItem': bookItem.toMap(), 'type': type};
  }

  String toJson() => json.encode(toMap());

  factory BookData.fromMap(Map<String, dynamic> map) {
    return BookData(
      type: map['type'],
      sinopse: map['sinopse'],
      chapters: map['chapters'] is List<Chapter> ? map['chapters'].map((e) => e.toMap()).toList() : map['chapters'],
      categories: map['categories'],
      bookItem: map['bookItem'] is BookItem ? map['bookItem'] : BookItem.fromMap(map['bookItem']),
    );
  }

  factory BookData.fromJson(String source) => BookData.fromMap(json.decode(source) as Map<String, dynamic>);
}

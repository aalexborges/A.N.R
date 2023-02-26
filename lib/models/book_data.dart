import 'dart:convert';

import 'package:anr/models/chapter.dart';

class BookData {
  const BookData({required this.chapters, required this.sinopse, required this.categories, this.type});

  final String sinopse;
  final List<String> categories;
  final List<Chapter> chapters;

  final String? type;

  List<String> subtitleInfos(String? alternativeType) {
    return List.generate(type == null && alternativeType == null ? 1 : 2, (index) {
      if (index == 0) return chapters.length.toString();
      return (type ?? alternativeType)!.trim().toUpperCase();
    });
  }

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

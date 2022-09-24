// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:A.N.R/models/chapter.model.dart';

class BookData {
  final String? type;

  final List<Chapter> chapters;
  final String sinopse;
  final List<String> categories;

  const BookData({
    this.type,
    required this.chapters,
    required this.sinopse,
    required this.categories,
  });

  BookData copyWith({
    String? type,
    List<Chapter>? chapters,
    String? sinopse,
    List<String>? categories,
  }) {
    return BookData(
      type: type ?? this.type,
      chapters: chapters ?? this.chapters,
      sinopse: sinopse ?? this.sinopse,
      categories: categories ?? this.categories,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'chapters': chapters.map((x) => x.toMap()).toList(),
      'sinopse': sinopse,
      'categories': categories,
    };
  }

  factory BookData.fromMap(Map<String, dynamic> map) {
    return BookData(
      type: map['type'] != null ? map['type'] as String : null,
      chapters: List<Chapter>.from(
        (map['chapters'] as List<dynamic>).map<Chapter>(
          (x) => Chapter.fromMap(x as Map<String, dynamic>),
        ),
      ),
      sinopse: map['sinopse'] as String,
      categories: List<String>.from((map['categories'] as List<dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory BookData.fromJson(String source) =>
      BookData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BookData(type: $type, chapters: $chapters, sinopse: $sinopse, categories: $categories)';
  }

  @override
  bool operator ==(covariant BookData other) {
    if (identical(this, other)) return true;

    return other.type == type &&
        listEquals(other.chapters, chapters) &&
        other.sinopse == sinopse &&
        listEquals(other.categories, categories);
  }

  @override
  int get hashCode {
    return type.hashCode ^
        chapters.hashCode ^
        sinopse.hashCode ^
        categories.hashCode;
  }
}

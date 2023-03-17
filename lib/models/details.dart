import 'dart:convert';

import 'package:anr/models/book.dart';
import 'package:anr/models/book_data.dart';
import 'package:anr/models/scan.dart';

class Details {
  const Details({
    required this.scan,
    required this.name,
    required this.sinopse,
    required this.categories,
    required this.lastChapter,
    required this.chapterLength,
    this.type,
  });

  final Scan scan;
  final String name;
  final String sinopse;
  final List<String> categories;
  final String lastChapter;
  final int chapterLength;

  final String? type;

  Map<String, dynamic> toMap() {
    return {
      'scan': scan.value,
      'name': name,
      'sinopse': sinopse,
      'categories': categories,
      'chapterLength': chapterLength,
      'lastChapter': lastChapter,
      'type': type,
    };
  }

  String toJson() => json.encode(toMap());

  factory Details.fromBook({required Book book, required BookData data}) {
    return Details(
      scan: book.scan,
      name: book.name,
      sinopse: data.sinopse,
      categories: data.categories,
      chapterLength: data.chapters.length,
      lastChapter: data.chapters.isEmpty ? '0' : data.chapters.first.chapter,
      type: data.type ?? book.type,
    );
  }

  factory Details.fromMap(Map<String, dynamic> map) {
    return Details(
      name: map['name'],
      scan: map['scan'] is String ? scanByValue(map['scan']) : map['scan'],
      sinopse: map['sinopse'],
      categories: map['categories'],
      chapterLength: map['chapterLength'],
      lastChapter: map['lastChapter'],
      type: map['type'],
    );
  }

  factory Details.fromJson(String source) => Details.fromMap(json.decode(source) as Map<String, dynamic>);
}

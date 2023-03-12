import 'dart:convert';

import 'package:anr/models/chapter.dart';
import 'package:anr/models/scan.dart';

class BookData {
  const BookData({required this.chapters, required this.sinopse, required this.categories, this.type});

  final String sinopse;
  final List<String> categories;
  final List<Chapter> chapters;

  final String? type;

  List<String> subtitleInfos({required Scan scan, String? alternativeType}) {
    final items = <String>[];

    if (chapters.isNotEmpty) items.add('${chapters.length}/${chapters.first.chapter}');
    if (type != null || alternativeType != null) items.add((type ?? alternativeType)!.trim().toUpperCase());
    items.add(scan.value.toUpperCase());

    return items;
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

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:A.N.R/utils/scan.util.dart';
import 'package:flutter/foundation.dart';

import 'package:A.N.R/constants/scans.dart';
import 'package:slugify/slugify.dart';

class BookDownload {
  final Scans scan;

  final String url;
  final String name;
  final String sinopse;
  final String imageURL;
  final List<String> categories;

  final String? imageURL2;
  final String? type;

  const BookDownload({
    required this.scan,
    required this.url,
    required this.name,
    required this.sinopse,
    required this.imageURL,
    required this.categories,
    this.imageURL2,
    this.type,
  });

  BookDownload copyWith({
    Scans? scan,
    String? url,
    String? name,
    String? sinopse,
    String? imageURL,
    List<String>? categories,
    String? imageURL2,
    String? type,
  }) {
    return BookDownload(
      scan: scan ?? this.scan,
      url: url ?? this.url,
      name: name ?? this.name,
      sinopse: sinopse ?? this.sinopse,
      imageURL: imageURL ?? this.imageURL,
      categories: categories ?? this.categories,
      imageURL2: imageURL2 ?? this.imageURL2,
      type: type ?? this.type,
    );
  }

  String get id => slugify(name.trim(), lowercase: true, delimiter: '_');

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'scan': scan.value,
      'url': url,
      'name': name,
      'sinopse': sinopse,
      'imageURL': imageURL,
      'categories': jsonEncode(categories),
      'imageURL2': imageURL2,
      'type': type ?? '',
      'bookId': id,
    };
  }

  factory BookDownload.fromMap(Map<String, dynamic> map) {
    List<String> categories = [];

    if (map['categories'] is String) {
      categories = List<String>.from(jsonDecode(map['categories']));
    } else if (map['categories'] is List<String>) {
      categories = List<String>.from((map['categories'] as List<String>));
    }

    return BookDownload(
      scan: ScanUtil.byValue(map['scan'].toString()),
      url: map['url'] as String,
      name: map['name'] as String,
      sinopse: map['sinopse'] as String,
      imageURL: map['imageURL'] as String,
      categories: categories,
      imageURL2: map['imageURL2'] != null ? map['imageURL2'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BookDownload.fromJson(String source) =>
      BookDownload.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BookDownload(scan: $scan, url: $url, name: $name, sinopse: $sinopse, imageURL: $imageURL, categories: $categories, imageURL2: $imageURL2, type: $type)';
  }

  @override
  bool operator ==(covariant BookDownload other) {
    if (identical(this, other)) return true;

    return other.scan == scan &&
        other.url == url &&
        other.name == name &&
        other.sinopse == sinopse &&
        other.imageURL == imageURL &&
        listEquals(other.categories, categories) &&
        other.imageURL2 == imageURL2 &&
        other.type == type;
  }

  @override
  int get hashCode {
    return scan.hashCode ^
        url.hashCode ^
        name.hashCode ^
        sinopse.hashCode ^
        imageURL.hashCode ^
        categories.hashCode ^
        imageURL2.hashCode ^
        type.hashCode;
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:A.N.R/utils/scan.util.dart';
import 'package:slugify/slugify.dart';

import 'package:A.N.R/constants/scans.dart';

class Book {
  final Scans scan;

  final String url;
  final String name;
  final String imageURL;

  final String? imageURL2;
  final int? serieId;
  final String? type;

  Book({
    required this.scan,
    required this.url,
    required this.name,
    required this.imageURL,
    this.imageURL2,
    this.serieId,
    this.type,
  });

  String get id => slugify(name.trim(), lowercase: true, delimiter: '_');

  Book copyWith({
    Scans? scan,
    String? url,
    String? name,
    String? imageURL,
    String? imageURL2,
    String? type,
    int? serieId,
  }) {
    return Book(
      scan: scan ?? this.scan,
      url: url ?? this.url,
      name: name ?? this.name,
      imageURL: imageURL ?? this.imageURL,
      imageURL2: imageURL2 ?? this.imageURL2,
      serieId: serieId ?? this.serieId,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'scan': scan.value,
      'url': url,
      'name': name,
      'imageURL': imageURL,
      'imageURL2': imageURL2,
      'serieId': serieId,
      'type': type,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      scan: map['scan'] != null
          ? ScanUtil.byValue(map['scan'])
          : ScanUtil.byURL(map['url']),
      url: map['url'] as String,
      name: map['name'] as String,
      imageURL: map['imageURL'] as String,
      imageURL2: map['imageURL2'] != null ? map['imageURL2'] as String : null,
      serieId: map['serieId'] != null ? map['serieId'] as int : null,
      type: map['type'] != null ? map['type'] as String : map['tag'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory Book.fromJson(String source) =>
      Book.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Book(scan: ${scan.value}, url: $url, name: $name, imageURL: $imageURL, imageURL2: $imageURL2, serieId: $serieId, type: $type)';
  }

  @override
  bool operator ==(covariant Book other) {
    if (identical(this, other)) return true;

    return other.scan == scan &&
        other.url == url &&
        other.name == name &&
        other.imageURL == imageURL &&
        other.imageURL2 == imageURL2 &&
        other.serieId == serieId &&
        other.type == type;
  }

  @override
  int get hashCode {
    return scan.hashCode ^
        url.hashCode ^
        name.hashCode ^
        imageURL.hashCode ^
        imageURL2.hashCode ^
        serieId.hashCode ^
        type.hashCode;
  }
}

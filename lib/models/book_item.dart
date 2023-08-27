import 'dart:convert';

import 'package:anr/models/book_data.dart';
import 'package:anr/models/scan.dart';
import 'package:slugify/slugify.dart';

class BookItem {
  final Scan scan;
  final String name;
  final String path;
  final String src;

  final String? type;
  final int? webID;

  const BookItem({
    required this.name,
    required this.path,
    required this.src,
    required this.scan,
    this.type,
    this.webID,
  });

  String get slug => slugify(name.trim(), lowercase: true, delimiter: '_');

  Future<BookData> getData({bool forceUpdate = false}) {
    return scan.repository.data(this, forceUpdate: forceUpdate);
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'path': path, 'src': src, 'scan': scan.value, 'webID': webID, 'type': type};
  }

  String toJson() => json.encode(toMap());

  factory BookItem.fromMap(Map<String, dynamic> map) {
    return BookItem(
      src: map['src'],
      name: map['name'],
      path: map['path'],
      scan: map['scan'] is String ? Scan.fromString(map['scan']) : map['scan'],
      type: map['type'],
      webID: map['webID'],
    );
  }

  factory BookItem.fromJson(String source) => BookItem.fromMap(json.decode(source) as Map<String, dynamic>);
}

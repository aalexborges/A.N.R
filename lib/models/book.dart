import 'dart:convert';

import 'package:anr/models/scan.dart';
import 'package:slugify/slugify.dart';

class Book {
  const Book({required this.name, required this.path, required this.src, required this.scan, this.type, this.webID});

  final Scan scan;
  final String name;
  final String path;
  final String src;

  final String? type;
  final int? webID;

  String get slug => slugify(name.trim(), lowercase: true, delimiter: '_');

  Map<String, dynamic> toMap() {
    return {'name': name, 'path': path, 'src': src, 'scan': scan.value, 'webID': webID, 'type': type};
  }

  String toJson() => json.encode(toMap());

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      src: map['src'],
      name: map['name'],
      path: map['path'],
      scan: map['scan'] is String ? scanByValue(map['scan']) : map['scan'],
      type: map['type'],
      webID: map['webID'],
    );
  }

  factory Book.fromJson(String source) => Book.fromMap(json.decode(source) as Map<String, dynamic>);
}

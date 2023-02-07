import 'dart:convert';

import 'package:slugify/slugify.dart';

class Book {
  const Book({required this.name, required this.path, required this.src, this.webID, this.type});

  final String name;
  final String path;
  final String src;

  final int? webID;
  final int? type;

  String get slug => slugify(name.trim(), lowercase: true, delimiter: '_');

  Map<String, dynamic> toMap() => {'name': name, 'path': path, 'src': src, 'webID': webID, 'type': type};

  String toJson() => json.encode(toMap());

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(name: map['name'], path: map['path'], src: map['src'], webID: map['webID'], type: map['type']);
  }

  factory Book.fromJson(String source) => Book.fromMap(json.decode(source) as Map<String, dynamic>);
}

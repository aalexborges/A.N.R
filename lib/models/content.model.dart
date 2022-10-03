import 'dart:convert';

class Content {
  final int index;
  final String id;
  final String name;
  final String bookId;

  final List<String>? sources;
  final String? text;

  const Content({
    required this.id,
    required this.index,
    required this.name,
    required this.bookId,
    this.sources,
    this.text,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'index': index,
      'content': sources ?? text ?? '',
      'bookId': bookId,
    };
  }

  String toJson() => json.encode(toMap());

  factory Content.fromMap(Map<String, dynamic> map) {
    List<String>? sources;
    String? text;

    if (map['content'] is List) {
      sources = [];

      for (var item in map['content']) {
        sources.add(item.toString());
      }
    } else if (map['content'] is String) {
      text = map['content'];
    } else if (map['sources'] is List) {
      sources = [];

      for (var item in map['sources']) {
        sources.add(item.toString());
      }
    } else if (map['text'] is String) {
      text = map['text'];
    }

    return Content(
      id: map['id'] as String,
      index: map['index'] as int,
      name: map['name'] as String,
      sources: sources,
      text: text,
      bookId: map['bookId'],
    );
  }
}

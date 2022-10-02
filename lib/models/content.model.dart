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
    dynamic content = '';

    if (map['content'] is List) {
      content = [];

      for (var item in map['content']) {
        content.add(item.toString());
      }
    } else if (map['content'] is String) {
      content = map['content'];
    } else if (map['sources'] is List) {
      content = [];

      for (var item in map['sources']) {
        content.add(item.toString());
      }
    } else if (map['text'] is String) {
      content = map['text'];
    }

    return Content(
      id: map['id'] as String,
      index: map['index'] as int,
      name: map['name'] as String,
      sources: content is String ? null : content,
      text: content is String ? content : null,
      bookId: map['bookId'],
    );
  }
}

import 'dart:convert';

class ContentModel {
  final String id;
  final int index;
  final String name;

  final List<String>? sources;
  final String? text;

  const ContentModel({
    required this.id,
    required this.index,
    required this.name,
    this.sources,
    this.text,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'index': index,
      'content': sources ?? text ?? '',
    };
  }

  String toJson() => json.encode(toMap());

  factory ContentModel.fromMap(Map<String, dynamic> map) {
    List<String>? sources;

    if (map['sources'] is List) {
      sources = [];
      for (var item in map['sources']) {
        sources.add(item.toString());
      }
    }

    return ContentModel(
      id: map['id'] as String,
      index: map['index'] as int,
      name: map['name'] as String,
      sources: sources,
      text: map['text'] == null ? null : map['text'] as String,
    );
  }
}

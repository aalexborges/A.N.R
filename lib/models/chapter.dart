import 'dart:convert';

class Chapter {
  const Chapter({required this.id, required this.name, required this.path});

  final double id;
  final String path;
  final String name;

  String get chapterNumber => chapterNumberById(id);

  String get firebaseId {
    final stringId = id.toString().replaceAll('.', '_');
    return id <= 9 ? '0$stringId' : stringId;
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'path': path};
  }

  String toJson() => json.encode(toMap());

  factory Chapter.fromMap(Map<String, dynamic> map) {
    return Chapter(
      id: map['id'],
      name: map['name'],
      path: map['path'],
    );
  }

  factory Chapter.fromJson(String source) => Chapter.fromMap(json.decode(source) as Map<String, dynamic>);

  static String chapterNumberById(double id) {
    return id.toStringAsFixed(2).contains('.00') ? id.toStringAsFixed(0) : id.toString();
  }

  static double idByFirebaseId(String firebaseId) => double.parse(firebaseId.replaceAll('_', '.'));

  static double idByName(String name) {
    String value = name.toLowerCase().trim();

    value = value.replaceAll(RegExp(r'cap.'), '').trim();
    value = value.replaceAll(RegExp(r'[^0-9. ]'), '').trim();

    final values = value.split(RegExp(r'[. ]'));
    final beforeFloatPoint = int.parse(values.first);

    if (values.length == 1) return double.parse(beforeFloatPoint.toString());

    final afterFloatPoint = int.tryParse(values[1]);

    if (afterFloatPoint != null) return double.parse('$beforeFloatPoint.$afterFloatPoint');
    return double.parse(beforeFloatPoint.toString());
  }
}

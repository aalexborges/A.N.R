// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Chapter {
  final String url;
  final String name;
  final String bookId;
  final double read;

  const Chapter({
    required this.url,
    required this.name,
    required this.bookId,
    this.read = 0,
  });

  String get id {
    final String value = name
        .toLowerCase()
        .replaceAll('cap.', '')
        .replaceAll(RegExp(r'[^0-9. ]'), '')
        .trim()
        .split(' ')[0]
        .replaceAll('.', '_');

    final List<String> splitValue = value.split('_');
    final int first = int.parse(splitValue[0]);
    final String formattedFirst = first <= 9 ? '0$first' : first.toString();

    splitValue.removeAt(0);

    return [formattedFirst, ...splitValue].join('_').trim();
  }

  String get chapter {
    final String stringValue = name
        .toLowerCase()
        .replaceAll('cap.', '')
        .replaceAll(RegExp(r'[^0-9. ]'), '')
        .trim()
        .split(' ')[0];

    final value = double.parse(stringValue);
    return value
        .toStringAsFixed(value == value.roundToDouble() ? 0 : 2)
        .padLeft(2, '0');
  }

  Chapter copyWith({
    String? url,
    String? name,
    String? bookId,
    double? read,
  }) {
    return Chapter(
      url: url ?? this.url,
      name: name ?? this.name,
      bookId: bookId ?? this.bookId,
      read: read ?? this.read,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'name': name,
      'bookId': bookId,
      'read': read,
    };
  }

  factory Chapter.fromMap(Map<String, dynamic> map) {
    return Chapter(
      url: map['url'] as String,
      name: map['name'] as String,
      bookId: map['bookId'] as String,
      read: map['read'] == null ? 0 : map['read'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Chapter.fromJson(String source) =>
      Chapter.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Chapter(url: $url, name: $name, bookId: $bookId, read: $read)';
  }

  @override
  bool operator ==(covariant Chapter other) {
    if (identical(this, other)) return true;

    return other.url == url &&
        other.name == name &&
        other.bookId == bookId &&
        other.read == read;
  }

  @override
  int get hashCode {
    return url.hashCode ^ name.hashCode ^ bookId.hashCode ^ read.hashCode;
  }
}

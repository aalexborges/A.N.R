// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ContentDownloaded {
  final String name;
  final String content;

  final String bookId;
  final String chapterId;

  const ContentDownloaded({
    required this.name,
    required this.content,
    required this.bookId,
    required this.chapterId,
  });

  ContentDownloaded copyWith({
    String? name,
    String? content,
    String? bookId,
    String? chapterId,
  }) {
    return ContentDownloaded(
      name: name ?? this.name,
      content: content ?? this.content,
      bookId: bookId ?? this.bookId,
      chapterId: chapterId ?? this.chapterId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'content': content,
      'bookId': bookId,
      'chapterId': chapterId,
    };
  }

  factory ContentDownloaded.fromMap(Map<String, dynamic> map) {
    return ContentDownloaded(
      name: map['name'] as String,
      content: map['content'] as String,
      bookId: map['bookId'] as String,
      chapterId: map['chapterId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ContentDownloaded.fromJson(String source) =>
      ContentDownloaded.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ContentDownloaded(name: $name, content: $content, bookId: $bookId, chapterId: $chapterId)';
  }

  @override
  bool operator ==(covariant ContentDownloaded other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.content == content &&
        other.bookId == bookId &&
        other.chapterId == chapterId;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        content.hashCode ^
        bookId.hashCode ^
        chapterId.hashCode;
  }
}

import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

part 'http_cache.g.dart';

@HiveType(typeId: 1)
class HttpCache extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String url;

  @HiveField(2)
  final String body;

  @HiveField(3)
  final String method;

  @HiveField(4)
  final int statusCode;

  @HiveField(5)
  final Map<String, String> headers;

  @HiveField(6)
  final DateTime createdAt;

  HttpCache({
    required this.id,
    required this.url,
    required this.body,
    required this.method,
    required this.statusCode,
    required this.headers,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'body': body,
      'method': method,
      'statusCode': statusCode,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  String toJson() => json.encode(toMap());

  factory HttpCache.fromMap(Map<String, dynamic> map) {
    return HttpCache(
      id: map['id'],
      url: map['url'],
      body: map['body'],
      method: map['method'],
      headers: map['headers'],
      statusCode: map['statusCode'],
      createdAt: map['createdAt'],
    );
  }

  factory HttpCache.fromJson(String source) => HttpCache.fromMap(json.decode(source) as Map<String, dynamic>);

  factory HttpCache.fromHttpResponse(http.Response response, {required String url, required String method}) {
    return HttpCache(
      id: HttpCache.idFrom(url, method),
      url: url,
      body: response.body,
      method: method,
      headers: response.headers,
      statusCode: response.statusCode,
    );
  }

  static idFrom(String url, String method) => '$method.$url';
}

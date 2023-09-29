import 'dart:convert';

import 'package:anr/cache/http_cache_manager.dart';
import 'package:http/http.dart' as http;

class HttpRepository {
  final cacheManager = HttpCacheManager();

  Future<http.Response> get(Uri uri, {Map<String, String>? headers, bool forceUpdate = false, String? key}) async {
    final url = uri.toString();
    const method = 'GET';

    if (forceUpdate == false) {
      final cachedResponse = await cacheManager.read(url, method, key: key);
      if (cachedResponse is http.Response) return cachedResponse;
    }

    final response = await http.get(uri, headers: headers);
    await cacheManager.write(response, url: url, method: method, key: key);

    return response;
  }

  Future<http.Response> post(
    Uri uri, {
    Object? body,
    Encoding? encoding,
    Map<String, String>? headers,
    bool forceUpdate = false,
    String? key,
  }) async {
    final url = uri.toString();
    const method = 'POST';

    if (forceUpdate == false) {
      final cachedResponse = await cacheManager.read(url, method, key: key);
      if (cachedResponse is http.Response) return cachedResponse;
    }

    final response = await http.post(uri, headers: headers, body: body, encoding: encoding);
    await cacheManager.write(response, url: url, method: method, key: key);

    return response;
  }

  Future<http.Response> tryGetRequestWithBaseURLs({
    required List<String> baseURLs,
    Uri? uri,
    String? key,
    Map<String, String>? headers,
    bool forceUpdate = true,
  }) async {
    for (String baseURL in baseURLs) {
      final url = uri is Uri ? Uri.parse('$baseURL${uri.path}') : Uri.parse(baseURL);
      final response = await get(url, headers: headers, forceUpdate: forceUpdate, key: key);

      if (response.statusCode >= 200 && response.statusCode < 400) return response;
    }

    throw Exception('All request attempts failed.');
  }

  Future<http.Response> tryPostRequestWithBaseURLs({
    required Uri uri,
    required List<String> baseURLs,
    Object? body,
    Encoding? encoding,
    Map<String, String>? headers,
    bool forceUpdate = true,
    String? key,
  }) async {
    for (String baseURL in baseURLs) {
      final url = Uri.parse('$baseURL${uri.path}');
      final response = await post(
        url,
        key: key,
        body: body,
        headers: headers,
        encoding: encoding,
        forceUpdate: forceUpdate,
      );

      if (response.statusCode >= 200 && response.statusCode < 400) return response;
    }

    throw Exception('All request attempts failed.');
  }
}

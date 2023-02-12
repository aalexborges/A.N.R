import 'dart:async';

import 'package:anr/models/book.dart';
import 'package:anr/models/scan.dart';
import 'package:anr/utils/scraping_util.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

part 'neox_repository.dart';

abstract class ScanBaseRepository {
  List<String> get baseURLs => [];

  Map<String, String>? get headers => null;

  Future<List<Book>> lastAdded() async => [];

  Future<List<Book>> search(String value) async => [];

  Dio dio(String baseURL) {
    final client = Dio(BaseOptions(headers: headers));
    final cookieJar = CookieJar();
    final dioCacheManager = DioCacheManager(CacheConfig(baseUrl: baseURL));

    client.interceptors.addAll([dioCacheManager.interceptor, PrettyDioLogger(), CookieManager(cookieJar)]);

    return client;
  }

  Options cacheOptions({String? subKey, Options? options, bool? forceRefresh = true}) {
    return buildCacheOptions(
      const Duration(days: 31),
      subKey: subKey,
      options: options,
      forceRefresh: forceRefresh,
    );
  }

  bool _isCacheResponse(Response response) {
    return null != response.headers.value(DIO_CACHE_HEADER_KEY_DATA_SOURCE);
  }

  Future<T> _tryAllURLs<T>({required Future<T> Function(String baseURL) callback, T? defaultValue}) async {
    dynamic error;

    for (String baseURL in baseURLs) {
      try {
        return await callback(baseURL);
      } catch (err) {
        error = err;
      }
    }

    if (defaultValue is T) return defaultValue;
    throw error;
  }
}

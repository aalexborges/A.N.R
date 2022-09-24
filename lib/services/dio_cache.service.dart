import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

class DioCache {
  final String url;
  final bool forceRefresh;

  final String? subKey;
  final Options? options;

  late Options cacheOptions;
  late DioCacheManager cache;

  DioCache({
    required this.url,
    this.subKey,
    this.options,
    this.forceRefresh = true,
  }) {
    cache = DioCacheManager(CacheConfig(baseUrl: url));

    cacheOptions = buildCacheOptions(
      const Duration(days: 31),
      subKey: subKey,
      forceRefresh: forceRefresh,
      options: options,
    );
  }
}

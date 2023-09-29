import 'package:anr/models/http_cache.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class HttpCacheManager {
  static final HttpCacheManager instance = HttpCacheManager._internal();
  factory HttpCacheManager() => instance;

  HttpCacheManager._internal();

  Box<HttpCache>? _box;

  Future<Box<HttpCache>> box() async {
    if (box is Box<HttpCache> && Hive.isBoxOpen('http_caches')) return _box!;

    _box = await Hive.openBox<HttpCache>('http_caches');
    return _box!;
  }

  Future<http.Response?> read(String url, String method, {String? key}) async {
    final manager = await box();
    final cache = manager.get(HttpCache.idFrom(url, method, key: key));

    if (cache is! HttpCache) return null;

    if (DateTime.now().difference(cache.createdAt).inMinutes > 10) {
      await cache.delete();
      return null;
    }

    return http.Response(cache.body, cache.statusCode, headers: cache.headers);
  }

  Future<HttpCache> write(http.Response response, {required String url, required String method, String? key}) async {
    final manager = await box();
    final item = HttpCache.fromHttpResponse(response, url: url, method: method, key: key);

    await manager.put(item.id, item);
    return item;
  }

  Future<void> clean() async {
    final manager = await box();
    final items = manager.values.where((e) => DateTime.now().difference(e.createdAt).inMinutes > 10).map((e) => e.key);

    await manager.deleteAll(items);
  }
}

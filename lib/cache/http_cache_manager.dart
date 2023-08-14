import 'package:anr/models/http_cache.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class HttpCacheManager {
  static const boxKey = 'http_caches';

  Future<http.Response?> read(String url, String method) async {
    final Box<HttpCache> manager = Hive.box('http_cache');
    final cache = manager.get(HttpCache.idFrom(url, method));

    if (cache is! HttpCache) return null;

    if (DateTime.now().difference(cache.createdAt).inMinutes > 5) {
      await cache.delete();
      return null;
    }

    return http.Response(cache.body, cache.statusCode);
  }

  Future<HttpCache> write(http.Response response, {required String url, required String method}) async {
    final Box<HttpCache> manager = Hive.box('http_cache');
    final item = HttpCache.fromHttpResponse(response, url: url, method: method);

    await manager.put(item.id, item);
    return item;
  }
}

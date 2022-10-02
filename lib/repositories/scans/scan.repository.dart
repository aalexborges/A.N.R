import 'dart:async';
import 'dart:convert';

import 'package:A.N.R/constants/scans.dart';
import 'package:A.N.R/models/book.model.dart';
import 'package:A.N.R/models/book_data.model.dart';
import 'package:A.N.R/models/chapter.model.dart';
import 'package:A.N.R/models/content.model.dart';
import 'package:A.N.R/services/dio_cache.service.dart';
import 'package:A.N.R/utils/javascript.util.dart';
import 'package:A.N.R/utils/scraping.util.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart' as cookie;
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

part 'cronos.repository.dart';
part 'hunters.repository.dart';
part 'manga_host.repository.dart';
part 'mark.repository.dart';
part 'muito_manga.repository.dart';
part 'neox.repository.dart';
part 'olympus.repository.dart';
part 'prisma.repository.dart';
part 'random.repository.dart';
part 'reaper.repository.dart';

abstract class ScanRepositoryBase {
  late Dio _dio;
  late DioCache _cache;

  String get baseURL => '';

  List<String> get baseURLs => [];

  Future<List<Book>> lastAdded() async => [];

  Future<List<Book>> search(String value) async => [];

  Future<BookData> data(Book book) async {
    return const BookData(categories: [], chapters: [], sinopse: '');
  }

  Future<Content> content(Chapter chapter, int index) async {
    return const Content(id: '', index: 0, name: '', bookId: '');
  }

  Map<String, String>? get headers => null;

  void _updateCache(String url, {String? subKey}) {
    _cache = DioCache(
      url: url,
      subKey: subKey,
      options: Options(headers: headers),
    );

    _dio = Dio();
    _dio.interceptors.add(_cache.cache.interceptor);
    _dio.interceptors.add(cookie.CookieManager(CookieJar()));
  }

  bool _isCacheResponse(Response response) {
    return null != response.headers.value(DIO_CACHE_HEADER_KEY_DATA_SOURCE);
  }
}

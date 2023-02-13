import 'dart:async';

import 'package:anr/models/book.dart';
import 'package:anr/models/book_data.dart';
import 'package:anr/models/scan.dart';
import 'package:anr/utils/scraping_util.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

part 'scans/glorious_repository.dart';
part 'scans/hunters_repository.dart';
part 'scans/manga_host_repository.dart';
part 'scans/manga_livre_repository.dart';
part 'scans/muito_manga_repository.dart';
part 'scans/neox_repository.dart';
part 'scans/olympus_repository.dart';
part 'scans/prisma_repository.dart';
part 'scans/random_repository.dart';
part 'scans/reaper_repository.dart';

abstract class ScanBaseRepository {
  List<String> get baseURLs => [];

  Map<String, String>? get headers => null;

  Future<List<Book>> lastAdded() async => [];

  Future<List<Book>> search(String value) async => [];

  Future<BookData> data(Book book) async => const BookData(sinopse: '', chapters: [], categories: []);

  Dio dio(String baseURL) {
    final client = Dio(BaseOptions(headers: headers));
    final cookieJar = CookieJar();

    client.interceptors.addAll([PrettyDioLogger(), CookieManager(cookieJar)]);

    return client;
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

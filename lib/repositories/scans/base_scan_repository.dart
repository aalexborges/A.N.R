import 'dart:convert';

import 'package:anr/models/book_data.dart';
import 'package:anr/models/book_item.dart';
import 'package:anr/models/scan.dart';
import 'package:anr/service_locator.dart';
import 'package:anr/utils/scraping_utils.dart';
import 'package:html/parser.dart';

part 'package:anr/repositories/scans/hunters_repository.dart';
part 'package:anr/repositories/scans/manga_host_repository.dart';
part 'package:anr/repositories/scans/manga_livre_repository.dart';
part 'package:anr/repositories/scans/neox_repository.dart';
part 'package:anr/repositories/scans/prisma_repository.dart';
part 'package:anr/repositories/scans/random_repository.dart';
part 'package:anr/repositories/scans/reaper_repository.dart';

abstract class BaseScanRepository {
  final Map<String, String>? headers = null;

  Future<List<BookItem>> lastAdded({forceUpdate = false}) async => [];
  Future<List<BookItem>> search(String value, {bool forceUpdate = false}) async => [];

  Future<BookData> data(BookItem bookItem, {bool forceUpdate = false}) async {
    return BookData(sinopse: '', categories: [], bookItem: bookItem);
  }
}

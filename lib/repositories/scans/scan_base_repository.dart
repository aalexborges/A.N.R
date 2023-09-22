import 'dart:convert';

import 'package:anr/models/book.dart';
import 'package:anr/models/book_data.dart';
import 'package:anr/models/chapter.dart';
import 'package:anr/models/content.dart';
import 'package:anr/models/scan.dart';
import 'package:anr/service_locator.dart';
import 'package:anr/utils/scraping_util.dart';
import 'package:flutter/material.dart' as widget;
import 'package:html/dom.dart';
import 'package:html/parser.dart';

part 'package:anr/repositories/scans/glorious_repository.dart';
part 'package:anr/repositories/scans/hunters_repository.dart';
part 'package:anr/repositories/scans/manga_host_repository.dart';
part 'package:anr/repositories/scans/manga_livre_repository.dart';
part 'package:anr/repositories/scans/neox_repository.dart';
part 'package:anr/repositories/scans/prisma_repository.dart';
part 'package:anr/repositories/scans/random_repository.dart';

abstract class ScanBaseRepository {
  final Map<String, String>? headers = null;

  Future<List<Book>> lastAdded({bool forceUpdate = false}) async => [];
  Future<List<Book>> search(String value, {bool forceUpdate = false}) async => [];

  Future<BookData> data(Book book, {bool forceUpdate = false}) async {
    return BookData(book: book, sinopse: '', categories: [], chapters: []);
  }

  Future<Content> content(Chapter chapter) async {
    return Content(key: widget.GlobalObjectKey(DateTime.now().toString()), title: '');
  }
}

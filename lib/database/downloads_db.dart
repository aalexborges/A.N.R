import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:A.N.R/models/book_download.model.dart';
import 'package:A.N.R/models/chapter.model.dart';
import 'package:A.N.R/models/content.model.dart';
import 'package:A.N.R/models/content_downloaded.model.dart';
import 'package:collection/collection.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DownloadsDB {
  static const _databaseName = "book_downloads.db";

  static const _chapterTable = "chapters";
  static const _contentTable = "content";
  static const _bookTable = "book";

  DownloadsDB._();

  static DownloadsDB instance = DownloadsDB._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, _databaseName);

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $_bookTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      url TEXT NOT NULL UNIQUE,
      name TEXT NOT NULL,
      type TEXT NOT NULL,
      scan TEXT NOT NULL,
      sinopse TEXT NOT NULL,
      imageURL TEXT NOT NULL,
      imageURL2 TEXT,
      categories TEXT NOT NULL,
      bookId TEXT NOT NULL UNIQUE
    );
    ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS $_chapterTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      url TEXT NOT NULL,
      name TEXT NOT NULL,
      bookId TEXT NOT NULL,
      chapterId TEXT NOT NULL,
      finished INTEGER NOT NULL DEFAULT 0
    );
    ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS $_contentTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      content TEXT NOT NULL,
      bookId TEXT NOT NULL,
      chapterId TEXT NOT NULL
    );
    ''');
  }

  // ----------------------- GETS -----------------------

  Future<Chapter?> get chapterToDownload async {
    final db = await database;

    final data = await db.query(
      _chapterTable,
      where: 'finished = ?',
      whereArgs: [0],
      orderBy: 'id ASC',
      limit: 1,
    );

    return data.isEmpty ? null : Chapter.fromMap(data.first);
  }

  Future<List<BookDownload>> get books async {
    final db = await database;
    final items = await db.query(_bookTable);

    final books = <BookDownload>[];

    for (Map<String, Object?> item in items) {
      books.add(BookDownload.fromMap(item));
    }

    books.sort((a, b) => compareNatural(a.id, b.id));
    return books;
  }

  // ----------------------- FUNCTION GETS -----------------------

  Future<BookDownload?> bookById(String id) async {
    final db = await database;

    final data = await db.query(
      _bookTable,
      where: 'bookId = ?',
      whereArgs: [id],
      limit: 1,
    );

    return data.isEmpty ? null : BookDownload.fromMap(data.first);
  }

  Future<List<Chapter>> chaptersByBookId(String bookId) async {
    final db = await database;

    final items = await db.query(
      _chapterTable,
      where: 'bookId = ?',
      whereArgs: [bookId],
    );

    final chapters = <Chapter>[];

    for (Map<String, Object?> item in items) {
      chapters.add(Chapter.fromMap(item));
    }

    chapters.sort((a, b) => compareNatural(b.name, a.name));
    return chapters;
  }

  Future<Content?> content(String bookId, String chapterId, int index) async {
    final db = await database;

    final items = await db.query(
      _contentTable,
      where: 'bookId = ? AND chapterId = ?',
      whereArgs: [bookId, chapterId],
      limit: 1,
    );

    if (items.isEmpty) return null;

    final data = ContentDownloaded.fromMap(items.first);

    List<String>? sources;
    String? text;

    try {
      final List<dynamic> decodedSources = jsonDecode(data.content);

      Directory? storageDir = await getExternalStorageDirectory();
      storageDir ??= await getTemporaryDirectory();

      final chapterDir = Directory('${storageDir.path}/$bookId/$chapterId');

      if (!chapterDir.existsSync()) {
        await _deleteChapter(db: db, bookId: bookId, chapterId: chapterId);
        return null;
      }

      sources = [];
      for (String src in decodedSources) {
        final file = File(src);

        if (file.existsSync()) {
          final bytes = await File(src).readAsBytes();
          sources.add('data:image/*;base64,${base64.encode(bytes)}');
        }
      }
    } catch (_) {}

    if (sources == null) text = data.content;

    return Content(
      id: data.chapterId,
      name: data.name,
      index: index,
      bookId: bookId,
      sources: sources,
      text: text,
    );
  }

  // ----------------------- INSERTS / UPDATE -----------------------

  Future<int> upsertBook(BookDownload book) async {
    final db = await database;

    final bookExists = await db.query(
      _bookTable,
      where: 'bookId = ?',
      whereArgs: [book.id],
      limit: 1,
    );

    if (bookExists.isNotEmpty) {
      return await db.update(
        _bookTable,
        book.toMap(),
        where: 'bookId = ?',
        whereArgs: [book.id],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    return await db.insert(
      _bookTable,
      book.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int?> insertChapter(Chapter chapter) async {
    final db = await database;

    final chapterExists = await db.query(
      _chapterTable,
      where: 'bookId = ? AND chapterId = ?',
      whereArgs: [chapter.bookId, chapter.id],
      limit: 1,
    );

    if (chapterExists.isNotEmpty) return null;

    final Map<String, Object?> data = {
      ...chapter.toMap(),
      'chapterId': chapter.id,
      'finished': 0,
    };

    if (chapterExists.isNotEmpty) {
      return await db.update(
        _chapterTable,
        data,
        where: 'bookId = ? AND chapterId = ?',
        whereArgs: [chapter.bookId, chapter.id],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    return await db.insert(
      _chapterTable,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> insertContent(ContentDownloaded content) async {
    final db = await database;

    await db.update(
      _chapterTable,
      {
        'finished': 1,
      },
      where: 'bookId = ? AND chapterId = ?',
      whereArgs: [content.bookId, content.chapterId],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return await db.insert(
      _contentTable,
      content.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ----------------------- DELETE -----------------------
  Future<void> deleteChapter(Chapter chapter) async {
    final db = await database;

    await db.delete(
      _chapterTable,
      where: 'bookId = ? AND chapterId = ?',
      whereArgs: [chapter.bookId, chapter.id],
    );

    await db.delete(
      _contentTable,
      where: 'bookId = ? AND chapterId = ?',
      whereArgs: [chapter.bookId, chapter.id],
    );
  }

  Future<void> _deleteChapter({
    required Database db,
    required String bookId,
    required String chapterId,
  }) async {
    await db.delete(
      _chapterTable,
      where: 'bookId = ? AND chapterId = ?',
      whereArgs: [bookId, chapterId],
    );

    await db.delete(
      _contentTable,
      where: 'bookId = ? AND chapterId = ?',
      whereArgs: [bookId, chapterId],
    );
  }
}

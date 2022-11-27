part of 'scan.repository.dart';

class MangaLivreRepository extends ScanRepositoryBase {
  @override
  final String baseURL = 'https://mangalivre.net';

  MangaLivreRepository() {
    _cache = DioCache(url: baseURL);
    _dio = Dio()..interceptors.add(_cache.cache.interceptor);
  }

  @override
  Future<List<Book>> lastAdded() async {
    final url = "$baseURL/home/releases?page=1&type=";
    final books = <Book>[];

    _updateCache(url);

    try {
      final response = await _dio.get(url, options: _cache.cacheOptions);
      final data = response.data['releases'];

      for (final item in data) {
        books.add(Book(
          url: "$baseURL${item['link']}",
          name: item['name'],
          scan: Scans.MANGA_LIVRE,
          imageURL: item['image_thumb'],
          imageURL2: item['image'],
          serieId: item['id_serie'],
        ));
      }

      return books;
    } catch (_) {
      return books;
    }
  }

  @override
  Future<List<Book>> search(String value) async {
    final books = <Book>[];

    const subKey = '/lib/search/series.json';
    final url = '$baseURL$subKey';

    _updateCache(url, subKey: subKey);

    final cache = DioCache(
      url: url,
      subKey: subKey,
      options: Options(headers: {"x-requested-with": "XMLHttpRequest"}),
    );

    final data = FormData.fromMap({'search': value});
    final response = await _dio.post(
      url,
      data: data,
      options: cache.cacheOptions,
    );

    for (final item in response.data['series']) {
      books.add(Book(
        url: "$baseURL${item['link']}",
        name: item['name'].toString().trim(),
        scan: Scans.MANGA_LIVRE,
        imageURL: item['cover_thumb'],
        imageURL2: item['cover'],
        serieId: item['id_serie'],
      ));
    }

    return books;
  }

  @override
  Future<BookData> data(Book book) async {
    _updateCache(book.url, subKey: book.url);

    final response = await _dio.get(book.url, options: _cache.cacheOptions);
    final $ = parse(response.data);

    // Categories ----------------------------------------------

    final categories = <String>[];

    $.querySelectorAll('.series-info li a span.button').forEach((element) {
      final category = element.text.trim();
      if (category.isNotEmpty) categories.add(category);
    });

    // Sinopse -------------------------------------------------

    final sinopse = $.querySelector('#series-data .series-desc')?.text.trim();

    // Chapters ------------------------------------------------

    final chapters = <Chapter>[];

    final total = $.querySelector('.container-box h2 span')?.text.trim() ?? '1';

    await Future.wait(
      List.generate((int.parse(total) / 30).ceil(), (index) async {
        final page = index + 1;

        final baseChapterUrl = '$baseURL/series/chapters_list.json';
        final subKey = '?page=$page&id_serie=${book.serieId}';
        final url = '$baseChapterUrl$subKey';

        final cache = DioCache(
          url: url,
          subKey: subKey,
          options: Options(headers: {"x-requested-with": "XMLHttpRequest"}),
        );

        final response = await _dio.get(url, options: cache.cacheOptions);

        for (final chapter in response.data['chapters']) {
          final release = Map.from(chapter['releases']).values.first;

          chapters.add(Chapter(
            url: '$baseURL${release['link']}',
            name: 'Cap. ${chapter['number']}',
            bookId: book.id,
            secondaryId: release['id_release'],
          ));
        }

        return null;
      }),
    );

    return BookData(
      categories: categories,
      chapters: chapters,
      sinopse: sinopse ?? '',
      type: book.type,
    );
  }

  @override
  Future<Content> content(Chapter chapter, int index) async {
    _updateCache(chapter.url, subKey: chapter.url);

    Response<dynamic> response = await _dio.get(
      chapter.url,
      options: _cache.cacheOptions,
    );

    final exp = RegExp(r'(this\.page\.identifier = ".*?")');
    final matches = exp.allMatches(response.data);
    String key = '';

    for (final RegExpMatch m in matches) {
      key = m[0]
          .toString()
          .replaceAll('this.page.identifier = ', '')
          .replaceAll('"', '')
          .trim();
    }

    final baseContentURL = '$baseURL/leitor/pages/${chapter.secondaryId}.json';
    final subKey = '?key=$key';
    final url = '$baseContentURL$subKey';

    final cache = DioCache(
      url: url,
      subKey: subKey,
      options: Options(headers: {"x-requested-with": "XMLHttpRequest"}),
    );

    final sources = <String>[];
    response = await _dio.get(url, options: cache.cacheOptions);

    for (final img in response.data['images']) {
      sources.add(img['legacy'] ?? img['avif']);
    }

    return Content(
      id: chapter.id,
      index: index,
      name: chapter.name,
      sources: sources,
      bookId: chapter.bookId,
    );
  }
}

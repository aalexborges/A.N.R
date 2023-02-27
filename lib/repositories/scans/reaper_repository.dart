part of '../scan_base_repository.dart';

class ReaperRepository extends ScanBaseRepository {
  ReaperRepository();

  Scan get scan => Scan.reaper;

  @override
  List<String> get baseURLs => ['https://reaperscans.net'];
  String get apiBaseURL => 'https://api.reaperscans.net';

  @override
  Future<List<Book>> lastAdded() {
    return _tryWithAllBaseUrls<List<Book>>(
      defaultValue: List.empty(),
      callback: (baseURL) async {
        final books = <Book>[];

        final response = await dio.get(baseURL);
        final $ = parse(response.data);

        for (Element element in $.querySelectorAll('.grid.grid-cols-2 > div')) {
          final scraping = ScrapingUtil(element);

          final src = scraping.getSrc(selector: 'img');
          final path = scraping.getURL(selector: 'a');
          final name = scraping.getByText(selector: 'h5');
          final type = scraping.getByText(selector: 'span');

          if (ScrapingUtil.hasEmptyOrNull([src, path, name])) continue;

          books.add(Book(
            src: src!,
            name: name,
            path: path,
            scan: scan,
            type: type.isEmpty ? null : type,
          ));
        }

        return books;
      },
    );
  }

  @override
  Future<List<Book>> search(String value) async {
    try {
      final books = <Book>[];

      final response = await dio.post('$apiBaseURL/series/search', data: {'term': value});

      for (final item in response.data) {
        final src = item['thumbnail'];
        final name = item['title'];
        final path = item['series_slug'];

        if (ScrapingUtil.hasEmptyOrNull([src, name, path])) continue;

        books.add(Book(src: '$apiBaseURL/$src', name: name, path: '/series/$path', scan: scan));
      }

      return books;
    } catch (e) {
      print(e);
      return List.empty();
    }
  }

  @override
  Future<BookData> data(Book book) async {
    return _tryWithAllBaseUrls<BookData>(
      path: book.path,
      callback: (url) async {
        final response = await dio.get(url);
        final $ = parse(response.data);

        final scanScrapingUtil = ScanScrapingUtil($);
        final categories = scanScrapingUtil.categories(selector: '.tags-container > span');
        final sinopse = scanScrapingUtil.sinopse(selector: '.description-container');

        // Chapters ------------------------------------------------

        final baseURL = _baseByURL(url);
        final chapters = await _chapters(
          items: $.querySelectorAll('.chapters-list-wrapper div span a'),
          transform: (value) => ScrapingUtil(value),
          callback: (item) {
            final path = item.getURL();
            final name = item.getByText(selector: 'li > div > span');

            if (ScrapingUtil.hasEmptyOrNull([path, name])) return null;
            return ChapterBase(name: name, url: baseURL + path, bookSlug: book.slug);
          },
        );

        return BookData(chapters: chapters, sinopse: sinopse, categories: categories, type: book.type);
      },
    );
  }
}

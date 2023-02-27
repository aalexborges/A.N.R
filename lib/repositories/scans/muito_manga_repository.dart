part of '../scan_base_repository.dart';

class MuitoMangaRepository extends ScanBaseRepository {
  MuitoMangaRepository();

  Scan get scan => Scan.muitoManga;

  @override
  List<String> get baseURLs => ['https://muitomanga.com'];

  @override
  Future<List<Book>> lastAdded() {
    return _tryWithAllBaseUrls<List<Book>>(
      defaultValue: List.empty(),
      callback: (baseURL) async {
        final books = <Book>[];

        final response = await dio.get(baseURL);
        final $ = parse(response.data);

        for (Element element in $.querySelectorAll('#loadnews_here > div')) {
          final scraping = ScrapingUtil(element);

          final src = scraping.getSrc(selector: 'img');
          final path = scraping.getURL(selector: 'a');
          final name = scraping.getByAttribute(attribute: 'title', selector: 'img');

          if (scraping.hasEmptyOrNull([src, path, name])) continue;

          books.add(Book(src: src!, name: name, path: path, scan: scan));
        }

        return books;
      },
    );
  }

  @override
  Future<List<Book>> search(String value) {
    return _tryWithAllBaseUrls<List<Book>>(
      defaultValue: List.empty(),
      callback: (baseURL) async {
        final books = <Book>[];

        final url = '$baseURL/buscar?q=$value';
        final response = await dio.get(url);
        final $ = parse(response.data);

        for (Element element in $.querySelectorAll('.content_post > div')) {
          final scraping = ScrapingUtil(element);

          final src = scraping.getSrc(selector: 'img');
          final path = scraping.getURL(selector: 'a');
          final name = scraping.getByAttribute(attribute: 'title', selector: 'img');

          if (scraping.hasEmptyOrNull([src, path, name])) continue;

          books.add(Book(src: src!, name: name, path: path, scan: scan));
        }

        return books;
      },
    );
  }

  @override
  Future<BookData> data(Book book) async {
    return _tryWithAllBaseUrls<BookData>(
      path: book.path,
      callback: (url) async {
        final response = await dio.get(url);
        final $ = parse(response.data);

        final scanScrapingUtil = ScanScrapingUtil($);
        final categories = scanScrapingUtil.categories(selector: 'ul.last-generos-series > li > a');
        final sinopse = scanScrapingUtil.sinopse(selector: '.boxAnimeSobreLast > p');

        // Chapters ------------------------------------------------

        final baseURL = _baseByURL(url);
        final chapters = await _chapters(
          items: $.querySelectorAll('.manga-chapters > div > a'),
          transform: (value) => ScrapingUtil(value),
          callback: (item) {
            final path = item.getURL();
            final name = item.getByText().replaceAll('#', '').trim();

            if (item.hasEmptyOrNull([url, name])) return null;
            return ChapterBase(name: name, url: baseURL + path, bookSlug: book.slug);
          },
        );

        return BookData(chapters: chapters, sinopse: sinopse, categories: categories, type: book.type);
      },
    );
  }
}

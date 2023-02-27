part of '../scan_base_repository.dart';

class MangaHostRepository extends ScanBaseRepository {
  MangaHostRepository();

  Scan get scan => Scan.mangaHost;

  @override
  List<String> get baseURLs => ['https://mangahost4.com', 'https://mangahosted.com', 'https://mangahostz.com'];

  @override
  Future<List<Book>> lastAdded() {
    return _tryWithAllBaseUrls<List<Book>>(
      defaultValue: List.empty(),
      callback: (baseURL) async {
        final books = <Book>[];

        final response = await dio.get(baseURL);
        final $ = parse(response.data);

        for (Element element in $.querySelectorAll('#dados .lejBC.w-row')) {
          final scraping = ScrapingUtil(element);

          final src = scraping.getSrc(selector: 'img') ?? scraping.getSrc(selector: 'source', bySrcSet: true);
          final path = scraping.getURL(selector: 'h4 a');
          final name = scraping.getByText(selector: 'h4 a');

          final is18 = element.querySelector('.age-18') != null;

          if (scraping.hasEmptyOrNull([src, path, name]) || is18) continue;

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

        final url = '$baseURL/find/$value';
        final response = await dio.get(url);
        final $ = parse(response.data);

        for (Element element in $.querySelectorAll('main tr')) {
          final scraping = ScrapingUtil(element);

          final src = scraping.getSrc(selector: 'img') ?? scraping.getSrc(selector: 'source', bySrcSet: true);
          final path = scraping.getURL(selector: 'h4 a');
          final name = scraping.getByText(selector: 'h4 a');

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
      callback: (baseURL) async {
        final response = await dio.get(baseURL);
        final $ = parse(response.data);

        // Categories ----------------------------------------------

        final categories = <String>[];

        $.querySelectorAll('div.tags a.tag').forEach((element) {
          final category = element.text.trim();
          if (category.isNotEmpty) categories.add(category);
        });

        // Type ----------------------------------------------------

        String? type;

        $.querySelectorAll('div.text ul li').forEach((element) {
          final scraping = ScrapingUtil(element);
          final key = scraping.getByText(selector: 'strong').toLowerCase();

          if (key.contains('tipo')) {
            type = scraping.getByText(selector: 'div');
            type = type!.isEmpty ? null : type!.replaceAll('Tipo: ', '').trim();
          }
        });

        type ??= book.type;

        // Sinopse -------------------------------------------------

        final sinopse = $.querySelector('div.text .paragraph')?.text.trim() ?? '';

        // Chapters ------------------------------------------------

        final chapters = await _chapters(
          items: $.querySelectorAll('section div.chapters div.cap'),
          transform: (value) => ScrapingUtil(value),
          callback: (item) {
            final url = item.getURL(selector: '.tags a');
            String name = item.getByText(selector: 'a[rel]');

            if (item.hasEmptyOrNull([url, name])) return null;

            final char = double.tryParse(name);
            name = char != null ? 'Cap. ${name.padLeft(2, '0')}' : name;

            return ChapterBase(name: name, url: url, bookSlug: book.slug);
          },
        );

        return BookData(chapters: chapters, sinopse: sinopse, categories: categories, type: type);
      },
    );
  }

  @override
  Map<String, String>? get headers {
    return {
      'Origin': baseURLs[0],
      'Referer': '${baseURLs[0]}/',
      'accept':
          'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
      'upgrade-insecure-requests': '1',
      'user-agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36',
    };
  }
}

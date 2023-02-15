part of '../scan_base_repository.dart';

class MangaHostRepository extends ScanBaseRepository {
  MangaHostRepository();

  Scan get scan => Scan.mangaHost;

  @override
  List<String> get baseURLs => ['https://mangahost4.com', 'https://mangahosted.com', 'https://mangahostz.com'];

  @override
  Future<List<Book>> lastAdded() {
    return _tryAllURLs<List<Book>>(
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
    return _tryAllURLs<List<Book>>(
      defaultValue: List.empty(),
      callback: (baseURL) async {
        final books = <Book>[];

        final subKey = 'find/$value';
        final url = '$baseURL/$subKey';

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

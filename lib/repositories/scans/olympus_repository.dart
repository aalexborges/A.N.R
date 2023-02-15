part of '../scan_base_repository.dart';

class OlympusRepository extends ScanBaseRepository {
  OlympusRepository();

  Scan get scan => Scan.olympus;

  @override
  List<String> get baseURLs => ['https://br.olympusscanlation.com'];

  @override
  Future<List<Book>> lastAdded() {
    return _tryAllURLs<List<Book>>(
      defaultValue: List.empty(),
      callback: (baseURL) async {
        final books = <Book>[];

        final response = await dio.get(baseURL);
        final $ = parse(response.data);

        for (Element element in $.querySelectorAll('#loop-content .row .page-item-detail')) {
          final scraping = ScrapingUtil(element);

          final src = scraping.getSrc(selector: 'img') ?? scraping.getSrc(selector: 'img', bySrcSet: true);
          final path = scraping.getURL(selector: 'div > a');
          final name = scraping.getByAttribute(attribute: 'title', selector: 'div > a');

          if (scraping.hasEmptyOrNull([src, path, name])) continue;

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

        final subKey = '?s=$value&post_type=wp-manga';
        final url = '$baseURL/$subKey';

        final response = await dio.get(url);
        final $ = parse(response.data);

        for (Element element in $.querySelectorAll('.tab-thumb a')) {
          final scraping = ScrapingUtil(element);

          final src = scraping.getSrc(selector: 'img') ?? scraping.getSrc(selector: 'img', bySrcSet: true);
          final path = scraping.getURL();
          final name = scraping.getByAttribute(attribute: 'title');

          if (scraping.hasEmptyOrNull([src, path, name])) continue;

          books.add(Book(src: src!, name: name, path: path, scan: scan));
        }

        return books;
      },
    );
  }
}

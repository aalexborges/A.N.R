part of '../scan_base_repository.dart';

class MuitoMangaRepository extends ScanBaseRepository {
  MuitoMangaRepository();

  Scan get scan => Scan.muitoManga;

  @override
  List<String> get baseURLs => ['https://muitomanga.com'];

  @override
  Future<List<Book>> lastAdded() {
    return _tryAllURLs<List<Book>>(
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
    return _tryAllURLs<List<Book>>(
      defaultValue: List.empty(),
      callback: (baseURL) async {
        final books = <Book>[];

        final subKey = '?q=$value';
        final url = '$baseURL/buscar$subKey';

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
}

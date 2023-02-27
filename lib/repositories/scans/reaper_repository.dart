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

          if (scraping.hasEmptyOrNull([src, path, name])) continue;

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

      final response = await dio.get('$apiBaseURL/series/search');

      return books;
    } catch (_) {
      return List.empty();
    }
  }
}

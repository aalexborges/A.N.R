part of '../scan_base_repository.dart';

class NeoxRepository extends ScanBaseRepository {
  NeoxRepository();

  Scan get scan => Scan.neox;

  @override
  List<String> get baseURLs => ['https://neoxscans.net'];

  @override
  Future<List<Book>> lastAdded() {
    return _tryAllURLs<List<Book>>(
      defaultValue: List.empty(),
      callback: (baseURL) async {
        final books = <Book>[];

        final response = await dio.get(baseURL);
        final $ = parse(response.data);

        for (Element element in $.querySelectorAll('#loop-content .row div.page-item-detail')) {
          final scraping = ScrapingUtil(element);

          final src = scraping.getSrc(selector: 'img') ?? scraping.getSrc(selector: 'img', bySrcSet: true);
          final path = scraping.getURL(selector: 'h3 a');
          final name = scraping.getByText(selector: 'h3 a');
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
  Future<List<Book>> search(String value) {
    return _tryAllURLs<List<Book>>(
      defaultValue: List.empty(),
      callback: (baseURL) async {
        final books = <Book>[];

        final subKey = '?s=$value&post_type=wp-manga';
        final url = '$baseURL/$subKey';

        final response = await dio.get(url);
        final $ = parse(response.data);

        for (Element element in $.querySelectorAll('.c-tabs-item div.row')) {
          final scraping = ScrapingUtil(element);

          final src = scraping.getSrc(selector: 'img') ?? scraping.getSrc(selector: 'img', bySrcSet: true);
          final path = scraping.getURL(selector: 'h3 a');
          final name = scraping.getByText(selector: 'h3 a');

          if (scraping.hasEmptyOrNull([src, path, name])) continue;

          books.add(Book(src: src!, name: name, path: path, scan: scan));
        }

        return books;
      },
    );
  }

  @override
  Future<BookData> data(Book book) async {
    return _tryAllURLs<BookData>(
      callback: (baseURL) async {
        final response = await dio.get(book.path);
        final $ = parse(response.data);

        // Categories ----------------------------------------------

        final categories = <String>[];

        $.querySelectorAll('.genres-content a').forEach((element) {
          final category = element.text.trim();
          if (category.isNotEmpty) categories.add(category);
        });

        // Type ----------------------------------------------------

        String? type;

        $.querySelectorAll('.post-content_item').forEach((element) {
          final scraping = ScrapingUtil(element);
          final key = scraping.getByText(selector: 'h5').toLowerCase();

          if (key == 'tipo') type = scraping.getByText(selector: '.summary-content');
        });

        type ??= book.type;

        // Sinopse -------------------------------------------------

        final sinopse = $.querySelector('.manga-excerpt')?.text.trim() ?? '';

        return BookData(chapters: List.empty(), sinopse: sinopse, categories: categories);
      },
    );
  }
}

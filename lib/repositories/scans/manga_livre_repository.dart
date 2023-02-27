part of '../scan_base_repository.dart';

class MangaLivreRepository extends ScanBaseRepository {
  MangaLivreRepository();

  Scan get scan => Scan.mangaLivre;

  @override
  List<String> get baseURLs => ['https://mangalivre.net'];

  @override
  Future<List<Book>> lastAdded() {
    return _tryWithAllBaseUrls<List<Book>>(
      defaultValue: List.empty(),
      callback: (baseURL) async {
        final books = <Book>[];

        final response = await dio.get('$baseURL/home/releases?page=1&type=');
        final data = response.data['releases'] ?? [];

        for (final item in data) {
          books.add(Book(
            src: item['image_thumb'] ?? item['image'],
            name: item['name'].toString().trim(),
            path: item['link'],
            scan: scan,
            webID: item['id_serie'],
          ));
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

        final url = '$baseURL/lib/search/series.json';
        final requestOptions = Options(headers: {"x-requested-with": "XMLHttpRequest"});
        final requestData = FormData.fromMap({'search': value});
        final response = await dio.post(url, data: requestData, options: requestOptions);
        final data = response.data['series'] ?? [];

        for (final item in data) {
          books.add(Book(
            src: item['image_thumb'] ?? item['image'],
            name: item['name'].toString().trim(),
            path: item['link'],
            scan: scan,
            webID: item['id_serie'],
          ));
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
        final categories = scanScrapingUtil.categories(selector: '.series-info li a span.button');
        final sinopse = scanScrapingUtil.sinopse(selector: '#series-data .series-desc');

        // Chapters ------------------------------------------------

        final baseURL = _baseByURL(url);
        final pageChapters = [];
        final totalChaptersPage = $.querySelector('.container-box h2 span')?.text.trim() ?? '1';

        await Future.wait(List.generate((int.parse(totalChaptersPage) / 30).ceil(), (index) async {
          final page = index + 1;
          final baseChapterUrl = '$baseURL/series/chapters_list.json';
          final chapterUrl = '$baseChapterUrl?page=$page&id_serie=${book.webID}';

          final requestOptions = Options(headers: {"x-requested-with": "XMLHttpRequest"});
          final response = await dio.get(chapterUrl, options: requestOptions);

          pageChapters.addAll(response.data['chapters']);
        }));

        final chapters = await _chapters<dynamic, dynamic>(
          items: pageChapters,
          callback: (item) {
            final release = Map.from(item['releases']).values.first;

            return ChapterBase(
              url: '$baseURL${release['link']}',
              name: 'Cap. ${item['number']}',
              webId: release['id_release'].toString(),
              bookSlug: book.slug,
            );
          },
        );

        return BookData(chapters: chapters, sinopse: sinopse, categories: categories, type: book.type);
      },
    );
  }
}

part of '../scan_base_repository.dart';

class MangaLivreRepository extends ScanBaseRepository {
  MangaLivreRepository();

  Scan get scan => Scan.mangaLivre;

  @override
  List<String> get baseURLs => ['https://mangalivre.net'];

  @override
  Future<List<Book>> lastAdded() {
    return _tryAllURLs<List<Book>>(
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
    return _tryAllURLs<List<Book>>(
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
}

part of '../scan_base_repository.dart';

class ModeRepository extends ScanBaseRepository {
  ModeRepository();

  Scan get scan => Scan.mode;

  @override
  List<String> get baseURLs => ['https://modescanlator.com'];

  @override
  Future<List<Book>> lastAdded() {
    return _tryWithAllBaseUrls(
      defaultValue: List.empty(),
      callback: (baseURL) async {
        final books = <Book>[];

        final response = await dio.get(baseURL);
        final $ = parse(response.data);

        for (Element element in $.querySelectorAll('.postbody .listupd a')) {
          final scraping = ScrapingUtil(element);

          final src = scraping.getSrc(selector: 'img');
          final path = scraping.getURL().replaceAll(RegExp(r'(-capitulo-.*)'), '');
          final name = scraping.getByText(selector: '.tt');
          final type = scraping.getByText(selector: '.typename');

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
  Future<List<Book>> search(String value) {
    return _tryWithAllBaseUrls<List<Book>>(
      defaultValue: List.empty(),
      callback: (baseURL) async {
        final books = <Book>[];

        final url = '$baseURL/?s=$value';
        final response = await dio.get(url);
        final $ = parse(response.data);

        for (Element element in $.querySelectorAll('.postbody .listupd a')) {
          final scraping = ScrapingUtil(element);

          final src = scraping.getSrc(selector: 'img');
          final path = scraping.getURL();
          final name = scraping.getByText(selector: '.tt');
          final type = scraping.getByText(selector: '.typename');

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
  Future<BookData> data(Book book) async {
    return _tryWithAllBaseUrls<BookData>(
      path: book.path,
      callback: (baseURL) async {
        print(baseURL);
        final response = await dio.get(baseURL);
        final $ = parse(response.data);

        final scanScrapingUtil = ScanScrapingUtil($);
        final categories = scanScrapingUtil.categories(selector: '.seriestugenre a');
        final sinopse = scanScrapingUtil.sinopse(selector: '.entry-content');
        final type = scanScrapingUtil.type(alternativeType: book.type);

        // Chapters ------------------------------------------------

        final chapters = await _chapters(
          items: $.querySelectorAll('#chapterlist > ul li a'),
          transform: (value) => ScrapingUtil(value),
          callback: (item) {
            final url = item.getURL();
            final name = item.getByText(selector: '.chapternum');

            if (ScrapingUtil.hasEmptyOrNull([url, name])) return null;
            return ChapterBase(name: name, url: url, bookSlug: book.slug);
          },
        );

        return BookData(chapters: chapters, sinopse: sinopse, categories: categories, type: type);
      },
    );
  }

  @override
  Future<Content> content(Chapter chapter) async {
    return await _tryWithAllBaseUrls<Content>(
      path: chapter.url,
      callback: (url) async {
        final response = await dio.get(url);
        final replacedData = response.data.toString().replaceAll(RegExp(r'(<(\/?)noscript>)'), '');
        final $ = parse(replacedData);

        final key = widget.GlobalObjectKey(chapter.id);
        final sources = <String>[];

        for (final img in $.querySelectorAll('#readerarea img')) {
          final src = ScrapingUtil(img).getSrc();
          if (ScrapingUtil.hasEmptyOrNull([src])) continue;

          sources.add(src!);
        }

        return Content(key: key, chapter: chapter, items: sources);
      },
    );
  }
}

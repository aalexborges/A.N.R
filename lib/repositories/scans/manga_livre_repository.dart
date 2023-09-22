part of 'package:anr/repositories/scans/scan_base_repository.dart';

class MangaLivreRepository extends ScanBaseRepository {
  static final MangaLivreRepository instance = MangaLivreRepository._internal();
  factory MangaLivreRepository() => instance;

  MangaLivreRepository._internal();

  final baseURL = Uri.parse('https://mangalivre.net');
  final scan = Scan.mangaLivre;

  @override
  Future<List<Book>> lastAdded({bool forceUpdate = false}) async {
    final url = baseURL.replace(path: '/home/releases', query: 'page=1&type=');
    final response = await httpRepository.get(url, forceUpdate: forceUpdate);

    final items = <Book>[];
    final data = jsonDecode(response.body);

    for (final item in data['releases'] ?? List.empty(growable: false)) {
      final src = item['image_thumb'] ?? item['image'];

      if (src.contains('blurred')) continue;

      items.add(Book(
        src: item['image_thumb'] ?? item['image'],
        name: item['name'].toString().trim(),
        path: item['link'],
        scan: scan,
        webID: item['id_serie'],
      ));
    }

    return items;
  }

  @override
  Future<List<Book>> search(String value, {bool forceUpdate = false}) async {
    final url = baseURL.replace(path: '/lib/search/series.json');
    final response = await httpRepository.post(
      url,
      body: {'search': value},
      headers: {"x-requested-with": "XMLHttpRequest"},
      forceUpdate: forceUpdate,
    );

    final items = <Book>[];
    final data = jsonDecode(response.body);

    for (final item in data['series'] ?? List.empty(growable: false)) {
      items.add(Book(
        src: item['image_thumb'] ?? item['image'] ?? item['cover_thumb'] ?? item['cover'],
        name: item['name'].toString().trim(),
        path: item['link'],
        scan: scan,
        webID: item['id_serie'],
      ));
    }

    return items;
  }

  @override
  Future<BookData> data(Book book, {bool forceUpdate = false}) async {
    final url = baseURL.replace(path: book.path);
    final response = await httpRepository.get(url, forceUpdate: forceUpdate);
    final document = parse(response.body);
    final element = document.body;

    if (element is! Element) throw Exception('Invalid document body');

    final categories = ScrapingUtil.getCategories(element: element, selector: '.series-info li a span.button');
    final sinopse = ScrapingUtil.getSinopse(element: element, selector: '#series-data .series-desc > span');

    final pageChapters = [];
    final totalChaptersPage = element.querySelector('.container-box h2 span')?.text.trim() ?? '1';

    await Future.wait(List.generate((int.parse(totalChaptersPage) / 30).ceil(), (index) async {
      final page = index + 1;
      final chapterUrl = '$baseURL/series/chapters_list.json?page=$page&id_serie=${book.webID}';
      final chapterResponse = await httpRepository.get(
        Uri.parse(chapterUrl),
        headers: {"x-requested-with": "XMLHttpRequest"},
        forceUpdate: forceUpdate,
      );

      final data = jsonDecode(chapterResponse.body);
      pageChapters.addAll(data['chapters']);
    }));

    final chapters = <Chapter>[];

    for (final item in pageChapters) {
      final release = Map.from(item['releases']).values.first;
      final name = 'Cap. ${item['number']}';

      chapters.add(Chapter(
        id: Chapter.idByName(name),
        url: '$baseURL${release['link']}',
        name: name,
        webId: book.webID,
      ));
    }

    chapters.sort((a, b) => b.id.compareTo(a.id));
    return BookData(sinopse: sinopse, categories: categories, book: book, chapters: chapters);
  }

  @override
  Future<Content> content(Chapter chapter) async {
    final response = await httpRepository.get(Uri.parse(chapter.url));

    final idMatches = RegExp(r'''window\.READER_ID_RELEASE = ('.*?'|".*?")''').allMatches(response.body);
    final tokenMatches = RegExp(r'''window\.READER_TOKEN = ('.*?'|".*?")''').allMatches(response.body);

    final chapterId = _byMatches(idMatches);
    final chapterKey = _byMatches(tokenMatches);

    final url = baseURL.replace(path: '/leitor/pages/$chapterId.json?key=$chapterKey');
    final data = await httpRepository.get(url);

    final key = widget.GlobalObjectKey('${chapter.id}-${DateTime.now().millisecondsSinceEpoch}');
    final images = <String>[];

    for (final image in jsonDecode(data.body)['images']) {
      images.add(image['legacy'] ?? image['avif']);
    }

    return Content(key: key, title: chapter.name, images: images);
  }

  String _byMatches(Iterable<RegExpMatch> matches) {
    return (matches.first.group(1) ?? '').replaceAll(RegExp(r'''['"]'''), '').trim();
  }
}

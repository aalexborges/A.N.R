part of 'package:anr/repositories/scans/scan_base_repository.dart';

class ArgoRepository extends ScanBaseRepository {
  static final ArgoRepository instance = ArgoRepository._internal();
  factory ArgoRepository() => instance;

  ArgoRepository._internal();

  final baseURL = Uri.parse('https://argosscan.com');
  final scan = Scan.argo;

  @override
  Future<List<Book>> lastAdded({bool forceUpdate = false}) async {
    final response = await httpRepository.post(
      baseURL.replace(path: '/graphql'),
      body: jsonEncode(ArgoGraphQLBody.lastAdded),
      forceUpdate: forceUpdate,
      headers: {'Content-Type': 'application/json; charset=utf-8'},
    );

    final items = <Book>[];
    final responseDecode = jsonDecode(response.body);
    final chapters = responseDecode['data']['getChapters']['chapters'];

    for (final chapter in chapters) {
      final project = chapter['project'];
      final adult = project['adult'];

      if (adult is bool && adult) continue;

      final cover = project['cover'];
      final name = project['name'];
      final id = project['id'];

      items.add(Book(
        name: name,
        path: baseURL.replace(path: '/obras/$id/${slugify(name)}').toString(),
        src: baseURL.replace(path: '/images/$id/$cover').toString(),
        scan: scan,
        type: project['type'],
        webID: id,
      ));
    }

    return items.fold([], (pv, element) {
      final previousValue = pv as List<Book>;

      if (previousValue.indexWhere((e) => e.name == element.name) < 0) previousValue.add(element);
      return previousValue;
    });
  }

  @override
  Future<List<Book>> search(String value, {bool forceUpdate = false}) async {
    final response = await httpRepository.post(
      baseURL.replace(path: '/graphql'),
      body: jsonEncode(ArgoGraphQLBody.search(value)),
      forceUpdate: forceUpdate,
      headers: {'Content-Type': 'application/json; charset=utf-8'},
      key: value,
    );

    final responseDecode = jsonDecode(response.body);
    final projects = responseDecode['data']['getProjects']['projects'];

    if (projects is! List) return super.search(value);

    final books = <Book>[];

    for (final project in projects) {
      final adult = project['adult'];

      if (adult is bool && adult) continue;

      final cover = project['cover'];
      final name = project['name'];
      final id = project['id'];

      books.add(Book(
        name: name,
        path: baseURL.replace(path: '/obras/$id/${slugify(name)}').toString(),
        src: baseURL.replace(path: '/images/$id/$cover').toString(),
        scan: scan,
        type: project['type'],
        webID: id,
      ));
    }

    return books;
  }

  @override
  Future<BookData> data(Book book, {bool forceUpdate = false}) async {
    if (book.webID is! int) return super.data(book);

    final response = await httpRepository.post(
      baseURL.replace(path: '/graphql'),
      body: jsonEncode(ArgoGraphQLBody.data(book.webID!)),
      forceUpdate: forceUpdate,
      headers: {'Content-Type': 'application/json; charset=utf-8'},
    );

    final responseDecode = jsonDecode(response.body);
    final project = responseDecode['data']['project'];

    final tags = project['getTags'];
    final getChapters = project['getChapters'];

    final categories = <String>[];
    final chapters = <Chapter>[];

    if (tags is List) {
      for (final tag in tags) {
        final name = tag['name'];
        if (name is String && name.isNotEmpty) categories.add(name);
      }
    }

    if (getChapters is List) {
      for (final chapter in getChapters) {
        chapters.add(Chapter(
          id: Chapter.idByName(chapter['number'].toString()),
          url: chapter['id'],
          name: chapter['title'],
        ));
      }
    }

    return BookData(book: book, sinopse: project['description'], chapters: chapters, categories: categories);
  }

  @override
  Future<Content> content(Chapter chapter) async {
    final response = await httpRepository.post(
      baseURL.replace(path: '/graphql'),
      body: jsonEncode(ArgoGraphQLBody.content(chapter.url)),
      headers: {'Content-Type': 'application/json; charset=utf-8'},
    );

    final responseDecode = jsonDecode(response.body);

    final chapters = responseDecode['data']['getChapters']['chapters'];

    if (chapters is List && chapters.isNotEmpty) {
      final chapter = chapters.first;

      final id = chapter['project']['id'];
      final content = chapter['images'];
      final images = <String>[];

      if (content is List && content.isNotEmpty) {
        for (final image in content) {
          images.add(baseURL.replace(path: '/images/$id/$image').toString());
        }
      }

      final key = widget.GlobalObjectKey('$id-${DateTime.now().millisecondsSinceEpoch}');

      return Content(key: key, title: chapter['title'], images: images);
    }

    return super.content(chapter);
  }
}

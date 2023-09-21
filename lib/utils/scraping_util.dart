import 'package:anr/models/book.dart';
import 'package:anr/models/book_data.dart';
import 'package:anr/models/chapter.dart';
import 'package:anr/models/scan.dart';
import 'package:html/dom.dart';

class ScrapingUtil {
  static Element? querySelector(String selector, {required Element element}) {
    return element.querySelector(selector);
  }

  static String? getAttribute({required String attribute, required Element element, String? selector}) {
    final element_ = selector is String ? querySelector(selector, element: element) : element;
    return element_?.attributes[attribute]?.trim();
  }

  static String getText({String? selector, required Element element}) {
    final element_ = selector is String ? querySelector(selector, element: element) : element;
    return element_?.text.trim() ?? '';
  }

  static String? getURL({String? selector, required Element element}) {
    return getAttribute(attribute: 'href', element: element, selector: selector);
  }

  static String? getImageSource({String? selector, bool? noSrcSet, required Element element}) {
    final element_ = selector is String ? querySelector(selector, element: element) : element;

    if (element_ is! Element) return null;

    String? source;

    source ??= getAttribute(attribute: 'data-lazy-srcset', element: element_);
    source ??= getAttribute(attribute: 'data-srcset', element: element_);
    source ??= getAttribute(attribute: 'srcset', element: element_);

    if (source is String && !source.contains('no-cover.png')) return _bySrcSet(source.trim());

    source ??= getAttribute(attribute: 'data-src', element: element_);
    source ??= getAttribute(attribute: 'src', element: element_);

    if (source is String && !source.contains('no-cover.png')) return source.trim();
    return null;
  }

  static String _bySrcSet(String src) {
    final sources = '$src,'.replaceAll(RegExp(r'([1-9])\w+,'), '').trim().split(' ');
    return sources.where((value) => value.length > 3).first.trim();
  }

  static List<Book> genericLastAdd({required Document document, required Scan scan}) {
    final items = <Book>[];

    for (final element in document.querySelectorAll('#loop-content .row div.page-item-detail')) {
      final name = getText(element: element, selector: 'h3 a');
      final type = typeByScan(element: element, scan: scan);

      final path = getURL(element: element, selector: 'h3 a') ?? '';
      final source = getImageSource(element: element, selector: 'img') ?? '';

      if (name.isEmpty || path.isEmpty || source.isEmpty) continue;

      items.add(Book(name: name, path: path, src: source, type: type, scan: scan));
    }

    return items;
  }

  static List<Book> genericSearch({required Document document, required Scan scan}) {
    final items = <Book>[];

    for (final element in document.querySelectorAll('.c-tabs-item div.row')) {
      final name = getText(element: element, selector: 'h3 a');
      final type = typeByScan(element: element, scan: scan);

      final path = getURL(element: element, selector: 'h3 a') ?? '';
      final source = getImageSource(element: element, selector: 'img') ?? '';

      if (name.isEmpty || path.isEmpty || source.isEmpty) continue;

      items.add(Book(name: name, path: path, src: source, type: type, scan: scan));
    }

    return items;
  }

  static BookData genericData({required Document document, required Book book, Document? chapterDocument}) {
    final element = document.body;

    if (element is! Element) throw Exception('Invalid document body');

    final sinopse = getSinopse(element: element);
    final categories = getCategories(element: element);
    final type = book.type ?? getTypeByTable(element);

    final chapters = <Chapter>[];
    final chapterDoc = chapterDocument is Document ? chapterDocument : document;

    for (final element in chapterDoc.querySelectorAll('.main li.wp-manga-chapter > a')) {
      final url = getURL(element: element) ?? '';
      final name = getText(element: element);

      if (url.isEmpty && name.isNotEmpty) continue;

      chapters.add(Chapter(
        id: Chapter.idByName(name),
        url: url,
        name: name,
        bookSlug: book.slug,
        webId: book.webID,
      ));
    }

    chapters.sort((a, b) => b.id.compareTo(a.id));
    return BookData(sinopse: sinopse, categories: categories, book: book, chapters: chapters, type: type);
  }

  static String getSinopse({required Element element, String? selector}) {
    return element.querySelector(selector ?? '.manga-excerpt')?.text.trim() ?? '';
  }

  static List<String> getCategories({required Element element, String? selector}) {
    final items = element.querySelectorAll(selector ?? '.genres-content a').map((e) => e.text.trim());
    return items.where((item) => item.isNotEmpty).toList();
  }

  static String? getTypeByTable(Element element, {String? selector, String? keySelector, String? valueSelector}) {
    for (final item in element.querySelectorAll(selector ?? '.post-content_item')) {
      final key = getText(element: item, selector: keySelector ?? 'h5').toLowerCase();

      if (key.contains('tipo') || key.contains('type')) {
        final type = getText(element: item, selector: valueSelector ?? '.summary-content');

        if (type.isNotEmpty) return type;
      }
    }

    return null;
  }

  static String? typeByScan({required Element element, required Scan scan}) {
    if (scan == Scan.neox) return getText(element: element, selector: 'span');
    if (scan == Scan.hunters) return getText(element: element, selector: 'span.manga-type');
    if (scan == Scan.glorious) return getText(element: element, selector: 'span');

    return null;
  }
}

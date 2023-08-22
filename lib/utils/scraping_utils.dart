import 'package:anr/models/book_item.dart';
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

  static List<BookItem> genericLastAdd({required Document document, required Scan scan}) {
    final items = <BookItem>[];

    for (final element in document.querySelectorAll('#loop-content .row div.page-item-detail')) {
      final name = getText(element: element, selector: 'h3 a');
      final type = _typeByScan(element: element, scan: scan);

      final path = getURL(element: element, selector: 'h3 a') ?? '';
      final source = getImageSource(element: element, selector: 'img') ?? '';

      if (name.isEmpty || path.isEmpty || source.isEmpty) continue;

      items.add(BookItem(name: name, path: path, src: source, type: type, scan: scan));
    }

    return items;
  }

  static List<BookItem> genericSearch({required Document document, required Scan scan}) {
    final items = <BookItem>[];

    for (final element in document.querySelectorAll('.c-tabs-item div.row')) {
      final name = getText(element: element, selector: 'h3 a');
      final type = _typeByScan(element: element, scan: scan);

      final path = getURL(element: element, selector: 'h3 a') ?? '';
      final source = getImageSource(element: element, selector: 'img') ?? '';

      if (name.isEmpty || path.isEmpty || source.isEmpty) continue;

      items.add(BookItem(name: name, path: path, src: source, type: type, scan: scan));
    }

    return items;
  }

  static String? _typeByScan({required Element element, required Scan scan}) {
    if (scan == Scan.neox) return getText(element: element, selector: 'span');
    if (scan == Scan.hunters) return getText(element: element, selector: 'span.manga-type');

    return null;
  }
}

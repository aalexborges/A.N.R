import 'package:html/dom.dart';

class ScrapingUtil {
  static Element? querySelector(String selector, {required Element element}) {
    return element.querySelector(selector);
  }

  static String? getAttribute({required String attribute, required Element element, String? selector}) {
    final element_ = selector is String ? ScrapingUtil.querySelector(selector, element: element) : element;
    return element_?.attributes[attribute]?.trim();
  }

  static String getText({String? selector, required Element element}) {
    final element_ = selector is String ? ScrapingUtil.querySelector(selector, element: element) : element;
    return element_?.text.trim() ?? '';
  }

  static String? getURL({String? selector, required Element element}) {
    return ScrapingUtil.getAttribute(attribute: 'href', element: element, selector: selector);
  }

  static String? getImageSource({String? selector, bool? noSrcSet, required Element element}) {
    final element_ = selector is String ? ScrapingUtil.querySelector(selector, element: element) : element;

    if (element_ is! Element) return null;

    String? source;

    source ??= ScrapingUtil.getAttribute(attribute: 'data-lazy-srcset', element: element_);
    source ??= ScrapingUtil.getAttribute(attribute: 'data-srcset', element: element_);
    source ??= ScrapingUtil.getAttribute(attribute: 'srcset', element: element_);

    if (source is String && !source.contains('no-cover.png')) return source.trim();

    source ??= ScrapingUtil.getAttribute(attribute: 'data-src', element: element_);
    source ??= ScrapingUtil.getAttribute(attribute: 'src', element: element_);

    if (source is String && !source.contains('no-cover.png')) return ScrapingUtil._bySrcSet(source.trim());
    return null;
  }

  static String _bySrcSet(String src) {
    final sources = '$src,'.replaceAll(RegExp(r'([1-9])\w+,'), '').trim().split(' ');
    return sources.where((value) => value.length > 3).last.trim();
  }
}

import 'package:anr/models/book.dart';
import 'package:anr/models/chapter.dart';
import 'package:anr/models/order.dart';

class Content {
  const Content({required this.book, required this.chapters, required this.startAt});

  final Book book;
  final List<Chapter> chapters;
  final int startAt;

  static int startByOrder(int startAt, Order order, int chaptersLength) {
    return order == Order.asc ? chaptersLength - (startAt + 1) : startAt;
  }
}

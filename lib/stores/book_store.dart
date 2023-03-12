import 'package:anr/models/book.dart';
import 'package:anr/models/book_data.dart';
import 'package:anr/models/chapter.dart';
import 'package:anr/models/order.dart';
import 'package:anr/models/scan.dart';
import 'package:mobx/mobx.dart';

part 'book_store.g.dart';

// ignore: library_private_types_in_public_api
class BookStore = _BookStore with _$BookStore;

abstract class _BookStore with Store {
  @observable
  BookData? data;

  @observable
  bool pinnedTitle = false;

  @observable
  Order order = Order.desc;

  @computed
  List<Chapter> get chapters {
    if (data == null) return List.empty();
    if (order == Order.desc) return data!.chapters;

    return List<Chapter>.from(data!.chapters, growable: false).reversed.toList();
  }

  @action
  Future<void> getData(Book book) async {
    data = await book.scan.repository.data(book);
  }

  @action
  void setPinnedTitle(bool value) {
    pinnedTitle = value;
  }

  @action
  void toggleOrder() {
    order = order == Order.desc ? Order.asc : Order.desc;
  }
}

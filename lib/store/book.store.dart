import 'package:A.N.R/constants/order.dart';
import 'package:A.N.R/models/book.model.dart';
import 'package:A.N.R/models/book_data.model.dart';
import 'package:A.N.R/models/chapter.model.dart';
import 'package:A.N.R/repositories/book.repository.dart';
import 'package:mobx/mobx.dart';

part 'book.store.g.dart';

class BookStore = _BookStore with _$BookStore;

abstract class _BookStore with Store {
  @observable
  bool isLoading = true;

  @observable
  bool pinnedTitle = false;

  @observable
  Order order = Order.DESC;

  @observable
  BookData? data;

  @computed
  List<Chapter> get chapters {
    if (data == null) return [];

    if (order == Order.DESC) return data?.chapters ?? [];
    return [...data!.chapters].reversed.toList();
  }

  @action
  Future<void> getData(Book book) async {
    data = await BookRepository.data(book);
    isLoading = false;
  }

  @action
  void setPinnedTitle(bool value) => pinnedTitle = value;

  @action
  void toggleOrder() => order = order == Order.DESC ? Order.ASC : Order.DESC;
}

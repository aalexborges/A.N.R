import 'package:anr/models/book.dart';
import 'package:anr/models/scan.dart';
import 'package:mobx/mobx.dart';

part 'search_store.g.dart';

// ignore: library_private_types_in_public_api
class SearchStore = _SearchStore with _$SearchStore;

abstract class _SearchStore with Store {
  @observable
  Scan scan = Scan.neox;

  @observable
  bool isLoading = false;

  @observable
  ObservableList<Book> results = ObservableList();

  @action
  Future<void> onSearch(String value) async {
    isLoading = true;

    final data = await scan.repository.search(value);

    results = ObservableList()..addAll(data);
    isLoading = false;
  }

  @action
  void setScan(Scan value) {
    scan = value;
  }
}

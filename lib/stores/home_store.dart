import 'package:anr/main.dart';
import 'package:anr/models/book.dart';
import 'package:anr/models/scan.dart';
import 'package:mobx/mobx.dart';

part 'home_store.g.dart';

// ignore: library_private_types_in_public_api
class HomeStore = _Home with _$Home;

abstract class _Home with Store {
  @observable
  bool isLoading = true;

  @observable
  ObservableMap<Scan, List<Book>> lastAdded = ObservableMap();

  @action
  void getLatestBooksAdded(bool loading) async {
    final data = await bookRepository.lastAdded;
    lastAdded = ObservableMap()..addAll(data);

    isLoading = false;
  }
}

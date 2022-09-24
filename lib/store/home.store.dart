import 'package:A.N.R/constants/scans.dart';
import 'package:A.N.R/models/book.model.dart';
import 'package:A.N.R/repositories/book.repository.dart';
import 'package:mobx/mobx.dart';

part 'home.store.g.dart';

class HomeStore = _HomeStore with _$HomeStore;

abstract class _HomeStore with Store {
  @observable
  bool isLoading = true;

  @observable
  ObservableMap<Scans, List<Book>> books = ObservableMap();

  @action
  Future<void> getLatestBooksAdded() async {
    final data = await BookRepository.getLatestBooksAdded();
    books = ObservableMap()..addAll(data);

    isLoading = false;
  }
}

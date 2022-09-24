import 'package:A.N.R/constants/scans.dart';
import 'package:A.N.R/models/book.model.dart';
import 'package:A.N.R/repositories/book.repository.dart';
import 'package:mobx/mobx.dart';

part 'search.store.g.dart';

class SearchStore = _SearchStore with _$SearchStore;

abstract class _SearchStore with Store {
  @observable
  bool isLoading = false;

  @observable
  Scans scan = Scans.NEOX;

  @observable
  ObservableList<Book> result = ObservableList();

  @action
  Future<void> search(String value) async {
    isLoading = true;

    final data = await BookRepository.search(value, scan);
    result = ObservableList()..addAll(data);

    isLoading = false;
  }

  @action
  void changeScan(Scans newScan) => scan = newScan;
}

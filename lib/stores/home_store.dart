import 'package:anr/models/book.dart';
import 'package:anr/models/scan.dart';
import 'package:mobx/mobx.dart';

part 'home_store.g.dart';

// ignore: library_private_types_in_public_api
class HomeStore = _HomeStore with _$HomeStore;

abstract class _HomeStore with Store {
  @observable
  bool isLoading = true;

  @observable
  ObservableMap<Scan, List<Book>> lastAdded = ObservableMap();

  @action
  Future<void> loadItems({bool forceUpdate = false}) async {
    final items = await Future.wait(Scan.values.map((scan) async {
      try {
        return await scan.repository.lastAdded(forceUpdate: forceUpdate);
      } catch (e) {
        return <Book>[];
      }
    }));

    lastAdded = ObservableMap()..addAll(Map.fromIterables(Scan.values, items));
    if (isLoading) isLoading = false;
  }
}

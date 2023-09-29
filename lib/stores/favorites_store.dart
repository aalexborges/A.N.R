import 'package:anr/models/book.dart';
import 'package:anr/models/scan.dart';
import 'package:anr/service_locator.dart';
import 'package:mobx/mobx.dart';

part 'favorites_store.g.dart';

// ignore: library_private_types_in_public_api
class FavoritesStore = _FavoritesStore with _$FavoritesStore;

abstract class _FavoritesStore with Store {
  @observable
  bool isLoading = true;

  @observable
  Scan? filterBy;

  @observable
  ObservableList<Book> favorites = ObservableList();

  @action
  Future<void> get({bool forceUpdate = false}) async {
    isLoading = true;

    final items = await favoritesRepository.get(scan: filterBy, forceUpdate: forceUpdate);

    favorites = ObservableList.of(items);
    isLoading = false;
  }

  @action
  Future<void> changeFilter(Scan? scan) async {
    filterBy = scan;
    return get();
  }
}

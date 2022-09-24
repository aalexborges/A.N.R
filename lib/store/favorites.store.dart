import 'package:A.N.R/constants/scans.dart';
import 'package:A.N.R/models/book.model.dart';
import 'package:A.N.R/repositories/favorites.repository.dart';
import 'package:collection/collection.dart';
import 'package:mobx/mobx.dart';

part 'favorites.store.g.dart';

class FavoritesStore = FavoritesStoreBase with _$FavoritesStore;

abstract class FavoritesStoreBase with Store {
  @observable
  ObservableMap<String, Book> favorites = ObservableMap();

  @observable
  Scans? filterBy;

  @computed
  List<Book> get filteredFavorites {
    final items = favorites.values.toList();
    items.sort((a, b) => compareNatural(a.id, b.id));

    if (filterBy == null) return items;
    return items.where((book) => book.scan == filterBy).toList();
  }

  @action
  void changeFilter(Scans? scan) => filterBy = scan;

  @action
  Future<void> getAll() async {
    favorites = await FavoritesRepository.instance.getAll();
  }

  @action
  Future<void> add(Book book) async {
    favorites.update(book.id, (_) => book, ifAbsent: () => book);

    try {
      await FavoritesRepository.instance.addOne(book);
    } catch (_) {
      favorites.remove(book.id);

      throw Exception(
        'Erro ao adicionar o livro ${book.name} aos seus favoritos',
      );
    }
  }

  @action
  Future<void> remove(String id) async {
    final book = favorites[id];
    if (book == null) return;

    favorites.remove(id);

    try {
      await FavoritesRepository.instance.removeOne(book.id);
    } catch (_) {
      favorites.update(book.id, (_) => book, ifAbsent: () => book);

      throw Exception(
        'Erro ao remover o livro ${book.name} dos seus favoritos',
      );
    }
  }

  @action
  void clean() => favorites = ObservableMap();
}

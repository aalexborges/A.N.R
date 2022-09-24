// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FavoritesStore on FavoritesStoreBase, Store {
  Computed<List<Book>>? _$filteredFavoritesComputed;

  @override
  List<Book> get filteredFavorites => (_$filteredFavoritesComputed ??=
          Computed<List<Book>>(() => super.filteredFavorites,
              name: 'FavoritesStoreBase.filteredFavorites'))
      .value;

  final _$favoritesAtom = Atom(name: 'FavoritesStoreBase.favorites');

  @override
  ObservableMap<String, Book> get favorites {
    _$favoritesAtom.reportRead();
    return super.favorites;
  }

  @override
  set favorites(ObservableMap<String, Book> value) {
    _$favoritesAtom.reportWrite(value, super.favorites, () {
      super.favorites = value;
    });
  }

  final _$filterByAtom = Atom(name: 'FavoritesStoreBase.filterBy');

  @override
  Scans? get filterBy {
    _$filterByAtom.reportRead();
    return super.filterBy;
  }

  @override
  set filterBy(Scans? value) {
    _$filterByAtom.reportWrite(value, super.filterBy, () {
      super.filterBy = value;
    });
  }

  final _$getAllAsyncAction = AsyncAction('FavoritesStoreBase.getAll');

  @override
  Future<void> getAll() {
    return _$getAllAsyncAction.run(() => super.getAll());
  }

  final _$addAsyncAction = AsyncAction('FavoritesStoreBase.add');

  @override
  Future<void> add(Book book) {
    return _$addAsyncAction.run(() => super.add(book));
  }

  final _$removeAsyncAction = AsyncAction('FavoritesStoreBase.remove');

  @override
  Future<void> remove(String id) {
    return _$removeAsyncAction.run(() => super.remove(id));
  }

  final _$FavoritesStoreBaseActionController =
      ActionController(name: 'FavoritesStoreBase');

  @override
  void changeFilter(Scans? scan) {
    final _$actionInfo = _$FavoritesStoreBaseActionController.startAction(
        name: 'FavoritesStoreBase.changeFilter');
    try {
      return super.changeFilter(scan);
    } finally {
      _$FavoritesStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clean() {
    final _$actionInfo = _$FavoritesStoreBaseActionController.startAction(
        name: 'FavoritesStoreBase.clean');
    try {
      return super.clean();
    } finally {
      _$FavoritesStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
favorites: ${favorites},
filterBy: ${filterBy},
filteredFavorites: ${filteredFavorites}
    ''';
  }
}

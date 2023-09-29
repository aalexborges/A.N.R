// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FavoritesStore on _FavoritesStore, Store {
  late final _$isLoadingAtom =
      Atom(name: '_FavoritesStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$filterByAtom =
      Atom(name: '_FavoritesStore.filterBy', context: context);

  @override
  Scan? get filterBy {
    _$filterByAtom.reportRead();
    return super.filterBy;
  }

  @override
  set filterBy(Scan? value) {
    _$filterByAtom.reportWrite(value, super.filterBy, () {
      super.filterBy = value;
    });
  }

  late final _$favoritesAtom =
      Atom(name: '_FavoritesStore.favorites', context: context);

  @override
  ObservableList<Book> get favorites {
    _$favoritesAtom.reportRead();
    return super.favorites;
  }

  @override
  set favorites(ObservableList<Book> value) {
    _$favoritesAtom.reportWrite(value, super.favorites, () {
      super.favorites = value;
    });
  }

  late final _$getAsyncAction =
      AsyncAction('_FavoritesStore.get', context: context);

  @override
  Future<void> get({bool forceUpdate = false}) {
    return _$getAsyncAction.run(() => super.get(forceUpdate: forceUpdate));
  }

  late final _$changeFilterAsyncAction =
      AsyncAction('_FavoritesStore.changeFilter', context: context);

  @override
  Future<void> changeFilter(Scan? scan) {
    return _$changeFilterAsyncAction.run(() => super.changeFilter(scan));
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
filterBy: ${filterBy},
favorites: ${favorites}
    ''';
  }
}

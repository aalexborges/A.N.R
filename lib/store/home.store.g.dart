// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HomeStore on _HomeStore, Store {
  final _$isLoadingAtom = Atom(name: '_HomeStore.isLoading');

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

  final _$booksAtom = Atom(name: '_HomeStore.books');

  @override
  ObservableMap<Scans, List<Book>> get books {
    _$booksAtom.reportRead();
    return super.books;
  }

  @override
  set books(ObservableMap<Scans, List<Book>> value) {
    _$booksAtom.reportWrite(value, super.books, () {
      super.books = value;
    });
  }

  final _$getLatestBooksAddedAsyncAction =
      AsyncAction('_HomeStore.getLatestBooksAdded');

  @override
  Future<void> getLatestBooksAdded() {
    return _$getLatestBooksAddedAsyncAction
        .run(() => super.getLatestBooksAdded());
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
books: ${books}
    ''';
  }
}

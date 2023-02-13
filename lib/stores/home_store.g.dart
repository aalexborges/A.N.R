// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeStore on _HomeStore, Store {
  late final _$isLoadingAtom =
      Atom(name: '_HomeStore.isLoading', context: context);

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

  late final _$lastAddedAtom =
      Atom(name: '_HomeStore.lastAdded', context: context);

  @override
  ObservableMap<Scan, List<Book>> get lastAdded {
    _$lastAddedAtom.reportRead();
    return super.lastAdded;
  }

  @override
  set lastAdded(ObservableMap<Scan, List<Book>> value) {
    _$lastAddedAtom.reportWrite(value, super.lastAdded, () {
      super.lastAdded = value;
    });
  }

  late final _$getLatestBooksAddedAsyncAction =
      AsyncAction('_HomeStore.getLatestBooksAdded', context: context);

  @override
  Future<void> getLatestBooksAdded(bool loading) {
    return _$getLatestBooksAddedAsyncAction
        .run(() => super.getLatestBooksAdded(loading));
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
lastAdded: ${lastAdded}
    ''';
  }
}

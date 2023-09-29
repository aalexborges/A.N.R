// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SearchStore on _SearchStore, Store {
  late final _$scanAtom = Atom(name: '_SearchStore.scan', context: context);

  @override
  Scan get scan {
    _$scanAtom.reportRead();
    return super.scan;
  }

  @override
  set scan(Scan value) {
    _$scanAtom.reportWrite(value, super.scan, () {
      super.scan = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_SearchStore.isLoading', context: context);

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

  late final _$resultsAtom =
      Atom(name: '_SearchStore.results', context: context);

  @override
  ObservableList<Book> get results {
    _$resultsAtom.reportRead();
    return super.results;
  }

  @override
  set results(ObservableList<Book> value) {
    _$resultsAtom.reportWrite(value, super.results, () {
      super.results = value;
    });
  }

  late final _$onSearchAsyncAction =
      AsyncAction('_SearchStore.onSearch', context: context);

  @override
  Future<void> onSearch(String value, {bool forceUpdate = false}) {
    return _$onSearchAsyncAction
        .run(() => super.onSearch(value, forceUpdate: forceUpdate));
  }

  late final _$_SearchStoreActionController =
      ActionController(name: '_SearchStore', context: context);

  @override
  void setScan(Scan value) {
    final _$actionInfo = _$_SearchStoreActionController.startAction(
        name: '_SearchStore.setScan');
    try {
      return super.setScan(value);
    } finally {
      _$_SearchStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
scan: ${scan},
isLoading: ${isLoading},
results: ${results}
    ''';
  }
}

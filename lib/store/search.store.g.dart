// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SearchStore on _SearchStore, Store {
  final _$isLoadingAtom = Atom(name: '_SearchStore.isLoading');

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

  final _$scanAtom = Atom(name: '_SearchStore.scan');

  @override
  Scans get scan {
    _$scanAtom.reportRead();
    return super.scan;
  }

  @override
  set scan(Scans value) {
    _$scanAtom.reportWrite(value, super.scan, () {
      super.scan = value;
    });
  }

  final _$resultAtom = Atom(name: '_SearchStore.result');

  @override
  ObservableList<Book> get result {
    _$resultAtom.reportRead();
    return super.result;
  }

  @override
  set result(ObservableList<Book> value) {
    _$resultAtom.reportWrite(value, super.result, () {
      super.result = value;
    });
  }

  final _$searchAsyncAction = AsyncAction('_SearchStore.search');

  @override
  Future<void> search(String value) {
    return _$searchAsyncAction.run(() => super.search(value));
  }

  final _$_SearchStoreActionController = ActionController(name: '_SearchStore');

  @override
  void changeScan(Scans newScan) {
    final _$actionInfo = _$_SearchStoreActionController.startAction(
        name: '_SearchStore.changeScan');
    try {
      return super.changeScan(newScan);
    } finally {
      _$_SearchStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
scan: ${scan},
result: ${result}
    ''';
  }
}

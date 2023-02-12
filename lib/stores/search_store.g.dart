// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$Search on _Search, Store {
  late final _$isLoadingAtom =
      Atom(name: '_Search.isLoading', context: context);

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

  late final _$resultsAtom = Atom(name: '_Search.results', context: context);

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

  late final _$_SearchActionController =
      ActionController(name: '_Search', context: context);

  @override
  void setIsLoading(bool loading) {
    final _$actionInfo =
        _$_SearchActionController.startAction(name: '_Search.setIsLoading');
    try {
      return super.setIsLoading(loading);
    } finally {
      _$_SearchActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
results: ${results}
    ''';
  }
}

import 'package:anr/models/scan.dart';
import 'package:anr/stores/search_store.dart';
import 'package:anr/widgets/book_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late SearchStore _store;

  @override
  void initState() {
    super.initState();
    _store = SearchStore();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          centerTitle: false,
          title: Observer(builder: (context) => Text(t.searchBook(_store.scan.value.toUpperCase()))),
          actions: [
            Observer(builder: (context) {
              return PopupMenuButton<Scan>(
                enabled: !_store.isLoading,
                initialValue: _store.scan,
                onSelected: _store.setScan,
                itemBuilder: (context) {
                  return Scan.values.map<PopupMenuEntry<Scan>>((scan) {
                    return PopupMenuItem(value: scan, child: Text(scan.value.toUpperCase()));
                  }).toList();
                },
              );
            })
          ],
          bottom: AppBar(
            automaticallyImplyLeading: false,
            title: SizedBox(
              height: 40,
              child: Observer(builder: (context) {
                return TextField(
                  enabled: !_store.isLoading,
                  textInputAction: TextInputAction.search,
                  keyboardAppearance: Brightness.dark,
                  onSubmitted: _store.onSearch,
                  decoration: InputDecoration(hintText: t.enterBookName, prefixIcon: const Icon(Icons.search_rounded)),
                );
              }),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(8),
          sliver: Observer(builder: (context) {
            if (_store.isLoading) {
              return const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator.adaptive()),
              );
            }

            if (_store.results.isEmpty) {
              return SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: Text(t.searchNotResult)),
              );
            }

            return SliverGrid.builder(
              gridDelegate: BookListElementSize.sliverGridDelegate,
              itemCount: _store.results.length,
              itemBuilder: (context, index) => BookListElement(book: _store.results[index]),
            );
          }),
        )
      ]),
    );
  }
}

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
  final _store = SearchStore();
  final inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final i10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              snap: false,
              title: Observer(builder: (context) => Text(i10n.searchBook(_store.scan.value.toUpperCase()))),
              pinned: true,
              floating: true,
              centerTitle: false,
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
                }),
              ],
              bottom: AppBar(
                automaticallyImplyLeading: false,
                title: SizedBox(
                  height: 40,
                  child: Observer(builder: (context) {
                    return TextField(
                      enabled: !_store.isLoading,
                      controller: inputController,
                      textInputAction: TextInputAction.search,
                      keyboardAppearance: Brightness.dark,
                      onSubmitted: _store.onSearch,
                      decoration: InputDecoration(
                        hintText: i10n.enterBookName,
                        prefixIcon: const Icon(Icons.search_rounded),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ];
        },
        body: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: RefreshIndicator(
            onRefresh: () => _store.onSearch(inputController.text, forceUpdate: true),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Observer(builder: (context) {
                if (_store.isLoading) return const Center(child: CircularProgressIndicator.adaptive());
                if (_store.results.isEmpty) return Center(child: Text(i10n.searchNotResult));

                return GridView.builder(
                  gridDelegate: BookListItemSize.sliverGridDelegate,
                  itemCount: _store.results.length,
                  itemBuilder: (context, index) => BookListItem(book: _store.results[index]),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

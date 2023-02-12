import 'package:anr/stores/search_store.dart';
import 'package:anr/widgets/book_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final SearchStore store = SearchStore();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          centerTitle: false,
          title: Text(t.searchBook('Neox')),
          bottom: AppBar(
            automaticallyImplyLeading: false,
            title: SizedBox(
              height: 40,
              child: Observer(builder: (context) {
                return TextField(
                  enabled: !store.isLoading,
                  textInputAction: TextInputAction.search,
                  keyboardAppearance: Brightness.dark,
                  decoration: InputDecoration(hintText: t.enterBookName, prefixIcon: const Icon(Icons.search_rounded)),
                );
              }),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(8),
          sliver: Observer(builder: (context) {
            if (store.isLoading) {
              return const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator.adaptive()),
              );
            }

            if (store.results.isEmpty) {
              return SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: Text(t.searchNotResult)),
              );
            }

            return SliverGrid.builder(
              gridDelegate: BookListElementSize.sliverGridDelegate,
              itemCount: store.results.length,
              itemBuilder: (context, index) => BookListElement(book: store.results[index]),
            );
          }),
        )
      ]),
    );
  }
}

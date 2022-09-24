import 'package:A.N.R/constants/routes_path.dart';
import 'package:A.N.R/constants/scans.dart';
import 'package:A.N.R/store/search.store.dart';
import 'package:A.N.R/constants/grid_book_delegate.dart';
import 'package:A.N.R/widgets/book.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _store = SearchStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            centerTitle: false,
            floating: true,
            pinned: true,
            snap: false,
            title: Observer(builder: (context) {
              return Text('${_store.scan.value} - Buscar livro...');
            }),
            actions: [
              Observer(builder: (context) {
                return PopupMenuButton<Scans>(
                  enabled: !_store.isLoading,
                  initialValue: _store.scan,
                  onSelected: _store.changeScan,
                  itemBuilder: (context) {
                    return Scans.values.map<PopupMenuEntry<Scans>>((scan) {
                      return PopupMenuItem(
                        value: scan,
                        child: Text(scan.value),
                      );
                    }).toList();
                  },
                );
              }),
            ],
            bottom: AppBar(
              automaticallyImplyLeading: false,
              title: SizedBox(
                width: double.infinity,
                height: 40,
                child: Observer(builder: (context) {
                  return TextField(
                    enabled: !_store.isLoading,
                    autofocus: true,
                    textInputAction: TextInputAction.search,
                    keyboardAppearance: Brightness.dark,
                    onSubmitted: _store.search,
                    decoration: const InputDecoration(
                      hintText: 'Digite o nome do livro',
                      prefixIcon: Icon(Icons.search_rounded),
                    ),
                  );
                }),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(8),
            sliver: Observer(builder: (context) {
              if (_store.isLoading) {
                final screenWidth = MediaQuery.of(context).size.width - 16;
                final width = screenWidth > 300.0 ? 300.0 : screenWidth;

                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Lottie.asset(
                      'assets/animations/searching-radius.json',
                      width: width,
                    ),
                  ),
                );
              }

              if (_store.result.isEmpty) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text('Ops! Não houve resultados para sua busca.'),
                  ),
                );
              }

              return SliverGrid(
                gridDelegate: gridBookDelegate,
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final book = _store.result[index];

                    return BookWidget(
                      book: book,
                      onTap: () => context.push(RoutesPath.BOOK, extra: book),
                    );
                  },
                  childCount: _store.result.length,
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}

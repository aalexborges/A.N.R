import 'package:anr/models/book_item.dart';
import 'package:anr/models/scan.dart';
import 'package:anr/widgets/book_item_button.dart';
import 'package:anr/widgets/search_select_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final inputController = TextEditingController();

  Scan scan = Scan.neox;
  bool loading = false;
  List<BookItem> items = List.empty(growable: false);

  void changeScan(Scan value) {
    setState(() {
      scan = value;
    });
  }

  Future<void> onSubmitted(String value, {bool forceUpdate = false}) async {
    setState(() {
      items = List.empty(growable: false);
      loading = true;
    });

    final result = await scan.repository.search(value, forceUpdate: forceUpdate);

    setState(() {
      items = result;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final i10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              snap: false,
              title: Text(i10n.searchBook(scan.value.toUpperCase())),
              pinned: true,
              floating: true,
              centerTitle: false,
              actions: [SearchSelectProvider(enabled: !loading, initialValue: scan, onSelected: changeScan)],
              bottom: AppBar(
                automaticallyImplyLeading: false,
                title: SizedBox(
                  height: 40,
                  child: TextField(
                    enabled: !loading,
                    controller: inputController,
                    textInputAction: TextInputAction.search,
                    keyboardAppearance: Brightness.dark,
                    onSubmitted: onSubmitted,
                    decoration: InputDecoration(
                      hintText: i10n.searchInputHint,
                      prefixIcon: const Icon(Icons.search_rounded),
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: RefreshIndicator(
            child: Padding(padding: const EdgeInsets.all(8.0), child: body(i10n)),
            onRefresh: () => onSubmitted(inputController.text, forceUpdate: true),
          ),
        ),
      ),
    );
  }

  Widget body(AppLocalizations i10n) {
    if (loading) return const Center(child: CircularProgressIndicator.adaptive());
    if (items.isEmpty) return Center(child: Text(i10n.searchNotResult));

    return GridView.builder(
      gridDelegate: BookItemButtonSizes.sliverGridDelegate,
      itemCount: items.length,
      itemBuilder: (context, index) => BookItemButton(bookItem: items[index]),
    );
  }
}

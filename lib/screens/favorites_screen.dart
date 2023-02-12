import 'package:anr/widgets/book_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.favorites)),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: Observer(builder: (context) {
          return GridView.builder(
            gridDelegate: BookListElementSize.sliverGridDelegate,
            itemBuilder: (context, index) {
              return const SizedBox();
            },
          );
        }),
      ),
    );
  }
}

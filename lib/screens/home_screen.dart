import 'package:anr/models/scan.dart';
import 'package:anr/repositories/user_repository.dart';
import 'package:anr/router.dart';
import 'package:anr/stores/home_store.dart';
import 'package:anr/widgets/book_list_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late HomeStore _store;

  @override
  void initState() {
    super.initState();

    _store = HomeStore()..getLatestBooksAdded();
  }

  @override
  Widget build(BuildContext context) {
    final photoURL = FirebaseAuth.instance.currentUser!.photoURL!;
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset('assets/images/logo.svg', width: 24),
        actions: [
          IconButton(onPressed: () => context.push(ScreenPaths.search), icon: const Icon(Icons.search_rounded)),
          IconButton(onPressed: () => context.push(ScreenPaths.favorites), icon: const Icon(Icons.favorite_rounded)),
          IconButton(
            onPressed: () => UserRepository.showModal(context),
            icon: SizedBox.fromSize(
              size: const Size(24, 24),
              child: CircleAvatar(backgroundImage: CachedNetworkImageProvider(photoURL, maxHeight: 48, maxWidth: 48)),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _store.getLatestBooksAdded,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: Scan.values.map((scan) => _section(context, scan, t)).toList(),
          ),
        ),
      ),
    );
  }

  Widget _section(BuildContext context, Scan scan, AppLocalizations t) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          margin: const EdgeInsets.only(bottom: 4),
          child: Text(t.lastAdded(scan.value.toUpperCase()), style: Theme.of(context).textTheme.titleSmall),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Observer(builder: (context) {
            if (_store.isLoading) {
              return _horizontalList(
                itemCount: (MediaQuery.of(context).size.width / BookListElementSize.width).ceil(),
                itemBuilder: (context, index) => const BookListElementShimmer(),
              );
            }

            final books = _store.lastAdded[scan] ?? List.empty();
            return _horizontalList(
              itemCount: books.length,
              itemBuilder: (context, index) => BookListElement(book: books[index]),
            );
          }),
        ),
      ],
    );
  }

  Widget _horizontalList({required Widget? Function(BuildContext, int) itemBuilder, int? itemCount}) {
    return SizedBox(
      height: BookListElementSize.height,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: itemCount,
        itemBuilder: itemBuilder,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}

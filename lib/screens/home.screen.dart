import 'package:A.N.R/constants/routes_path.dart';
import 'package:A.N.R/constants/scans.dart';
import 'package:A.N.R/services/user_modal.service.dart';
import 'package:A.N.R/store/home.store.dart';
import 'package:A.N.R/widgets/book.widget.dart';
import 'package:A.N.R/widgets/book_shimmer.widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

final _store = HomeStore()..getLatestBooksAdded();

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loadingCount = (MediaQuery.of(context).size.width / bookWidth).ceil();

    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset('assets/images/logo.svg', width: 24),
        actions: [
          IconButton(
            onPressed: () => context.push(RoutesPath.SEARCH),
            icon: const Icon(Icons.search_rounded),
          ),
          IconButton(
            onPressed: () => context.push(RoutesPath.FAVORITES),
            icon: const Icon(Icons.favorite_rounded),
          ),
          IconButton(
            onPressed: () => UserModalService.show(context),
            icon: SizedBox.fromSize(
              size: const Size(24, 24),
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: CachedNetworkImageProvider(
                  FirebaseAuth.instance.currentUser!.photoURL!,
                  maxHeight: 48,
                  maxWidth: 48,
                ),
              ),
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
            children: Scans.values.map((scan) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '${scan.value} - Últimos adicionados',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  Container(
                    height: bookHeight,
                    margin: const EdgeInsets.only(bottom: 24),
                    child: Observer(builder: (context) {
                      const gap = EdgeInsets.symmetric(horizontal: 4);

                      if (_store.isLoading) {
                        return _horizontalList(
                          itemCount: loadingCount,
                          itemBuilder: (context, index) {
                            return const BookShimmerWidget(margin: gap);
                          },
                        );
                      }

                      final books = _store.books[scan] ?? [];
                      return _horizontalList(
                        itemCount: books.length,
                        itemBuilder: (context, index) {
                          final book = books[index];

                          return BookWidget(
                            book: book,
                            margin: gap,
                            onTap: () => context.push(
                              RoutesPath.BOOK,
                              extra: book,
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _horizontalList({
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
  }) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      physics: const BouncingScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      scrollDirection: Axis.horizontal,
    );
  }
}

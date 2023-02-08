import 'package:anr/models/book.dart';
import 'package:anr/router.dart';
import 'package:anr/widgets/book_list_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final photoURL = FirebaseAuth.instance.currentUser!.photoURL!;

    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset('assets/images/logo.svg', width: 24),
        actions: [
          IconButton(onPressed: () => context.push(ScreenPaths.search), icon: const Icon(Icons.search_rounded)),
          IconButton(onPressed: () => context.push(ScreenPaths.favorites), icon: const Icon(Icons.favorite_rounded)),
          IconButton(
            onPressed: () {},
            icon: SizedBox.fromSize(
              size: const Size(24, 24),
              child: CircleAvatar(backgroundImage: CachedNetworkImageProvider(photoURL, maxHeight: 48, maxWidth: 48)),
            ),
          ),
        ],
      ),
      body: const BookListElement(
        book: Book(
          src: 'https://neoxscans.net/wp-content/uploads/2022/05/TheWorldAfterTheEnd-175x238.jpg',
          name: 'Test',
          path: '/test',
        ),
      ),
    );
  }
}

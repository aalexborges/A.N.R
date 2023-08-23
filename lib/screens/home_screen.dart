import 'package:anr/models/book_item.dart';
import 'package:anr/models/scan.dart';
import 'package:anr/utils/route_paths.dart';
import 'package:anr/widgets/book_item_button.dart';
import 'package:anr/widgets/user_button.dart';
import 'package:anr/widgets/user_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final i10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset('assets/logo.svg', width: 24),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            tooltip: i10n.tooltipSearch,
            onPressed: () => context.push(RoutePaths.search),
          ),
          IconButton(
            icon: const Icon(Icons.favorite_rounded),
            tooltip: i10n.tooltipFavorites,
            onPressed: () => context.push(RoutePaths.favorites),
          ),
          UserButton(onPressed: () => UserModal.showModal(context), tooltip: i10n.tooltipUser),
        ],
      ),
      body: const _HomeBody(),
    );
  }
}

class _HomeBody extends StatefulWidget {
  const _HomeBody();

  @override
  State<_HomeBody> createState() => __HomeBodyState();
}

class __HomeBodyState extends State<_HomeBody> {
  Map<Scan, List<BookItem>> lastAdded = {};
  bool loading = true;

  Future<void> loadItems({bool forceUpdate = false}) async {
    final items = await Future.wait(Scan.values.map((e) => e.repository.lastAdded(forceUpdate: forceUpdate)));

    setState(() {
      loading = false;
      lastAdded = Map.fromIterables(Scan.values, items);
    });
  }

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  @override
  Widget build(BuildContext context) {
    final i10n = AppLocalizations.of(context)!;

    return RefreshIndicator.adaptive(
      onRefresh: () => loadItems(forceUpdate: true),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: 16, bottom: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: Scan.values.map((scan) => section(scan, i10n)).toList(),
        ),
      ),
    );
  }

  Widget section(Scan scan, AppLocalizations i10n) {
    final items = loading ? List.filled(loadingLength, null, growable: false) : lastAdded[scan] ?? [];

    return Column(
      key: Key('${scan.name}-section'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(i10n.lastAddedSection(scan.value.toUpperCase()), style: Theme.of(context).textTheme.titleSmall),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 16, top: 4),
          height: BookItemButtonSizes.height,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) => BookItemButton(bookItem: items[index]),
          ),
        ),
      ],
    );
  }

  int get loadingLength => (MediaQuery.of(context).size.width / BookItemButtonSizes.width).ceil();
}

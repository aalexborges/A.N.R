import 'package:anr/widgets/user_button.dart';
import 'package:anr/widgets/user_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final i10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset('assets/logo.svg', width: 24),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded), tooltip: i10n.tooltipSearch),
          IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_rounded), tooltip: i10n.tooltipFavorites),
          UserButton(onPressed: () => UserModal.showModal(context), tooltip: i10n.tooltipUser),
        ],
      ),
    );
  }
}

import 'package:anr/service_locator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum UserModalOptions { signOut, changeTheme }

class UserModal extends StatelessWidget {
  const UserModal({super.key});

  @override
  Widget build(BuildContext context) {
    final i10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;

    return Column(
      key: const Key('user_modal'),
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text(user?.displayName ?? i10n.anonymous),
          subtitle: Text(user?.email ?? 'no-email'),
          leading: avatar(user),
        ),
        ListTile(
          title: Text(i10n.changeTheme),
          leading: Icon(themeRepository.icon),
          onTap: () => Navigator.of(context).pop(UserModalOptions.changeTheme),
        ),
        ListTile(
          title: Text(i10n.signOut, style: const TextStyle(color: Colors.red)),
          leading: const Icon(Icons.logout_rounded, color: Colors.red),
          onTap: () => Navigator.of(context).pop(UserModalOptions.signOut),
        ),
      ],
    );
  }

  CircleAvatar avatar(User? user) {
    if (user is! User || user.photoURL is! String) return const CircleAvatar();

    return CircleAvatar(
      backgroundImage: CachedNetworkImageProvider(
        user.photoURL!,
        maxHeight: 64,
        maxWidth: 64,
      ),
    );
  }

  static Future<void> showModal(BuildContext context) async {
    final result = await showModalBottomSheet<UserModalOptions>(context: context, builder: (ctx) => const UserModal());

    // ignore: use_build_context_synchronously
    if (result == UserModalOptions.changeTheme) await themeRepository.selectThemeModal(context);
    if (result == UserModalOptions.signOut) await authRepository.signOut();
  }
}

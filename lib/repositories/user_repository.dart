import 'package:anr/main.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum UserModalOptions { signOut, changeTheme }

class UserRepository {
  const UserRepository();

  Future<void> showModal(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final t = AppLocalizations.of(context)!;

    final result = await showModalBottomSheet<UserModalOptions>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(user.displayName ?? t.anonymous),
            subtitle: Text(user.email ?? 'no-email'),
            leading: CircleAvatar(
              backgroundImage: user.photoURL == null
                  ? null
                  : CachedNetworkImageProvider(
                      user.photoURL!,
                      maxHeight: 64,
                      maxWidth: 64,
                    ),
            ),
          ),
          ListTile(
            title: Text(t.changeTheme),
            leading: Icon(themeRepository.icon),
            onTap: () => Navigator.of(context).pop(UserModalOptions.changeTheme),
          ),
          ListTile(
            title: Text(t.signOut, style: const TextStyle(color: Colors.red)),
            leading: const Icon(Icons.logout_rounded, color: Colors.red),
            onTap: () => Navigator.of(context).pop(UserModalOptions.signOut),
          ),
        ],
      ),
    );

    switch (result) {
      case UserModalOptions.signOut:
        return await authRepository.signOut();

      case UserModalOptions.changeTheme:
        // ignore: use_build_context_synchronously
        return await themeRepository.selectThemeModal(context);

      default:
        return;
    }
  }
}

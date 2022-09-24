import 'package:A.N.R/constants/user_modal_options.dart';
import 'package:A.N.R/services/auth.service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserModalService {
  static Future<void> _handle(UserModalOptions? result) async {
    switch (result) {
      case UserModalOptions.LOGOUT:
        return AuthService.signOut();

      default:
        return;
    }
  }

  static Future<void> show(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final result = await showModalBottomSheet<UserModalOptions>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(user.displayName ?? ''),
            subtitle: Text(user.email ?? ''),
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                user.photoURL ?? '',
                maxHeight: 64,
                maxWidth: 64,
              ),
            ),
          ),
          ListTile(
            title: const Text('Sair', style: TextStyle(color: Colors.red)),
            leading: const Icon(Icons.logout_rounded, color: Colors.red),
            onTap: () => Navigator.of(context).pop(UserModalOptions.LOGOUT),
          ),
        ],
      ),
    );

    await _handle(result);
  }
}

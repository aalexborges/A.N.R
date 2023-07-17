import 'package:anr/service_locator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserButton extends StatelessWidget {
  const UserButton({super.key, this.onPressed, this.size, this.tooltip});

  final Size? size;
  final String? tooltip;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final photoURL = userRepository.photoURL;

    return IconButton(
      key: const Key('user_icon_button'),
      onPressed: onPressed,
      tooltip: tooltip,
      icon: SizedBox.fromSize(
        size: size ?? const Size(24, 24),
        child: photoURL is String
            ? CircleAvatar(
                key: const Key('user_icon_button_photo'),
                backgroundImage: CachedNetworkImageProvider(photoURL, maxHeight: 48, maxWidth: 48),
              )
            : const SizedBox(),
      ),
    );
  }
}

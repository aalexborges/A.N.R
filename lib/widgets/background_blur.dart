import 'dart:ui';

import 'package:flutter/material.dart';

class BackgroundBlur extends StatelessWidget {
  const BackgroundBlur({super.key});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: Container(color: Theme.of(context).colorScheme.background.withOpacity(0.2)),
    );
  }
}

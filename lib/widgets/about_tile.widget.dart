import 'package:flutter/material.dart';

class AboutTileWidget extends StatelessWidget {
  final String title;
  final String value;

  const AboutTileWidget({required this.title, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
    );
  }
}

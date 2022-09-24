import 'package:flutter/material.dart';

class AboutCategoriesTitleWidget extends StatelessWidget {
  final List<String> categories;

  const AboutCategoriesTitleWidget(this.categories, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text('Categorias:'),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      subtitle: SizedBox(
        height: 40,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Chip(label: Text(categories[index])),
            );
          },
        ),
      ),
    );
  }
}

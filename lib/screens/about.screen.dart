import 'package:A.N.R/constants/scans.dart';
import 'package:A.N.R/models/book.model.dart';
import 'package:A.N.R/models/book_data.model.dart';
import 'package:A.N.R/widgets/about_categories_tile.widget.dart';
import 'package:A.N.R/widgets/about_tile.widget.dart';
import 'package:A.N.R/widgets/sinopse.widget.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  final AboutProps props;

  const AboutScreen(this.props, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(props.book.name)),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SinopseWidget(
              props.data.sinopse,
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            AboutCategoriesTitleWidget(props.data.categories),
            AboutTileWidget(
              title: 'Nome:',
              value: props.book.name,
            ),
            AboutTileWidget(
              title: 'Tipo:',
              value: props.data.type ?? 'Desconhecido',
            ),
            AboutTileWidget(
              title: 'Capítulos:',
              value: props.data.chapters.length.toString().padLeft(2, '0'),
            ),
            AboutTileWidget(
              title: 'Scan:',
              value: props.book.scan.value,
            ),
          ],
        ),
      ),
    );
  }
}

class AboutProps {
  final Book book;
  final BookData data;

  const AboutProps({required this.book, required this.data});
}

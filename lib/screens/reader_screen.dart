import 'dart:ui' as ui;

import 'package:anr/models/chapter.dart';
import 'package:anr/models/reader.dart';
import 'package:anr/models/scan.dart';
import 'package:anr/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:merge_images/merge_images.dart';

class ReaderScreen extends StatefulWidget {
  const ReaderScreen({super.key, required this.reader});

  final Reader reader;

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  List<ui.Image> images = List.empty(growable: false);

  List<Chapter> get chapters => widget.reader.chapters;

  Future<void> loadContent(int chapterIndex) async {
    final sources = await widget.reader.scan.repository.content(chapters[chapterIndex]);

    final items = await Future.wait(sources.map((source) async {
      final response = await httpRepository.get(Uri.parse(source));
      return await ImagesMergeHelper.uint8ListToImage(response.bodyBytes);
    }));

    setState(() {
      images = items;
    });
  }

  @override
  void initState() {
    super.initState();
    loadContent(widget.reader.chapterIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: images.isEmpty
          ? const Center(child: CircularProgressIndicator.adaptive())
          : SingleChildScrollView(
              child: ImagesMerge(
                images,
                fit: true,
              ),
            ),
    );
  }
}

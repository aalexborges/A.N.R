import 'package:flutter/material.dart';

class MeasureSize extends StatefulWidget {
  const MeasureSize({super.key, required this.child, required this.onChange});

  final Widget child;
  final void Function(Size size) onChange;

  @override
  State<MeasureSize> createState() => _MeasureSizeState();
}

class _MeasureSizeState extends State<MeasureSize> {
  final widgetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(_onNotification);

    return Container(key: widgetKey, child: widget.child);
  }

  _onNotification(Duration _) {
    final size = widgetKey.currentContext?.size;
    if (size is Size) widget.onChange(size);
  }
}

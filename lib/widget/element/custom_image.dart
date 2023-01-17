import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  late final Uint8List? _imageData;
  late final double _height;
  late final bool _showDefault;

  CustomImage(Uint8List? imageData, {super.key, double height = 200.0, bool showDefault = true}) {
    _imageData = imageData;
    _height = height;
    _showDefault = showDefault;
  }

  @override
  Widget build(BuildContext context) {
    if (_imageData != null) {
      return Image.memory(_imageData!, height: _height, alignment: Alignment.center);
    } else if (_showDefault) {
      return Container(
        height: _height,
        alignment: Alignment.center,
        child: const Icon(Icons.no_photography),
      );
    } else {
      return const SizedBox();
    }
  }
}

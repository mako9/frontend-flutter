import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class CustomKeyValueColumn extends StatelessWidget {
  late final String _keyText;
  late final String _valueText;

  CustomKeyValueColumn(String keyText, String? valueText, {super.key}) {
    _keyText = keyText;
    if (valueText == null || valueText.isEmpty) {
      _valueText = '-';
    } else {
      _valueText = valueText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PlatformText(_keyText, style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          PlatformText(_valueText, style: const TextStyle(
            fontSize: 24,
            ),
          ),
        ],
      )
    );
  }
}
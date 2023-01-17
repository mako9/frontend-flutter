import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class CustomTextFormField extends StatelessWidget {
  late final String? _labelText;
  late final TextEditingController _controller;

  CustomTextFormField(String? labelText, {super.key, String? initialValue, TextEditingController? controller}) {
    _labelText = labelText;
    _controller = controller ?? TextEditingController();
     if (initialValue != null) _controller.text = initialValue;
  }


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PlatformTextFormField(
        controller: _controller,
        hintText: _labelText,
      ),
    );
  }
}
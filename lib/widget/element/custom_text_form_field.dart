import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  late final String? _labelText;
  late final TextEditingController? _controller;

  CustomTextFormField(String? labelText, {super.key, String? initialValue, TextEditingController? controller}) {
    _labelText = labelText;
    _controller = controller;
    if (initialValue != null) {
      _controller?.text = initialValue;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          labelText: _labelText,
        ),
      )
    );
  }
}
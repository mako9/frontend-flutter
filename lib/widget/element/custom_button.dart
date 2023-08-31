import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  late final String _title;
  late final IconData _iconData;
  late final VoidCallback _onCustomButtonPressed;
  late final bool _isEnabled;

  CustomButton(
      String title, IconData iconData, VoidCallback onCustomButtonPressed,
      {super.key, bool isEnabled = true}) {
    _title = title;
    _iconData = iconData;
    _onCustomButtonPressed = onCustomButtonPressed;
    _isEnabled = isEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
        opacity: _isEnabled ? 1.0 : 0.2,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 480.0,
            maxHeight: 48.0,
            minHeight: 48.0,
            minWidth: 160.0,
          ),
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                )),
            child: Stack(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                        width: 48.0,
                        height: 48.0,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        child: Align(
                            alignment: Alignment.center,
                            child: Icon(_iconData))),
                    Expanded(
                        child: Center(
                      child: Text(_title,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: Colors.black)),
                    )),
                  ],
                ),
                if (_isEnabled) ... [
                  SizedBox.expand(
                    child: Material(
                      type: MaterialType.transparency,
                      child: InkWell(onTap: _onCustomButtonPressed),
                    ),
                  ),
                ]
              ],
            ),
          ),
        ));
  }
}

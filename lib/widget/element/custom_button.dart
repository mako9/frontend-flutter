import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  late final String _title;
  late final IconData _iconData;
  late final VoidCallback _onCustomButtonPressed;

  CustomButton(String title, IconData iconData, VoidCallback onCustomButtonPressed, {super.key}) {
    _title = title;
    _iconData = iconData;
    _onCustomButtonPressed = onCustomButtonPressed;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.0,
      width: double.infinity,
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
                              .headline6
                              ?.copyWith(color: Colors.black)),
                    )),
              ],
            ),
            SizedBox.expand(
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(onTap: _onCustomButtonPressed),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef PickerIndexCallback = void Function(int index);

class CustomPicker extends StatelessWidget {
  late final List<String> _values;
  late final PickerIndexCallback _onSelect;

  CustomPicker(List<String> values, PickerIndexCallback onSelect, {super.key}) {
    _values = values;
    _onSelect = onSelect;
  }

  @override
  Widget build(BuildContext context) {
    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
        return _CustomCupertinoPicker(_values, _onSelect);
      default:
        return _CustomMaterialPicker(_values, _onSelect);
    }
  }

}

class _CustomCupertinoPicker extends StatefulWidget {
  late final List<String> _values;
  late final PickerIndexCallback _onSelect;

  _CustomCupertinoPicker(List<String> values, PickerIndexCallback onSelect) {
    _values = values;
    _onSelect = onSelect;
  }

  @override
  State<StatefulWidget> createState() => _CustomCupertinoPickerState();
}

class _CustomCupertinoPickerState extends State<_CustomCupertinoPicker> {
  int _selectedIndex = 0;

  // This shows a CupertinoModalPopup with a reasonable fixed height which hosts CupertinoPicker.
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          // The Bottom margin is provided to align the popup above the system navigation bar.
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          // Provide a background color for the popup.
          color: CupertinoColors.systemBackground.resolveFrom(context),
          // Use a SafeArea widget to avoid system overlaps.
          child: SafeArea(
            top: false,
            child: child,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
        style: TextStyle(
          color: CupertinoColors.label.resolveFrom(context),
          fontSize: 22.0,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CupertinoButton(
                padding: EdgeInsets.zero,
                // Display a CupertinoPicker with list of fruits.
                onPressed: () => _showDialog(
                  CupertinoPicker(
                    magnification: 1.22,
                    squeeze: 1.2,
                    useMagnifier: true,
                    itemExtent: 32.0,
                    // This is called when selected item is changed.
                    onSelectedItemChanged: (int selectedItem) {
                      setState(() {
                        _selectedIndex = selectedItem;
                        widget._onSelect(selectedItem);
                      });
                    },
                    children:
                    List<Widget>.generate(widget._values.length, (int index) {
                      return Center(
                        child: Text(
                          widget._values[index],
                        ),
                      );
                    }),
                  ),
                ),
                // This displays the selected fruit name.
                child: Text(
                  widget._values[_selectedIndex],
                  style: const TextStyle(
                    fontSize: 22.0,
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}

class _CustomMaterialPicker extends StatefulWidget {
  late final List<String> _values;
  late final PickerIndexCallback _onSelect;

  _CustomMaterialPicker(List<String> values, PickerIndexCallback onSelect) {
    _values = values;
    _onSelect = onSelect;
  }

  @override
  State<_CustomMaterialPicker> createState() => _CustomMaterialPickerState();
}

class _CustomMaterialPickerState extends State<_CustomMaterialPicker> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget._values[_selectedIndex],
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: TextStyle(color: Colors.brown[300]),
      underline: Container(
        height: 2,
        color: Colors.brown[300],
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          if (value != null) {
            final index = widget._values.indexOf(value);
            _selectedIndex = index;
            widget._onSelect(index);
          }
        });
      },
      items: widget._values.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
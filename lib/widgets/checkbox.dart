import 'package:flutter/material.dart';

class CheckboxTile extends StatelessWidget {
  const CheckboxTile({
    super.key,
    required this.text,
    required this.onClicked,
    this.val = false,
    this.clear = false,
  });

  final bool clear;
  final String text;
  final void Function(bool? val) onClicked;
  final bool val;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          side: const BorderSide(color: Colors.blue, width: 2),
          value: clear ? false : val,
          onChanged: clear ? (clr) => false : onClicked,
          checkColor: Colors.white,
          fillColor: clear
              ? WidgetStateProperty.all(Colors.white)
              : val
                  ? WidgetStateProperty.all(Colors.blue)
                  : WidgetStateProperty.all(Colors.white),
        ),
        Text(
          text,
        ),
      ],
    );
  }
}

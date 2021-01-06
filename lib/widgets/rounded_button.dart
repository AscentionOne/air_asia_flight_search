import 'package:flutter/material.dart';

class CustomRoundedButton extends StatelessWidget {
  final String text;
  final bool selected;
  final GestureTapCallback onTap;

  const CustomRoundedButton({
    Key key,
    this.text,
    this.selected = false,
    this.onTap,
  })  : assert(text != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = selected ? Colors.white : Colors.transparent;
    Color textColor = selected ? Colors.red : Colors.white;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 36.0,
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: Colors.white, width: 1),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}

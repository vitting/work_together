import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final bool disabled;

  const RoundButton({Key key, @required this.text, this.onPressed, this.disabled = false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Container(
          child: Text(text,
        style: TextStyle(color: Colors.white),
      )),
      onPressed: disabled ? null : onPressed,
      splashColor: Colors.blue[400],
      disabledColor: Colors.grey,
      padding: EdgeInsets.all(20),
      color: Colors.blue[700],
      shape: CircleBorder(side: BorderSide(style: BorderStyle.none)),
    );
  }
}

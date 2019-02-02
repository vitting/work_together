import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  final Function onPressed;
  final bool disabled;
  final Color backgroundColor;
  final Color iconColor;
  final Color disabledColor;
  final IconData icon;
  final double iconSize;
  final String tooltip;
  final bool loading;

  const RoundIconButton(
      {Key key,
      @required this.icon,
      this.onPressed,
      this.disabled = false,
      this.backgroundColor,
      this.disabledColor = Colors.grey,
      this.iconSize = 24,
      this.loading = false,
      this.iconColor = Colors.white,
      this.tooltip = ""})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Tooltip(
        message: tooltip,
        child: Stack(
          children: <Widget>[
            RaisedButton(
              child: Container(
                  child: Icon(icon, color: iconColor, size: iconSize)),
              onPressed: disabled ? null : onPressed,
              splashColor: Colors.blue[400],
              disabledColor: disabledColor,
              padding: EdgeInsets.all(10),
              color: backgroundColor ?? Colors.blue[700],
              shape: CircleBorder(side: BorderSide(style: BorderStyle.none)),
            ),
            Positioned(
              bottom: 0,
              top: 0,
              left: 0,
              right: 0,
              child: loading ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 45,
                    height: 45,
                    child: CircularProgressIndicator()
                    ),
                ],
              ) : Container(),
            )
          ],
        ));
  }
}

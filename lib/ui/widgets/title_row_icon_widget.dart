import 'package:flutter/material.dart';

class TitleRowIcon extends StatelessWidget {
  final String title;
  final Widget leading;
  final ValueChanged<bool> onTapMenu;
  final Color textColor;
  
  const TitleRowIcon({Key key, this.title, this.onTapMenu, this.leading, this.textColor = Colors.black}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: leading,
        ),
        Expanded(child: Text(title, style: TextStyle(color: textColor))),
        onTapMenu == null ? Container() : IconButton(
          icon: Icon(Icons.more_vert, color: textColor),
          onPressed: () {
            if (onTapMenu != null) {
              onTapMenu(false);
            }
          },
        )
      ],
    );
  }
}

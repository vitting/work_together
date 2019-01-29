import 'package:flutter/material.dart';

class TitleRowIcon extends StatelessWidget {
  final String title;
  final Widget leading;
  final ValueChanged<bool> onTapMenu;
  
  const TitleRowIcon({Key key, this.title, this.onTapMenu, this.leading}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: leading,
        ),
        Expanded(child: Text(title)),
        IconButton(
          icon: Icon(Icons.more_vert),
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

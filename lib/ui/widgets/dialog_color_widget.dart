import 'package:flutter/material.dart';
import 'package:work_together/ui/widgets/dot_button_widget.dart';

enum DialogColors {
  yellow,
  red,
  darkBlue,
  blue,
  orange,
  green,
  purple,
  cyan,
  pink 
}

class DialogColor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.symmetric(vertical: 20),
      title: Text("Vælg farve"),
      children: <Widget>[
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          childAspectRatio: 1,
          children: <Widget>[
            DotButton(
              color: Colors.yellow,
              dialogColor: DialogColors.yellow,
              onTap: (color) {
                Navigator.of(context).pop(color);
              },
            ),
            DotButton(
              color: Colors.red[800],
              dialogColor: DialogColors.red,
              onTap: (color) {
                Navigator.of(context).pop(color);
              },
            ),
            DotButton(
              color: Colors.blue[900],
              dialogColor: DialogColors.darkBlue,
              onTap: (color) {
                Navigator.of(context).pop(color);
              },
            ),
            DotButton(
              color: Colors.blue,
              dialogColor: DialogColors.blue,
              onTap: (color) {
                Navigator.of(context).pop(color);
              },
            ),
            DotButton(
              color: Colors.orange,
              dialogColor: DialogColors.orange,
              onTap: (color) {
                Navigator.of(context).pop(color);
              },
            ),
            DotButton(
              color: Colors.green,
              dialogColor: DialogColors.green,
              onTap: (color) {
                Navigator.of(context).pop(color);
              },
            ),
            DotButton(
              color: Colors.purple,
              dialogColor: DialogColors.purple,
              onTap: (color) {
                Navigator.of(context).pop(color);
              },
            ),
            DotButton(
              color: Colors.cyanAccent,
              dialogColor: DialogColors.cyan,
              onTap: (color) {
                Navigator.of(context).pop(color);
              },
            ),
            DotButton(
              color: Colors.pink[300],
              dialogColor: DialogColors.pink,
              onTap: (color) {
                Navigator.of(context).pop(color);
              },
            ),
          ],
        )
      ],
    );
  }
}

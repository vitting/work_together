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

class DialogColorConvert {
  static Color getColor(DialogColors color) {
    Color value;
    switch (color) {
      case DialogColors.yellow:
        value = Colors.yellow;
        break;
      case DialogColors.red:
        value = Colors.red[800];
        break;
      case DialogColors.darkBlue:
        value = Colors.blue[900];
        break;
      case DialogColors.blue:
        value = Colors.blue;
        break;
      case DialogColors.orange:
        value = Colors.orange;
        break;
      case DialogColors.green:
        value = Colors.green;
        break;
      case DialogColors.purple:
        value = Colors.purple;
        break;
      case DialogColors.cyan:
        value = Colors.cyan;
        break;
      case DialogColors.pink:
      value = Colors.pink[300];
      break;
    }

    return value;
  }

  static int getColorValue(DialogColors color) {
    int value;
    switch (color) {
      case DialogColors.yellow:
        value = 0;
        break;
      case DialogColors.red:
        value = 1;
        break;
      case DialogColors.darkBlue:
        value = 2;
        break;
      case DialogColors.blue:
        value = 3;
        break;
      case DialogColors.orange:
        value = 4;
        break;
      case DialogColors.green:
        value = 5;
        break;
      case DialogColors.purple:
        value = 6;
        break;
      case DialogColors.cyan:
        value = 7;
        break;
      case DialogColors.pink:
      value = 8;
      break;
    }

    return value;
  }

  static DialogColors getDialogColor(int value) {
    DialogColors dialogColor;
    switch (value) {
      case 0:
        dialogColor = DialogColors.yellow;
        break;
      case 1:
        dialogColor = DialogColors.red;
        break;
      case 2:
        dialogColor = DialogColors.darkBlue;
        break;
      case 3:
        dialogColor = DialogColors.blue;
        break;
      case 4:
        dialogColor = DialogColors.orange;
        break;
      case 5:
        dialogColor = DialogColors.green;
        break;
      case 6:
        dialogColor = DialogColors.purple;
        break;
      case 7:
        dialogColor = DialogColors.cyan;
        break;
      case 8:
        dialogColor = DialogColors.pink;
      break;
    }

    return dialogColor;
  }
}

class DialogColor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.all(20),
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

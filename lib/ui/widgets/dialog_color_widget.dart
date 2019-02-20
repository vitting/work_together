import 'package:flutter/material.dart';
import 'package:work_together/ui/widgets/dot_button_widget.dart';
import 'package:work_together/ui/widgets/round_button_widget.dart';

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
  static Color getColorFromInt(int value) {
    return getColor(getDialogColor(value));
  }

  static Color getColor(DialogColors color) {
    Color value;
    switch (color) {
      case DialogColors.yellow:
        value = Colors.yellow[700];
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
        value = Colors.orange[700];
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

  static Color getDialogLightColor(int value) {
    Color dialogColorLight;
    switch (value) {
      case 0:
        dialogColorLight = Colors.yellow[50];
        break;
      case 1:
        dialogColorLight = Colors.red[50];
        break;
      case 2:
        dialogColorLight = Colors.blue[200];
        break;
      case 3:
        dialogColorLight = Colors.blue[50];
        break;
      case 4:
        dialogColorLight = Colors.orange[50];
        break;
      case 5:
        dialogColorLight = Colors.green[50];
        break;
      case 6:
        dialogColorLight = Colors.purple[50];
        break;
      case 7:
        dialogColorLight = Colors.cyan[50];
        break;
      case 8:
        dialogColorLight = Colors.pink[50];
        break;
    }

    return dialogColorLight;
  }

  static Color getDialogTextColor(int value) {
    Color dialogColorText;
    switch (value) {
      case 0:
        dialogColorText = Colors.blueGrey[800];
        break;
      case 1:
        dialogColorText = Colors.white;
        break;
      case 2:
        dialogColorText = Colors.white;
        break;
      case 3:
        dialogColorText = Colors.white;
        break;
      case 4:
        dialogColorText = Colors.white;
        break;
      case 5:
        dialogColorText = Colors.white;
        break;
      case 6:
        dialogColorText = Colors.white;
        break;
      case 7:
        dialogColorText = Colors.white;
        break;
      case 8:
        dialogColorText = Colors.white;
        break;
    }

    return dialogColorText;
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
              color: DialogColorConvert.getColor(DialogColors.yellow),
              dialogColor: DialogColors.yellow,
              onTap: (DialogColors color) {
                Navigator.of(context).pop(color);
              },
            ),
            DotButton(
              color: DialogColorConvert.getColor(DialogColors.red),
              dialogColor: DialogColors.red,
              onTap: (DialogColors color) {
                Navigator.of(context).pop(color);
              },
            ),
            DotButton(
              color: DialogColorConvert.getColor(DialogColors.darkBlue),
              dialogColor: DialogColors.darkBlue,
              onTap: (DialogColors color) {
                Navigator.of(context).pop(color);
              },
            ),
            DotButton(
              color: DialogColorConvert.getColor(DialogColors.blue),
              dialogColor: DialogColors.blue,
              onTap: (DialogColors color) {
                Navigator.of(context).pop(color);
              },
            ),
            DotButton(
              color: DialogColorConvert.getColor(DialogColors.orange),
              dialogColor: DialogColors.orange,
              onTap: (DialogColors color) {
                Navigator.of(context).pop(color);
              },
            ),
            DotButton(
              color: DialogColorConvert.getColor(DialogColors.green),
              dialogColor: DialogColors.green,
              onTap: (DialogColors color) {
                Navigator.of(context).pop(color);
              },
            ),
            DotButton(
              color: DialogColorConvert.getColor(DialogColors.purple),
              dialogColor: DialogColors.purple,
              onTap: (DialogColors color) {
                Navigator.of(context).pop(color);
              },
            ),
            DotButton(
              color: DialogColorConvert.getColor(DialogColors.cyan),
              dialogColor: DialogColors.cyan,
              onTap: (DialogColors color) {
                Navigator.of(context).pop(color);
              },
            ),
            DotButton(
              color: DialogColorConvert.getColor(DialogColors.pink),
              dialogColor: DialogColors.pink,
              onTap: (DialogColors color) {
                Navigator.of(context).pop(color);
              },
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: RoundButton(
            text: "Luk",
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        )
      ],
    );
  }
}

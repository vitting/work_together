import 'package:flutter/material.dart';
import 'package:work_together/ui/widgets/dialog_color_widget.dart';
import 'package:work_together/ui/widgets/dot_button_widget.dart';

class TitleRow extends StatelessWidget {
  final String title;
  final ValueChanged<bool> onTapMenu;
  final ValueChanged<DialogColors> onTapColor;
  final DialogColors dotColor;
  final Color textColor;

  const TitleRow({Key key, this.title, this.onTapMenu, this.onTapColor, this.dotColor, this.textColor = Colors.white}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: DotButton(
            size: 30,
            padding: 0,
            color: DialogColorConvert.getColor(dotColor),
            dialogColor: dotColor,
            onTap: (DialogColors color) async {
              if (onTapColor != null) {
                onTapColor(await _showColorDialog(context));
              }
            },
          ),
        ),
        Expanded(child: Text(title, style: TextStyle(color: textColor))),
        onTapMenu != null ? IconButton(
          icon: Icon(Icons.more_vert, color: textColor),
          onPressed: () {
            if (onTapMenu != null) {
              onTapMenu(false);
            }
          },
        ) : Container()
      ],
    );
  }

  Future<DialogColors> _showColorDialog(BuildContext context) {
    return showDialog<DialogColors>(
        context: context,
        builder: (BuildContext dialogContext) {
          return DialogColor();
        });
  }
}

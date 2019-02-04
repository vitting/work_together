import 'package:flutter/material.dart';
import 'package:work_together/helpers/bottom_menu_action_enum.dart';

class BottomSheetEditDelete extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final ValueChanged<BottomMenuAction> onTap;

  const BottomSheetEditDelete(
      {Key key, this.backgroundColor, this.textColor, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Card(
            color: backgroundColor,
            child: ListTile(
              leading: Icon(
                Icons.edit,
                color: textColor,
              ),
              title: Text(
                "Rediger",
                style: TextStyle(color: textColor),
              ),
              onTap: () {
                if (onTap != null) {
                  onTap(BottomMenuAction.edit);
                }
              },
            ),
          ),
          Card(
            color: backgroundColor,
            child: ListTile(
              leading: Icon(Icons.delete_forever, color: textColor),
              title: Text("Slet", style: TextStyle(color: textColor)),
              onTap: () {
                if (onTap != null) {
                  onTap(BottomMenuAction.delete);
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:work_together/ui/widgets/dialog_color_widget.dart';

class DotButton extends StatelessWidget {
  final double padding;
  final double size;
  final Color color;
  final DialogColors dialogColor;
  final ValueChanged<DialogColors> onTap;

  const DotButton({Key key, this.padding = 15, this.size = 25, @required this.color, this.dialogColor, this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(45),
      splashColor: Colors.black26,
      onTap: () {
        if (onTap != null) {
          onTap(dialogColor);
        }
      },
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
      ),
    );
  }
}

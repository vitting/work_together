import 'package:flutter/material.dart';

class TextFieldWithBorder extends StatelessWidget {
  final TextEditingController controller;
  final int maxLength;
  final int maxLines;
  final Color color;
  final String label;
  final ValueChanged<String> onIconButtonPressed;

  const TextFieldWithBorder(
      {Key key,
      @required this.controller,
      this.maxLength,
      this.maxLines,
      this.color = Colors.blue,
      @required this.label,
      this.onIconButtonPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border:
                Border.all(color: color, style: BorderStyle.solid, width: 5)),
        child: TextField(
          maxLines: maxLines,
          maxLength: maxLength,
          keyboardType: TextInputType.text,
          controller: controller,
          cursorColor: color,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0),
              counterStyle: TextStyle(color: color),
              border: InputBorder.none,
              suffixIcon: onIconButtonPressed == null
                  ? null
                  : IconButton(
                      color: color,
                      icon: Icon(Icons.send),
                      onPressed: () {
                        if (onIconButtonPressed != null) {
                          onIconButtonPressed(controller.text);
                        }
                      }),
              labelStyle: TextStyle(color: color),
              labelText: label),
        ),
        padding: EdgeInsets.all(10));
  }
}

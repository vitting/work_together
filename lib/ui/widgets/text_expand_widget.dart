import 'package:flutter/material.dart';

class TextExpand extends StatefulWidget {
  final String text;
  final bool showExpanded;
  final Color textColor;
  final ValueChanged<bool> onTap;

  const TextExpand({Key key, this.text, this.showExpanded = false, this.textColor = Colors.black, this.onTap})
      : super(key: key);
  @override
  _TextExpandState createState() => _TextExpandState();
}

class _TextExpandState extends State<TextExpand> {
  int _maxLines = 2;
  TextOverflow _overflow = TextOverflow.ellipsis;

  @override
  void initState() {
    super.initState();
    
    if (widget.showExpanded) {
      _maxLines = null;
      _overflow = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Text(widget.text, maxLines: _maxLines, overflow: _overflow, style: TextStyle(color: widget.textColor)),
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap(true);
        }
      },
      onDoubleTap: () {
        if (!widget.showExpanded) {
          setState(() {
            if (_maxLines == null) {
              _maxLines = 2;
              _overflow = TextOverflow.ellipsis;
            } else {
              _maxLines = null;
              _overflow = null;
            }
          });
        }
      },
    );
  }
}

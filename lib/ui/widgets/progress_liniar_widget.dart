import 'package:flutter/material.dart';

class ProgressLiniar extends StatelessWidget {
  final int value;

  const ProgressLiniar({Key key, this.value}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    for (var i = 0; i < value; i++) {
      list.add(Padding(
        padding: const EdgeInsets.only(right: 1),
        child: Container(
          width: 6,
          height: 3,
          color: Colors.green[900],
        ),
      ));
    }
    
    for (var i = 0; i < (10 - value); i++) {
      list.add(Padding(
        padding: const EdgeInsets.only(right: 1),
        child: Container(
          width: 6,
          height: 3,
          color: Colors.grey[300],
        ),
      ));
    }

    return Container(
      child: Row(
        children: list,
      ),
    );
  }
}

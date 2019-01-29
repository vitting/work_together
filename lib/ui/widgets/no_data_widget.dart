import 'package:flutter/material.dart';

class NoData extends StatelessWidget {
  final String text;

  const NoData({Key key, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          // padding: EdgeInsets.all(10),
          width: 200,
          height: 200,
          decoration:
              BoxDecoration(color: Colors.blueGrey, shape: BoxShape.circle, border: Border.all(
                color: Colors.blueGrey[600],
                width: 10
              )),
          child: Center(
              child: Text(text,
                  style: TextStyle(fontSize: 16, color: Colors.white))),
        ),
      ],
    );
  }
}

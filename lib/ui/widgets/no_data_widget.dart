import 'package:flutter/material.dart';

class NoData extends StatelessWidget {
  final String text;
  final IconData icon;

  const NoData({Key key, this.text,this.icon}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
                color: Colors.blueGrey,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blueGrey[600], width: 10)),
            child: Stack(
              children: <Widget>[
                Positioned(
                  child: Center(child: Icon(icon, size: 70, color: Colors.blueGrey[700])),
                ),
                Positioned(
                    child: Center(
                        child: Text(text,
                            style:
                                TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)))),
              ],
            )),
      ],
    );
  }
}

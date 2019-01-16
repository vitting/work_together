import 'package:flutter/material.dart';
import 'package:work_together/ui/home/home.dart';
import 'package:work_together/ui/main/main_inheretedwidget.dart';

void main() async {
  runApp(MainInherited(
    child: MaterialApp(
      initialRoute: "/",
      routes: <String, WidgetBuilder>{
        "/": (BuildContext context) => Home()
      },
    ),
  ));
}

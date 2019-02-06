import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:work_together/ui/comment/comment_create.dart';
import 'package:work_together/ui/home/home.dart';
import 'package:work_together/ui/login/login_main.dart';
import 'package:work_together/ui/main/main_inheretedwidget.dart';
import 'package:work_together/ui/project/project_create.dart';
import 'package:work_together/ui/project/project_main.dart';
import 'package:work_together/ui/signup/signup_main.dart';
import 'package:work_together/ui/task/task_create.dart';

void main() async {
  final Firestore firestore = Firestore.instance;
  await firestore.settings(timestampsInSnapshotsEnabled: true);
  
  runApp(MainInherited(
    child: MaterialApp(
      initialRoute: "/",
      routes: <String, WidgetBuilder>{
        "/": (BuildContext context) => Home(),
        LoginMain.routeName: (BuildContext context) => LoginMain(),
        ProjectMain.routeName: (BuildContext context) => ProjectMain(),
        ProjectCreate.routeName: (BuildContext context) => ProjectCreate(),
        TaskCreate.routeName: (BuildContext context) => TaskCreate(),
        SignupMain.routeName: (BuildContext context) => SignupMain(),
        CommentCreate.routeName: (BuildContext context) => CommentCreate()
      },
    ),
  ));
}

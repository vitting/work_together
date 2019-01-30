import 'package:flutter/material.dart';
import 'package:work_together/ui/login/login_main.dart';
import 'package:work_together/ui/main/main_inheretedwidget.dart';
import 'package:work_together/ui/project/project_main.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() {
    return new HomeState();
  }
}

class HomeState extends State<Home> {
  Widget homeWidget;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (mounted) {
      setState(() {
        homeWidget = MainInherited.of(context).isLoggedIn == null
            ? Container(
                color: Colors.white,
                child: Center(child: CircularProgressIndicator()),
              )
            : MainInherited.of(context).isLoggedIn
                ? ProjectMain()
                : LoginMain();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return homeWidget;
  }
}

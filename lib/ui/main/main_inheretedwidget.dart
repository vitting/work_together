import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:work_together/helpers/user_auth.dart';
import 'package:work_together/helpers/user_data.dart';

class MainInherited extends StatefulWidget {
  final Widget child;

  const MainInherited({Key key, this.child}) : super(key: key);
  @override
  MainInheritedState createState() => new MainInheritedState();

  static MainInheritedState of([BuildContext context, bool rebuild = true]) {
    return (rebuild
            ? context.inheritFromWidgetOfExactType(_MainInherited)
                as _MainInherited
            : context.ancestorWidgetOfExactType(_MainInherited)
                as _MainInherited)
        .data;
  }
}

class MainInheritedState extends State<MainInherited> {
  bool canVibrate;
  String systemLanguageCode = "da";
  UserData userData;
  bool isLoggedIn;

  @override
  void initState() {
    super.initState();

    UserAuth.firebaseAuth.onAuthStateChanged.listen((FirebaseUser user) async {
      // print(user);

      if (user != null) {
        if (user.photoUrl != null) {
          userData = await UserData.initUser(user);
        }
      }
      
      if (mounted) {
        setState(() {
          isLoggedIn = user != null;
        });
      }
    });
  }

  void logout() async {
    setState(() {
      isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _MainInherited(
      data: this,
      child: widget.child,
    );
  }
}

class _MainInherited extends InheritedWidget {
  final MainInheritedState data;

  _MainInherited({Key key, this.data, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_MainInherited old) {
    return true;
  }
}

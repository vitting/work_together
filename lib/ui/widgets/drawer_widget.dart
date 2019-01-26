import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:work_together/helpers/config.dart';
import 'package:work_together/helpers/user_auth.dart';
import 'package:work_together/ui/main/main_inheretedwidget.dart';
import 'package:work_together/ui/widgets/circle_profile_image_widget.dart';

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scrollbar(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountEmail: Text(MainInherited.of(context).userData?.email),
              accountName: Text(MainInherited.of(context).userData?.name),
              currentAccountPicture: CircleProfileImage(
                type: CircleProfileImageType.url,
                image: MainInherited.of(context).userData.photoUrl,
                size: 80,
              ),
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.signOutAlt, color: Config.drawerIconColor),
              title: Text("Log ud"),
              onTap: () {
                Navigator.of(context).pop();
                UserAuth.logout();
              },
            )
          ],
        ),
      ),
    );
  }
}

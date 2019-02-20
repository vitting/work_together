import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:work_together/helpers/config.dart';
import 'package:work_together/helpers/project_data.dart';
import 'package:work_together/ui/main/main_inheretedwidget.dart';
import 'package:work_together/ui/project/participants/project_invite_users.dart';
import 'package:work_together/ui/widgets/dialog_color_widget.dart';
import 'package:work_together/ui/widgets/dot_icon_widget.dart';

class ProjectDrawerWidget extends StatelessWidget {
  final ProjectData project;

  const ProjectDrawerWidget({Key key, this.project}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scrollbar(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: DialogColorConvert.getColorFromInt(project.color)
              ),
              accountEmail: Text(project.title, maxLines: 2, style: TextStyle(fontWeight: FontWeight.bold, color: DialogColorConvert.getDialogTextColor(project.color))),
              accountName: Text("Projekt:", style: TextStyle(color: DialogColorConvert.getDialogTextColor(project.color))),
              currentAccountPicture: DotIcon(
                backgroundColor: DialogColorConvert.getDialogLightColor(project.color),
                iconColor: Colors.blueGrey,
                icon: FontAwesomeIcons.projectDiagram,
              ),
            ),
            MainInherited.of(context).userData.id == project.createdByUserId ? ListTile(
              leading: Icon(Icons.person_add, color: Config.drawerProjectIconColor),
              title: Text("Invitere projekt deltagere"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (BuildContext context) => ProjectInviteUsers(
                  project: project,
                )
              ));
              },
            ) : Container(),
          ],
        ),
      ),
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:work_together/helpers/bottom_menu_action_enum.dart';
import 'package:work_together/helpers/date_time_helpers.dart';
import 'package:work_together/helpers/project_data.dart';
import 'package:work_together/ui/project/detail/project_detail_main.dart';
import 'package:work_together/ui/project/project_create.dart';
import 'package:work_together/ui/widgets/dialog_color_widget.dart';
import 'package:work_together/ui/widgets/drawer_widget.dart';
import 'package:work_together/ui/widgets/title_row_widget.dart';

class ProjectMain extends StatelessWidget {
  static final String routeName = "projectmain";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: DrawerWidget(),
        appBar: AppBar(
          title: Text("Projekter")
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Navigator.of(context).pushNamed(ProjectCreate.routeName);
          },
          child: Icon(Icons.add),
        ),
        body: StreamBuilder(
          stream: ProjectData.getProjectsAsStream(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Container();
            } else {
              return Container(
                child: ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int position) {
                    ProjectData projectItem = ProjectData.fromMap(
                        snapshot.data.documents[position].data);
                    return Card(
                      child: ListTile(
                        title: TitleRow(
                          title: projectItem.title,
                          dotColor: DialogColorConvert.getDialogColor(projectItem.color),
                          onTapMenu: (_) async {
                            _showBottomMenuAction(context, await _showBottomMenu(context), projectItem);
                          },
                          onTapColor: (DialogColors color) {
                            projectItem.updateColor(DialogColorConvert.getColorValue(color));
                          },
                        ),
                        subtitle: Column(
                          children: <Widget>[
                            Text(projectItem.description,
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: Icon(Icons.access_time, size: 14),
                                    ),
                                    Text(
                                        DateTimeHelpers.ddmmyyyy(
                                            projectItem.createdDate),
                                        style: TextStyle(fontSize: 12))
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: Icon(Icons.comment, size: 14),
                                    ),
                                    Text("25",
                                        style: TextStyle(fontSize: 12)),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: Icon(Icons.person, size: 14),
                                    ),
                                    Text("Christian Nicolaisen",
                                        style: TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => ProjectDetailMain(
                              project: projectItem,
                            )
                          ));
                        },
                      ),
                    );
                  },
                ),
              );
            }
          },
        ));
  }

  Future<BottomMenuAction> _showBottomMenu(BuildContext context) {
    return showModalBottomSheet<BottomMenuAction>(
        context: context,
        builder: (BuildContext dialogContext) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.edit),
                title: Text("Rediger"),
                onTap: () {
                  Navigator.of(dialogContext).pop(BottomMenuAction.edit);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete_forever),
                title: Text("Slet"),
                onTap: () {
                  Navigator.of(dialogContext).pop(BottomMenuAction.delete);
                },
              )
            ],
          );
        });
  }

  void _showBottomMenuAction(
      BuildContext context, BottomMenuAction action, ProjectData item) {
    switch (action) {
      case BottomMenuAction.edit:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => ProjectCreate(project: item)));
        break;
      case BottomMenuAction.delete:
        break;
    }
  }
}

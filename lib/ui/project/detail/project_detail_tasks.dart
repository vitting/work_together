import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:work_together/helpers/bottom_menu_action_enum.dart';
import 'package:work_together/helpers/project_data.dart';
import 'package:work_together/helpers/task_data.dart';
import 'package:work_together/ui/task/task_create.dart';
import 'package:work_together/ui/widgets/dialog_color_widget.dart';
import 'package:work_together/ui/widgets/title_row_widget.dart';

class ProjectDetailTasks extends StatelessWidget {
  static final String routeName = "projectdetailtasks";

  final ProjectData project;

  const ProjectDetailTasks({Key key, this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: project.getTasksAsStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Text("Ingen Opgaver");
        }

        if (snapshot.hasData && snapshot.data.documents.length == 0) {
          return Text("Ingen Opgaver");
        }

        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (BuildContext context, int position) {
            DocumentSnapshot doc = snapshot.data.documents[position];
            TaskData task = TaskData.fromMap(doc.data);

            return Card(
              child: ListTile(
                title: TitleRow(
                  title: task.title,
                  dotColor: DialogColorConvert.getDialogColor(task.color),
                  onTapMenu: (_) async {
                    _showBottomMenuAction(
                        context, await _showBottomMenu(context), task);
                  },
                  onTapColor: (DialogColors color) {
                    task.updateColor(DialogColorConvert.getColorValue(color));
                  },
                ),
                subtitle: Text(task.description),
              ),
            );
          },
        );
      },
    );
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
      BuildContext context, BottomMenuAction action, TaskData item) {
    switch (action) {
      case BottomMenuAction.edit:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => TaskCreate(task: item)));
        break;
      case BottomMenuAction.delete:
        break;
    }
  }
}

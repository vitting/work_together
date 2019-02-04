import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:work_together/helpers/bottom_menu_action_enum.dart';
import 'package:work_together/helpers/config.dart';
import 'package:work_together/helpers/project_data.dart';
import 'package:work_together/helpers/task_data.dart';
import 'package:work_together/ui/task/task_create.dart';
import 'package:work_together/ui/task/task_row_widget.dart';
import 'package:work_together/ui/widgets/bottom_sheet_edit_delete_widget.dart';
import 'package:work_together/ui/widgets/dialog_color_widget.dart';
import 'package:work_together/ui/widgets/no_data_widget.dart';

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
          return Container();
        }

        if (snapshot.hasData && snapshot.data.documents.length == 0) {
          return NoData(
            text: "Ingen Opgaver",
            icon: FontAwesomeIcons.tasks,
          );
        }

        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (BuildContext context, int position) {
            DocumentSnapshot doc = snapshot.data.documents[position];
            TaskData task = TaskData.fromMap(doc.data);

            return TaskRow(
              task: task,
              backgroundColor: DialogColorConvert.getDialogLightColor(task.color),
              textColor: Config.rowTextColor,
              onTapColor: (DialogColors color) {
                if (color != null) {
                  task.updateColor(DialogColorConvert.getColorValue(color));
                }
              },
              onTapMenu: (_) async {
                _showBottomMenuAction(
                    context, await _showBottomMenu(context), task);
              },
              onTapRow: (TaskData item) {},
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
          return BottomSheetEditDelete(
            backgroundColor: Config.bottomSheetBackgroundColor,
            textColor: Config.bottomSheetTextColor,
            onTap: (BottomMenuAction action) {
              Navigator.of(dialogContext).pop(action);
            },
          );
        });
  }

  void _showBottomMenuAction(
      BuildContext context, BottomMenuAction action, TaskData item) {
    switch (action) {
      case BottomMenuAction.edit:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => TaskCreate(task: item, project: project)));
        break;
      case BottomMenuAction.delete:
        break;
    }
  }
}

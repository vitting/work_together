import 'package:flutter/material.dart';
import 'package:work_together/helpers/date_time_helpers.dart';
import 'package:work_together/helpers/task_data.dart';
import 'package:work_together/helpers/user_data.dart';
import 'package:work_together/ui/widgets/dialog_color_widget.dart';
import 'package:work_together/ui/widgets/text_expand_widget.dart';
import 'package:work_together/ui/widgets/title_row_widget.dart';

class TaskRow extends StatelessWidget {
  final TaskData task;
  final Color backgroundColor;
  final Color textColor;
  final ValueChanged<bool> onTapMenu;
  final ValueChanged<DialogColors> onTapColor;
  final ValueChanged<TaskData> onTapRow;

  const TaskRow(
      {Key key,
      this.task,
      this.backgroundColor = Colors.white,
      this.textColor = Colors.black,
      this.onTapMenu,
      this.onTapColor,
      this.onTapRow})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      child: ListTile(
        onTap: () {
          if (onTapRow != null) {
            onTapRow(task);
          }
        },
        title: TitleRow(
          title: task.title,
          textColor: textColor,
          dotColor: DialogColorConvert.getDialogColor(task.color),
          onTapMenu: onTapMenu,
          onTapColor: onTapColor,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            task.description.isEmpty
                ? Container()
                : Container(
                    padding: const EdgeInsets.only(left: 40, right: 35),
                    child: TextExpand(
                      textColor: textColor,
                      text: task.description,
                      onTap: (_) {
                        if (onTapRow != null) {
                          onTapRow(task);
                        }
                      },
                    ),
                  ),
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
                      child: Icon(
                        Icons.access_time,
                        size: 14,
                        color: textColor,
                      ),
                    ),
                    Text(DateTimeHelpers.ddmmyyyy(task.createdDate),
                        style: TextStyle(fontSize: 12, color: textColor))
                  ],
                ),
                FutureBuilder(
                  future: task.getCreatedByUser(),
                  builder:
                      (BuildContext context, AsyncSnapshot<UserData> snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }

                    UserData user = snapshot.data;
                    if (user != null) {
                      return Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child:
                                Icon(Icons.person, size: 14, color: textColor),
                          ),
                          Text(user.name,
                              style: TextStyle(fontSize: 12, color: textColor))
                        ],
                      );
                    } else {
                      return Container();
                    }
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:work_together/helpers/date_time_helpers.dart';
import 'package:work_together/helpers/project_data.dart';
import 'package:work_together/ui/widgets/dialog_color_widget.dart';
import 'package:work_together/ui/widgets/text_expand_widget.dart';
import 'package:work_together/ui/widgets/title_row_widget.dart';

class ProjectRow extends StatelessWidget {
  final ProjectData project;
  final ValueChanged<bool> onTapMenu;
  final ValueChanged<DialogColors> onTapColor;
  final ValueChanged<ProjectData> onTap;

  const ProjectRow(
      {Key key, this.project, this.onTapMenu, this.onTapColor, this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: TitleRow(
          title: project.title,
          dotColor: DialogColorConvert.getDialogColor(project.color),
          onTapMenu: onTapMenu,
          onTapColor: onTapColor,
        ),
        subtitle: Column(
          children: <Widget>[
            Container(
                padding: const EdgeInsets.only(left: 40, right: 35),
                child: TextExpand(
                  text: project.description,
                  onTap: (_) {
                    if (onTap != null) {
                      onTap(project);
                    }
                  },
              )),
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
                    Text(DateTimeHelpers.ddmmyyyy(project.createdDate),
                        style: TextStyle(fontSize: 12))
                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Icon(Icons.comment, size: 14),
                    ),
                    Text("25", style: TextStyle(fontSize: 12)),
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
          if (onTap != null) {
            onTap(project);
          }
        },
      ),
    );
  }
}

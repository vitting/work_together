import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:work_together/helpers/bottom_menu_action_enum.dart';
import 'package:work_together/helpers/comment_data.dart';
import 'package:work_together/helpers/date_time_helpers.dart';
import 'package:work_together/helpers/project_data.dart';
import 'package:work_together/ui/comment/dialog_create_comment_widget.dart';
import 'package:work_together/ui/main/main_inheretedwidget.dart';
import 'package:work_together/ui/widgets/no_data_widget.dart';
import 'package:work_together/ui/widgets/title_row_icon_widget.dart';

class ProjectDetailComments extends StatelessWidget {
  final ProjectData project;

  const ProjectDetailComments({Key key, this.project}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: project.getCommentsAsStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        if (snapshot.hasData && snapshot.data.documents.length == 0) {
          return NoData(
            text: "Ingen kommentar",
          );
        }

        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (BuildContext context, int position) {
            DocumentSnapshot doc = snapshot.data.documents[position];
            CommentData comment = CommentData.fromMap(doc.data);

            return Card(
              child: ListTile(
                title: TitleRowIcon(
                  onTapMenu: (_) async {
                    _bottomMenuAction(context, await _showBottomMenu(context), comment);
                  },
                  leading: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(comment.photoUrl),
                  ),
                  title: comment.name,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(comment.comment,
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Icon(Icons.calendar_today, size: 10),
                        ),
                        Text(DateTimeHelpers.ddmmyyyyHHnn(comment.commentDate),
                            style: TextStyle(fontSize: 12))
                      ],
                    )
                  ],
                ),
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

  void _bottomMenuAction(
      BuildContext context, BottomMenuAction action, CommentData item) async {
    try {
      switch (action) {
        case BottomMenuAction.edit:
          String comment = await showDialog<String>(
            context: context,
            builder: (BuildContext dialogContext) => DialogCreateComment(
              comment: item.comment,
            )
          );

          if (comment != null && comment.isNotEmpty) {
            MainInherited.of(context).showProgressLayer(true);
            item.comment = comment;
            await item.save();
            MainInherited.of(context).showProgressLayer(false);
          }
          break;
        case BottomMenuAction.delete:
          MainInherited.of(context).showProgressLayer(true);
          await item.delete();
          MainInherited.of(context).showProgressLayer(false);
          break;
      }
    } catch (e) {
      MainInherited.of(context).showProgressLayer(false);
      print(e);
    }
  }
}

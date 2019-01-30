import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:work_together/helpers/bottom_menu_action_enum.dart';
import 'package:work_together/helpers/comment_data.dart';
import 'package:work_together/helpers/project_data.dart';
import 'package:work_together/ui/comment/comment_create.dart';
import 'package:work_together/ui/comment/comment_detail.dart';
import 'package:work_together/ui/main/main_inheretedwidget.dart';
import 'package:work_together/ui/widgets/comment_row_widget.dart';
import 'package:work_together/ui/widgets/no_data_widget.dart';

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
            return CommentRow(
              comment: comment,
              onTapDescription: (_) {
                _gotoCommentDetail(context, comment);
              },
              onTapComment: (_) {
                _gotoCommentDetail(context, comment);
              },
              onTapMenu: (_) async {
                _bottomMenuAction(
                    context, await _showBottomMenu(context), comment);
              },
            );
          },
        );
      },
    );
  }

  void _gotoCommentDetail(BuildContext context, CommentData comment) {
    Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => CommentDetail(
                          comment: comment,
                        )));
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
              builder: (BuildContext dialogContext) => CommentCreate(
                    comment: item.comment,
                  ));

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

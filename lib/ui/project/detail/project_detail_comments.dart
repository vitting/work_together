import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:work_together/helpers/bottom_menu_action_enum.dart';
import 'package:work_together/helpers/comment_data.dart';
import 'package:work_together/helpers/config.dart';
import 'package:work_together/helpers/project_data.dart';
import 'package:work_together/ui/comment/comment_create.dart';
import 'package:work_together/ui/comment/comment_detail.dart';
import 'package:work_together/ui/comment/comment_row_widget.dart';
import 'package:work_together/ui/main/main_inheretedwidget.dart';
import 'package:work_together/ui/widgets/bottom_sheet_edit_delete_widget.dart';
import 'package:work_together/ui/widgets/dialog_color_widget.dart';
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
            icon: Icons.comment,
          );
        }

        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (BuildContext context, int position) {
            DocumentSnapshot doc = snapshot.data.documents[position];
            CommentData comment = CommentData.fromMap(doc.data);
            return CommentRow(
              comment: comment,
              backgroundColor:
                  DialogColorConvert.getDialogLightColor(project.color),
              textColor: Config.rowTextColor,
              onTapDescription: (_) {
                _gotoCommentDetail(context, comment, project.color);
              },
              onTapRow: (_) {
                _gotoCommentDetail(context, comment, project.color);
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

  void _gotoCommentDetail(BuildContext context, CommentData comment, int projectColor) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => CommentDetail(
              comment: comment,
              projectColor: projectColor,
            )));
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

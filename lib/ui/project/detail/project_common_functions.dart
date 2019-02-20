import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:work_together/helpers/comment_data.dart';
import 'package:work_together/helpers/file_data.dart';
import 'package:work_together/helpers/project_data.dart';
import 'package:work_together/ui/comment/comment_create.dart';
import 'package:work_together/ui/file/file_create.dart';
import 'package:work_together/ui/main/main_inheretedwidget.dart';
import 'package:work_together/ui/widgets/round_button_widget.dart';

void showUploadFileDialog(BuildContext context, ProjectData project) async {
    File pickedFile;

    int result = await showModalBottomSheet<int>(
        context: context,
        builder: (BuildContext bottomContext) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.image),
                title: Text("Galleri"),
                onTap: () {
                  Navigator.of(bottomContext).pop(0);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera),
                title: Text("Kamera"),
                onTap: () {
                  Navigator.of(bottomContext).pop(1);
                },
              )
            ],
          );
        });

    if (result != null) {
      try {
        MainInherited.of(context).showProgressLayer(true);
        pickedFile = await ImagePicker.pickImage(source: result == 0 ? ImageSource.gallery: ImageSource.camera);
        MainInherited.of(context).showProgressLayer(false);
      } catch (e) {
        MainInherited.of(context).showProgressLayer(false);
        if (e.toString().contains("extension_mismatch")) {
          await _showFileExtensionErrorDialog(context);
        }
      }

      if (pickedFile != null) {
        FileCreateData fileCreateData =
            await Navigator.of(context).push<FileCreateData>(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (BuildContext context) => FileCreate(
                      project: project,
                      path: pickedFile.path,
                    )));

        MainInherited.of(context).showProgressLayer(true);
        FileData fileData = await FileData.uploadFile(project.id,
            MainInherited.of(context).userData, pickedFile, fileCreateData);

        if (fileData != null) {
          fileData.type = "p";
          fileData.save();
        }

        MainInherited.of(context).showProgressLayer(false);
      }
    }
  }

  Future<void> _showFileExtensionErrorDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext dialogContext) => SimpleDialog(
              contentPadding: EdgeInsets.all(20),
              title: Text("Filtypen er ikke understøttet"),
              children: <Widget>[
                Text(
                    "Den valgte fil kan ikke gemmes da filtypen ikke understøttes"),
                SizedBox(height: 20),
                RoundButton(
                  text: "Ok",
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                )
              ],
            ));
  }

  void showCreateCommentDialog(BuildContext context, ProjectData project) async {
    String comment = await Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (BuildContext pageContext) => CommentCreate(
              project: project,
            )));

    if (comment != null && comment.isNotEmpty) {
      CommentData commentData = CommentData(
          comment: comment,
          projectId: project.id,
          name: MainInherited.of(context).userData.name,
          userId: MainInherited.of(context).userData.id,
          photoUrl: MainInherited.of(context).userData.photoUrl,
          type: "p");

      try {
        MainInherited.of(context).showProgressLayer(true);
        await commentData.save();
        MainInherited.of(context).showProgressLayer(false);
      } catch (e) {
        MainInherited.of(context).showProgressLayer(false);
        print(e);
      }
    }
  }
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:work_together/helpers/bottom_menu_action_enum.dart';
import 'package:work_together/helpers/config.dart';
import 'package:work_together/helpers/date_time_helpers.dart';
import 'package:work_together/helpers/file_data.dart';
import 'package:work_together/helpers/project_data.dart';
import 'package:work_together/ui/file/file_create.dart';
import 'package:work_together/ui/main/main_inheretedwidget.dart';
import 'package:work_together/ui/widgets/no_data_widget.dart';
import 'package:work_together/ui/widgets/title_row_icon_widget.dart';

class ProjectDetailFiles extends StatelessWidget {
  final ProjectData project;

  const ProjectDetailFiles({Key key, this.project}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: project.getFilesAsStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        if (snapshot.hasData && snapshot.data.documents.length == 0) {
          return NoData(
            text: "Ingen filer",
          );
        }

        // TODO: Info om dato og Person der uploaded billedet, med mulighed for at trykke og se userdata info

        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (BuildContext context, int position) {
            DocumentSnapshot doc = snapshot.data.documents[position];
            FileData file = FileData.fromMap(doc.data);
            return Card(
              child: ListTile(
                contentPadding: EdgeInsets.all(5),
                title: TitleRowIcon(
                  leading: _getIconImage(file),
                  title: "${file.originalFilename}.${file.extension}",
                  onTapMenu: (_) async {
                    _bottomMenuAction(
                        context, await _showBottomMenu(context), file);
                  },
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    file.description.isEmpty
                        ? Container()
                        : Container(
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            child: Text(file.description,
                                maxLines: 2, overflow: TextOverflow.ellipsis),
                          ),
                    SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Icon(Icons.calendar_today, size: 12),
                              ),
                              Flexible(
                                child: Text(
                                    DateTimeHelpers.ddmmyyyyHHnn(
                                        file.creationDate),
                                    style: TextStyle(fontSize: 12)),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Icon(Icons.person, size: 14),
                              ),
                              Expanded(
                                child: InkWell(
                                  child: Text(file.name,
                                      style: TextStyle(fontSize: 12)),
                                  onTap: () {},
                                ),
                              )
                            ],
                          ),
                        )
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
      BuildContext context, BottomMenuAction action, FileData item) async {
    try {
      switch (action) {
        case BottomMenuAction.edit:
          FileCreateData data = await Navigator.of(context)
              .push<FileCreateData>(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      FileCreate(fileData: item)));

          if (data != null) {
            item.originalFilename = data.name;
            item.description = data.comment;
            await item.save();
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

  dynamic _getIconImage(FileData file) {
    if (Config.isImage(file.extension)) {
      return CachedNetworkImage(
        imageUrl: file.downloadUrl,
        placeholder: Icon(Config.getFileIcon(file.extension), size: 30),
        errorWidget: Icon(Icons.error_outline),
        fit: BoxFit.cover,
        width: 40,
        height: 40,
      );
    } else {
      return Container(
        padding: EdgeInsets.all(5),
        child: Icon(Config.getFileIcon(file.extension), size: 30),
      );
    }
  }
}

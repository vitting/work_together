import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:work_together/helpers/bottom_menu_action_enum.dart';
import 'package:work_together/helpers/config.dart';
import 'package:work_together/helpers/project_data.dart';
import 'package:work_together/ui/main/main_inheretedwidget.dart';
import 'package:work_together/ui/project/detail/project_detail_main.dart';
import 'package:work_together/ui/project/project_create.dart';
import 'package:work_together/ui/project/project_row_widget.dart';
import 'package:work_together/ui/widgets/bottom_sheet_edit_delete_widget.dart';
import 'package:work_together/ui/widgets/dialog_color_widget.dart';
import 'package:work_together/ui/widgets/drawer_widget.dart';
import 'package:work_together/ui/widgets/loader_progress_widet.dart';
import 'package:work_together/ui/widgets/no_data_widget.dart';

class ProjectMain extends StatelessWidget {
  static final String routeName = "projectmain";

  @override
  Widget build(BuildContext context) {
    return LoaderProgress(
      showStream: MainInherited.of(context).loaderProgressStream,
      child: Scaffold(
          drawer: DrawerWidget(),
          appBar: AppBar(title: Text("Projekter")),
          floatingActionButton: FloatingActionButton(
            tooltip: "Opret nyt projekt",
            backgroundColor: Config.floatingActionButtonColor,
            onPressed: () async {
              Navigator.of(context).pushNamed(ProjectCreate.routeName);
            },
            child: Icon(Icons.add),
          ),
          body: StreamBuilder(
            stream: MainInherited.of(context, false).userData.getProjects(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }

              if (snapshot.hasData && snapshot.data.documents.length == 0) {
                return Center(
                    child: NoData(
                  text: "Ingen Projekter",
                ));
              }

              return Container(
                child: ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int position) {
                    ProjectData projectItem = ProjectData.fromMap(
                        snapshot.data.documents[position].data);

                    return ProjectRow(
                      backgroundColor: DialogColorConvert.getDialogLightColor(projectItem.color),
                      project: projectItem,
                      onTapMenu: (_) async {
                        _bottomMenuAction(context,
                            await _showBottomMenu(context), projectItem);
                      },
                      onTapColor: (DialogColors color) {
                        if (color != null) {
                          projectItem.updateColor(
                              DialogColorConvert.getColorValue(color));
                        }
                      },
                      onTap: (ProjectData project) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ProjectDetailMain(
                                  project: project,
                                )));
                      },
                    );
                  },
                ),
              );
            },
          )),
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

  void _bottomMenuAction(
      BuildContext context, BottomMenuAction action, ProjectData item) async {
    switch (action) {
      case BottomMenuAction.edit:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => ProjectCreate(project: item)));
        break;
      case BottomMenuAction.delete:
        MainInherited.of(context).showProgressLayer(true);
        await item.delete();
        MainInherited.of(context).showProgressLayer(false);
        break;
    }
  }
}

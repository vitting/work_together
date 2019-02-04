import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:work_together/helpers/comment_data.dart';
import 'package:work_together/helpers/config.dart';
import 'package:work_together/helpers/file_data.dart';
import 'package:work_together/helpers/project_data.dart';
import 'package:work_together/ui/comment/comment_create.dart';
import 'package:work_together/ui/file/file_create.dart';
import 'package:work_together/ui/main/main_inheretedwidget.dart';
import 'package:work_together/ui/project/detail/project_detail_comments.dart';
import 'package:work_together/ui/project/detail/project_detail_files.dart';
import 'package:work_together/ui/project/detail/project_detail_overview.dart';
import 'package:work_together/ui/project/detail/project_detail_tasks.dart';
import 'package:work_together/ui/project/drawer/project_drawer_widget.dart';
import 'package:work_together/ui/project/search/search_functions.dart';
import 'package:work_together/ui/task/task_create.dart';
import 'package:work_together/ui/widgets/bottom_navigation_bar_widget.dart';
import 'package:work_together/ui/widgets/dialog_color_widget.dart';
import 'package:work_together/ui/widgets/loader_progress_widet.dart';
import 'package:work_together/ui/widgets/round_button_widget.dart';

enum ProjectDetailType { dashboard, tasks, comments, files }

class ProjectDetailMain extends StatefulWidget {
  static final String routeName = "projectdetailmain";
  final ProjectData project;

  const ProjectDetailMain({Key key, this.project}) : super(key: key);

  @override
  _ProjectDetailMainState createState() => _ProjectDetailMainState();
}

class _ProjectDetailMainState extends State<ProjectDetailMain> {
  final PageController _pageController = PageController();
  List<Widget> _pages;
  int _page = 0;
  String _pageTitle = "";
  int _bottomBarIndex = 0;

  @override
  void initState() {
    super.initState();

    _pageTitle = _getTitle(_page);

    _pages = [
      ProjectDetailOverview(project: widget.project),
      ProjectDetailTasks(project: widget.project),
      ProjectDetailComments(project: widget.project),
      ProjectDetailFiles(project: widget.project)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return LoaderProgress(
      showStream: MainInherited.of(context).loaderProgressStream,
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBarWidget(
          project: widget.project,
            index: _bottomBarIndex,
            onTap: (int index) {
              setState(() {
                _bottomBarIndex = index;
                _pageController.jumpToPage(index);
              });
            }),
        endDrawer: ProjectDrawerWidget(
          project: widget.project,
        ),
        appBar: AppBar(
          backgroundColor: DialogColorConvert.getColor(DialogColorConvert.getDialogColor(widget.project.color)),
          actions: _page == 0
              ? null
              : <Widget>[
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      showProjectSearch(
                          context, widget.project, _getPageType(_page));
                    },
                  )
                ],
          title: Text(_pageTitle),
        ),
        floatingActionButton: _getFloatingActionButton(context, _page),
        body: PageView.builder(
          controller: _pageController,
          itemCount: _pages.length,
          itemBuilder: (BuildContext context, int page) {
            return _pages[page];
          },
          onPageChanged: (int page) {
            setState(() {
              _bottomBarIndex = page;
              _page = page;
              _pageTitle = _getTitle(page);
            });
          },
        ),
      ),
    );
  }

  String _getTitle(int page) {
    String title = "";
    switch (page) {
      case 0:
        title = "Oversigt";
        break;
      case 1:
        title = "Opgaver";
        break;
      case 2:
        title = "Kommentar";
        break;

      case 3:
        title = "Filer";
        break;
    }

    return title;
  }

  Widget _getFloatingActionButton(BuildContext context, int page) {
    Widget floatingActionButton;

    switch (page) {
      case 1:
        floatingActionButton = FloatingActionButton(
          tooltip: "Tilføj ny opgave",
          backgroundColor: DialogColorConvert.getColor(DialogColorConvert.getDialogColor(widget.project.color)),
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (BuildContext context) => TaskCreate(
                      project: widget.project,
                    )));
          },
        );
        break;
      case 2:
        floatingActionButton = FloatingActionButton(
          tooltip: "Tilføj kommentar",
          backgroundColor: DialogColorConvert.getColor(DialogColorConvert.getDialogColor(widget.project.color)),
          child: Icon(Icons.add_comment),
          onPressed: () {
            _showCreateCommentDialog(context);
          },
        );
        break;
      case 3:
        floatingActionButton = FloatingActionButton(
          tooltip: "Tilføj fil",
          backgroundColor: DialogColorConvert.getColor(DialogColorConvert.getDialogColor(widget.project.color)),
          child: Icon(Icons.file_upload),
          onPressed: () {
            _showUploadFileDialog(context);
          },
        );
        break;
    }

    return floatingActionButton;
  }

  void _showUploadFileDialog(BuildContext context) async {
    String path;
    try {
      MainInherited.of(context).showProgressLayer(true);
      path = await FlutterDocumentPicker.openDocument(
          params: FlutterDocumentPickerParams(
              allowedFileExtensions: Config.allowedFileExtensions));
      MainInherited.of(context).showProgressLayer(false);
    } catch (e) {
      MainInherited.of(context).showProgressLayer(false);
      if (e.toString().contains("extension_mismatch")) {
        await _showFileExtensionErrorDialog(context);
      }
    }

    if (path != null && path.isNotEmpty) {
      FileCreateData fileCreateData =
          await Navigator.of(context).push<FileCreateData>(MaterialPageRoute(
              fullscreenDialog: true,
              builder: (BuildContext context) => FileCreate(
                    project: widget.project,
                    path: path,
                  )));

      MainInherited.of(context).showProgressLayer(true);
      File file = File(path);
      FileData fileData = await FileData.uploadFile(widget.project.id,
          MainInherited.of(context).userData, file, fileCreateData);
      await _deleteFileFromCache(file);

      if (fileData != null) {
        fileData.type = "p";
        fileData.save();
      }

      MainInherited.of(context).showProgressLayer(false);
    }
  }

  Future<FileSystemEntity> _deleteFileFromCache(File file) async {
    FileSystemEntity fileSystemEntity;

    try {
      fileSystemEntity = await file.delete();
    } catch (e) {
      print("Error deleting file from cache: $e");
    }

    return fileSystemEntity;
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

  void _showCreateCommentDialog(BuildContext context) async {
    String comment = await Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (BuildContext pageContext) => CommentCreate(
          project: widget.project,
        )));

    if (comment != null && comment.isNotEmpty) {
      CommentData commentData = CommentData(
          comment: comment,
          projectId: widget.project.id,
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

  ProjectDetailType _getPageType(int page) {
    ProjectDetailType result;
    switch (page) {
      case 0:
        result = ProjectDetailType.dashboard;
        break;
      case 1:
        result = ProjectDetailType.tasks;
        break;
      case 2:
        result = ProjectDetailType.comments;
        break;
      case 3:
        result = ProjectDetailType.files;
        break;
    }

    return result;
  }
}

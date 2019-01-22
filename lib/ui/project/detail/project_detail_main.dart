import 'dart:math';
import 'package:flutter/material.dart';
import 'package:work_together/helpers/file_data.dart';
import 'package:work_together/helpers/project_data.dart';
import 'package:work_together/ui/project/detail/project_detail_comments.dart';
import 'package:work_together/ui/project/detail/project_detail_files.dart';
import 'package:work_together/ui/project/detail/project_detail_overview.dart';
import 'package:work_together/ui/project/detail/project_detail_tasks.dart';
import 'package:work_together/ui/task/task_create.dart';
import 'package:work_together/ui/widgets/bottom_navigation_bar_widget.dart';

class ProjectDetailMain extends StatefulWidget {
  static final String routeName = "projectdetailmain";
  final ProjectData project;

  const ProjectDetailMain({Key key, this.project}) : super(key: key);

  @override
  _ProjectDetailMainState createState() => _ProjectDetailMainState();
}

class _ProjectDetailMainState extends State<ProjectDetailMain> {
  PageController _pageController = PageController();
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
    return Scaffold(
      bottomNavigationBar: BottomNavigationBarWidget(
          index: _bottomBarIndex,
          onTap: (int index) {
            setState(() {
              _bottomBarIndex = index;
              _pageController.jumpToPage(index);
            });
          }),
      appBar: AppBar(
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
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              fullscreenDialog: true,
              builder: (BuildContext context) => TaskCreate(
                projectId: widget.project.id,
              )
            ));
          },
        );
        break;
      case 2:
        floatingActionButton = FloatingActionButton(
          tooltip: "Tilføj kommentar",
          child: Icon(Icons.add_comment),
          onPressed: () {
            Navigator.of(context).pushNamed(TaskCreate.routeName);
          },
        );
        break;
      case 3:
        floatingActionButton = FloatingActionButton(
          tooltip: "Tilføj fil",
          child: Icon(Icons.file_upload),
          onPressed: () {
            FileData f = FileData(
                extension: "jpg",
                projectId: widget.project.id,
                type: "p",
                name: "file_${Random().nextInt(1000).toString()}");

            f.save();
          },
        );
        break;
    }

    return floatingActionButton;
  }
}

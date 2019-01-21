import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:work_together/helpers/file_data.dart';
import 'package:work_together/helpers/project_data.dart';
import 'package:work_together/ui/project/detail/project_detail_comments.dart';
import 'package:work_together/ui/project/detail/project_detail_files.dart';
import 'package:work_together/ui/project/detail/project_detail_overview.dart';

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
      ProjectDetailComments(project: widget.project),
      ProjectDetailFiles(project: widget.project)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomBarIndex,
        onTap: (int index) {
          setState(() {
            _bottomBarIndex = index;
            _pageController.animateToPage(index,
                curve: Curves.easeInOut, duration: Duration(milliseconds: 500));
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), title: Text("Oversigt")),
          BottomNavigationBarItem(
              icon: Icon(Icons.comment), title: Text("Kommentar")),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.file), title: Text("Filer"))
        ],
      ),
      appBar: AppBar(
        title: Text(_pageTitle),
      ),
      floatingActionButton: _getFloatingActionButton(_page),
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
        title = "Kommentar";
        break;

      case 2:
        title = "Filer";
        break;
    }

    return title;
  }
  
  Widget _getFloatingActionButton(int page) {
    Widget floatingActionButton;

    switch (page) {
      case 1:
        floatingActionButton = FloatingActionButton(
              child: Icon(Icons.add_comment),
              onPressed: () {
               
              },
            );
        break;
      case 2:
        floatingActionButton = FloatingActionButton(
              child: Icon(Icons.file_upload),
              onPressed: () {
                FileData f = FileData(
                  extension: "jpg",
                  projectId: widget.project.id,
                  type: "p",
                  name: "file_${Random().nextInt(1000).toString()}"
                );
                
                f.save();
              },
            );
        break;
    }

    return floatingActionButton;
  }
}

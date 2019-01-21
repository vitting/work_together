import 'package:flutter/material.dart';
import 'package:work_together/helpers/project_data.dart';

class ProjectDetailOverview extends StatelessWidget {
  static final String routeName = "projectdetailoverview";
  final ProjectData project;

  const ProjectDetailOverview({Key key, this.project}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text("Overview"),
          Text(project.title)
        ],
      ),
    );
  }
}
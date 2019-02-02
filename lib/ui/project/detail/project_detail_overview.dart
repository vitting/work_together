import 'package:flutter/material.dart';
import 'package:work_together/helpers/project_data.dart';
import 'package:work_together/ui/project/detail/project_detail_participants.dart';

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
          Text(project.title),
          RaisedButton(
            child: Text("Add participants"),
            onPressed: () async {
              Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (BuildContext context) => ProjectDetailParticipants(
                  project: project,
                )
              ));
            },
          )
        ],
      ),
    );
  }


}
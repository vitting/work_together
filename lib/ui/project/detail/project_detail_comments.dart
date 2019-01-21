import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:work_together/helpers/project_data.dart';

class ProjectDetailComments extends StatelessWidget {
  final ProjectData project;

  const ProjectDetailComments({Key key, this.project}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: project.getCommentsAsStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Text("Ingen kommentar");
        }

        if (snapshot.hasData && snapshot.data.documents.length == 0) {
          return Text("Ingen kommentar");
        }

        return Container();
      },
    );
  }
}
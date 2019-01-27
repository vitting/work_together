import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:work_together/helpers/file_data.dart';
import 'package:work_together/helpers/project_data.dart';
import 'package:work_together/ui/widgets/no_data_widget.dart';

class ProjectDetailFiles extends StatelessWidget {
  final ProjectData project;

  const ProjectDetailFiles({Key key, this.project}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: project.getFilesAsStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if ((!snapshot.hasData) || snapshot.hasData && snapshot.data.documents.length == 0) {
          return NoData(
            text: "Ingen filer",
          );
        }

        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (BuildContext context, int position) {
            DocumentSnapshot doc = snapshot.data.documents[position];
            FileData file = FileData.fromMap(doc.data);
            return Card(
              child: ListTile(
                leading: Icon(FontAwesomeIcons.image),
                title: Text("${file.name}.${file.extension}"),
              ),
            );
          },
        );
      },
    );
  }
}

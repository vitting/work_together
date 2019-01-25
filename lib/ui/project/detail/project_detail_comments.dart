import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:work_together/helpers/comment_data.dart';
import 'package:work_together/helpers/config.dart';
import 'package:work_together/helpers/date_time_helpers.dart';
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

        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (BuildContext context, int position) {
            DocumentSnapshot doc = snapshot.data.documents[position];
            CommentData comment = CommentData.fromMap(doc.data);

            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: CachedNetworkImage(
                    imageUrl: comment.photoUrl ?? Config.noProfilePicture,
                  ),
                ),
                title: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(comment.name),
                    )
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(comment.comment,
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Icon(Icons.calendar_today, size: 10),
                        ),
                        Text(DateTimeHelpers.ddmmyyyyHHnn(comment.commentDate),
                            style: TextStyle(fontSize: 12))
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
}

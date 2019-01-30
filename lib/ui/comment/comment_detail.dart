import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:work_together/helpers/comment_data.dart';
import 'package:work_together/helpers/system_helpers.dart';
import 'package:work_together/helpers/user_data.dart';
import 'package:work_together/ui/main/main_inheretedwidget.dart';
import 'package:work_together/ui/widgets/comment_row_widget.dart';
import 'package:work_together/ui/widgets/loader_progress_widet.dart';
import 'package:work_together/ui/widgets/textfield_with_border_widget.dart';

class CommentDetail extends StatefulWidget {
  final CommentData comment;

  const CommentDetail({Key key, this.comment}) : super(key: key);

  @override
  CommentDetailState createState() {
    return new CommentDetailState();
  }
}

class CommentDetailState extends State<CommentDetail> {
  TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderProgress(
      showStream: MainInherited.of(context).loaderProgressStream,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[700],
          title: Text("Kommentar"),
        ),
        body: Container(
          child: Scrollbar(
            child: ListView(
              primary: false,
              shrinkWrap: false,
              children: <Widget>[
                CommentRow(
                  showExpanded: true,
                  textColor: Colors.white,
                  backgroundColor: Colors.blue[700],
                  comment: widget.comment,
                ),
                TextFieldWithBorder(
                    controller: _commentController,
                    label: "Tilføj kommentar",
                    color: Colors.deepOrange,
                    maxLength: 10000,
                    maxLines: 2,
                    onIconButtonPressed: (String value) async {
                      if (value.isNotEmpty) {
                        await _saveComment(_commentController.text,
                            widget.comment, MainInherited.of(context).userData);

                        _commentController.text = "";
                        SystemHelpers.hideKeyboardWithNoFocus(context);
                      }
                    }),
                StreamBuilder(
                  stream: widget.comment.getSubComments(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData ||
                        (snapshot.hasData &&
                            snapshot.data.documents.length == 0)) {
                      return Container();
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (BuildContext context, int position) {
                        DocumentSnapshot doc =
                            snapshot.data.documents[position];
                        CommentData subComment = CommentData.fromMap(doc.data);

                        return CommentRow(
                          textColor: Colors.white,
                          backgroundColor: Colors.deepOrange,
                          showExpanded: true,
                          comment: subComment,
                        );
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveComment(
      String text, CommentData comment, UserData user) async {
    CommentData newComment = CommentData.subComment(comment, text, user);
    MainInherited.of(context).showProgressLayer(true);
    await newComment.save();
    MainInherited.of(context).showProgressLayer(false);
  }
}

import 'package:flutter/material.dart';
import 'package:work_together/helpers/project_data.dart';
import 'package:work_together/ui/widgets/dialog_color_widget.dart';
import 'package:work_together/ui/widgets/dot_icon_widget.dart';
import 'package:work_together/ui/widgets/round_button_widget.dart';

class CommentCreate extends StatefulWidget {
  static final String routeName = "commentcreate";
  final ProjectData project;
  final String comment;

  const CommentCreate({Key key, this.project, this.comment = ""}) : super(key: key);

  @override
  CommentCreateState createState() {
    return new CommentCreateState();
  }
}

class CommentCreateState extends State<CommentCreate> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _buttonText = "Opret";
  Color _backgroundColor;

  @override
  void initState() {
    super.initState();
    _backgroundColor = DialogColorConvert.getColor(DialogColorConvert.getDialogColor(widget.project.color));
    if (widget.comment != null && widget.comment.isNotEmpty) {
      _buttonText = "Gem";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        title: Text("Skriv kommentar"),
      ),
      body: Card(
        child: Container(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      DotIcon(
                        icon: Icons.comment,
                        backgroundColor: _backgroundColor,
                      ),
                      TextFormField(
                          initialValue: widget.comment,
                          maxLines: 5,
                          maxLength: 10000,
                          decoration: InputDecoration(labelText: "Kommentar"),
                          onSaved: (String value) {
                            Navigator.of(context).pop(value);
                          }),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: RoundButton(
                          backgroundColor: _backgroundColor,
                          text: _buttonText,
                          onPressed: () {
                            _formKey.currentState.save();
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}

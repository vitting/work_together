import 'package:flutter/material.dart';
import 'package:work_together/ui/widgets/dot_icon_widget.dart';
import 'package:work_together/ui/widgets/round_button_widget.dart';

class CommentCreate extends StatefulWidget {
  static final String routeName = "commentcreate";
  final String comment;

  const CommentCreate({Key key, this.comment = ""}) : super(key: key);

  @override
  CommentCreateState createState() {
    return new CommentCreateState();
  }
}

class CommentCreateState extends State<CommentCreate> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _buttonText = "Opret";

  @override
  void initState() {
    super.initState();

    if (widget.comment != null && widget.comment.isNotEmpty) {
      _buttonText = "Gem";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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

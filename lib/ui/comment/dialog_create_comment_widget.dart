import 'package:flutter/material.dart';

class DialogCreateComment extends StatefulWidget {
  final String comment;
  
  const DialogCreateComment({Key key, this.comment = ""}) : super(key: key);

  @override
  DialogCreateCommentState createState() {
    return new DialogCreateCommentState();
  }
}

class DialogCreateCommentState extends State<DialogCreateComment> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text("Skriv kommentar"),
      contentPadding: EdgeInsets.all(10),
      children: <Widget>[
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: widget.comment,
                maxLines: 4,
                maxLength: 500,
                onSaved: (String value) {
                  Navigator.of(context).pop(value);
                },
                decoration: InputDecoration(
                    labelText: "Kommentar",
                    suffix: IconButton(
                      icon: Icon(Icons.insert_comment),
                      onPressed: () {
                       _formKey.currentState.save();
                      },
                    )),
              )
            ],
          ),
        )
      ],
    );
  }
}

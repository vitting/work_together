import 'package:flutter/material.dart';
import 'package:work_together/ui/widgets/round_button_widget.dart';

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
      contentPadding: EdgeInsets.all(20),
      children: <Widget>[
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: widget.comment,
                maxLines: 4,
                maxLength: 1000,
                onSaved: (String value) {
                  Navigator.of(context).pop(value);
                },
                decoration: InputDecoration(
                    labelText: "Kommentar",
                    suffix: IconButton(
                      color: Colors.blue[700],
                      icon: Icon(Icons.comment),
                      onPressed: () {
                       _formKey.currentState.save();
                      },
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: RoundButton(
                  text: "Fortryd",
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

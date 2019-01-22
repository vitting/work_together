import 'package:flutter/material.dart';
import 'package:work_together/helpers/project_data.dart';
import 'package:work_together/ui/main/main_inheretedwidget.dart';
import 'package:work_together/ui/widgets/dialog_color_widget.dart';
import 'package:work_together/ui/widgets/dot_button_widget.dart';

class ProjectCreate extends StatefulWidget {
  static final String routeName = "projectcreate";
  final ProjectData project;

  const ProjectCreate({Key key, this.project}) : super(key: key);

  @override
  ProjectCreateState createState() {
    return new ProjectCreateState();
  }
}

class ProjectCreateState extends State<ProjectCreate> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Color _dotColor;
  DialogColors _dialogColors;
  ProjectData _project;

  @override
    void initState() {
      super.initState();

      if (widget.project != null) {
        _project = widget.project;
        _dialogColors = DialogColorConvert.getDialogColor(_project.color);
        _dotColor = DialogColorConvert.getColor(_dialogColors);
      } else {
        _dialogColors = DialogColorConvert.getDialogColor(0);
        _dotColor = DialogColorConvert.getColor(_dialogColors);
        _project = ProjectData();
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Opret projekt"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _project.title,
                autofocus: true,
                maxLength: 100,                
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Titel"
                ),
                validator: (String value) {
                  if (value.trim().isEmpty) {
                    return "Udfyld titel";
                  }
                },
                onSaved: (String value) {
                  _project.title = value.trim();
                },
              ),
              TextFormField(
                initialValue: _project.description,
                maxLength: 1000,
                maxLines: 10,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Beskrivelse"
                ),
                onSaved: (String value) {
                  _project.description = value.trim();
                },
              ),
              Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Project farve"),
                      DotButton(
                    size: 50,
                    color: _dotColor,
                    dialogColor: _dialogColors,
                    onTap: (DialogColors color) async {
                      DialogColors choosenColor =
                          await _showColorDialog(context);
                      if (choosenColor != null) {
                        _project.color =
                            DialogColorConvert.getColorValue(choosenColor);
                        setState(() {
                          _dialogColors = choosenColor;
                          _dotColor = DialogColorConvert.getColor(choosenColor);
                        });
                      }
                    },
                  )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
              FlatButton.icon(
                icon: Icon(Icons.check),
                label: Text("Opret"),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    _project.updatedByUserId = MainInherited.of(context).userData.id;
                    await _project.save();
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<DialogColors> _showColorDialog(BuildContext context) {
    return showDialog<DialogColors>(
        context: context,
        builder: (BuildContext dialogContext) {
          return DialogColor();
        });
  }
}
import 'package:flutter/material.dart';
import 'package:work_together/helpers/project_data.dart';

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
  ProjectData _project;

  @override
    void initState() {
      super.initState();

      if (widget.project != null) {
        _project = widget.project;
      } else {
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
              FlatButton.icon(
                icon: Icon(Icons.check),
                label: Text("Opret"),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
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
}
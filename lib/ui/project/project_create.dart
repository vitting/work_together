import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:work_together/helpers/project_data.dart';
import 'package:work_together/ui/main/main_inheretedwidget.dart';
import 'package:work_together/ui/widgets/dot_icon_widget.dart';
import 'package:work_together/ui/widgets/loader_progress_widet.dart';
import 'package:work_together/ui/widgets/round_button_widget.dart';

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
  String _pageTitle;
  String _buttonText = "Opret";

  @override
  void initState() {
    super.initState();

    if (widget.project != null) {
      _buttonText = "Gem";
      _pageTitle = "Redigere project";
      _project = widget.project;
    } else {
      _pageTitle = "Opret project";
      _project = ProjectData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoaderProgress(
      showStream: MainInherited.of(context).loaderProgressStream,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_pageTitle),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                DotIcon(
                  icon: FontAwesomeIcons.projectDiagram,
                ),
                TextFormField(
                  initialValue: _project.title,
                  // autofocus: true,
                  inputFormatters: [LengthLimitingTextInputFormatter(200)],
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: "Titel"),
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
                  inputFormatters: [LengthLimitingTextInputFormatter(10000)],
                  maxLines: 10,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: "Beskrivelse"),
                  onSaved: (String value) {
                    _project.description = value.trim();
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                RoundButton(
                    text: _buttonText,
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        _project.updatedByUserId =
                            MainInherited.of(context).userData.id;
                        MainInherited.of(context).showProgressLayer(true);
                        await _project. save();
                        MainInherited.of(context).showProgressLayer(false);
                        Navigator.of(context).pop();
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}

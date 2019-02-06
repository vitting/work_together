import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:work_together/helpers/project_data.dart';
import 'package:work_together/helpers/task_data.dart';
import 'package:work_together/ui/main/main_inheretedwidget.dart';
import 'package:work_together/ui/widgets/dialog_color_widget.dart';
import 'package:work_together/ui/widgets/dot_icon_widget.dart';
import 'package:work_together/ui/widgets/round_button_widget.dart';

class TaskCreate extends StatefulWidget {
  static final String routeName = "taskcreate";
  final TaskData task;
  final ProjectData project;

  const TaskCreate({Key key, this.task, this.project}) : super(key: key);

  @override
  TaskCreateState createState() {
    return new TaskCreateState();
  }
}

class TaskCreateState extends State<TaskCreate> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  TaskData _task;
  String _pageTitle;
  Color _backgroundColor;

  @override
  void initState() {
    super.initState();

    _backgroundColor = DialogColorConvert.getColor(DialogColorConvert.getDialogColor(widget.project.color));
    if (widget.task != null) {
      _pageTitle = "Redigere opgave";
      _task = widget.task;
    } else {
      _pageTitle = "Opret opgave";
      _task = TaskData(projectId: widget.project.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        title: Text(_pageTitle),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: DotIcon(
                backgroundColor: _backgroundColor,
                icon: FontAwesomeIcons.tasks,
              ),
            ),
            Form(
              key: _form,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    initialValue: _task.title,
                    decoration: InputDecoration(labelText: "Titel"),
                    inputFormatters: [LengthLimitingTextInputFormatter(200)],
                    autofocus: false,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "Titel skal udfyldes";
                      }
                    },
                    onSaved: (String value) {
                      _task.title = value.trim();
                    },
                  ),
                  TextFormField(
                    initialValue: _task.description,
                    maxLines: 5,
                    inputFormatters: [LengthLimitingTextInputFormatter(10000)],
                    decoration: InputDecoration(labelText: "Beskrivelse"),
                    onSaved: (String value) {
                      _task.description = value.trim();
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RoundButton(
                    text: "Opret",
                    backgroundColor: _backgroundColor,
                    onPressed: () async {
                      if (_form.currentState.validate()) {
                        _form.currentState.save();
                        _task.updatedByUserId =
                            MainInherited.of(context).userData.id;
                        await _task.save();
                        Navigator.of(context).pop();
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

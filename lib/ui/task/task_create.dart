import 'package:flutter/material.dart';
import 'package:work_together/helpers/task_data.dart';
import 'package:work_together/ui/main/main_inheretedwidget.dart';
import 'package:work_together/ui/widgets/dialog_color_widget.dart';
import 'package:work_together/ui/widgets/dot_button_widget.dart';

class TaskCreate extends StatefulWidget {
  static final String routeName = "taskcreate";
  final TaskData task;
  final String projectId;

  const TaskCreate({Key key, this.task, this.projectId}) : super(key: key);

  @override
  TaskCreateState createState() {
    return new TaskCreateState();
  }
}

class TaskCreateState extends State<TaskCreate> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  Color _dotColor;
  DialogColors _dialogColors;
  TaskData _task;

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      _task = widget.task;
      _dialogColors = DialogColorConvert.getDialogColor(_task.color);
      _dotColor = DialogColorConvert.getColor(_dialogColors);
    } else {
      _dialogColors = DialogColorConvert.getDialogColor(0);
      _dotColor = DialogColorConvert.getColor(_dialogColors);
      _task = TaskData(projectId: widget.projectId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Opret Opgave"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Form(
              key: _form,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    initialValue: _task.title,
                    decoration: InputDecoration(labelText: "Titel"),
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
                    decoration: InputDecoration(labelText: "Beskrivelse"),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "Beskrivelse skal udfyldes";
                      }
                    },
                    onSaved: (String value) {
                      _task.description = value.trim();
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Opgave farve"),
                      DotButton(
                    size: 50,
                    color: _dotColor,
                    dialogColor: _dialogColors,
                    onTap: (DialogColors color) async {
                      DialogColors choosenColor =
                          await _showColorDialog(context);
                      if (choosenColor != null) {
                        _task.color =
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

  Future<DialogColors> _showColorDialog(BuildContext context) {
    return showDialog<DialogColors>(
        context: context,
        builder: (BuildContext dialogContext) {
          return DialogColor();
        });
  }
}

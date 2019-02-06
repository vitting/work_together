import 'package:flutter/material.dart';
import 'package:work_together/helpers/sub_task_data.dart';
import 'package:work_together/ui/main/main_inheretedwidget.dart';

class SubTaskRow extends StatefulWidget {
  final SubTaskData subTask;
  final Color backgroundColor;
  final Color activeCheckcolor;
  final Color dismissColor;
  final ValueChanged<bool> onDismissed;
  final ValueChanged<SubTaskData> onTap;

  const SubTaskRow(
      {Key key,
      this.subTask,
      this.onDismissed,
      this.backgroundColor,
      this.activeCheckcolor,
      this.dismissColor,
      this.onTap})
      : super(key: key);
  @override
  _SubTaskRowState createState() => _SubTaskRowState();
}

class _SubTaskRowState extends State<SubTaskRow> {
  bool _state = false;

  @override
  void initState() {
    super.initState();

    _state = widget.subTask.closed;
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: ObjectKey(widget.subTask),
        dismissThresholds: {DismissDirection.startToEnd: 0.6},
        direction: DismissDirection.startToEnd,
        background: Card(
            child: Container(
          color: widget.dismissColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text("Stryg til højre for at slette",
                    style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        )),
        onDismissed: (DismissDirection value) async {
          ScaffoldFeatureController a =
              Scaffold.of(context).showSnackBar(SnackBar(
            duration: Duration(seconds: 2),
            content: Text("Sletter del opgaven"),
            action: SnackBarAction(
              label: "Fortryd",
              onPressed: () {},
            ),
          ));

          SnackBarClosedReason reason = await a.closed;
          bool undo = reason == SnackBarClosedReason.action;
          if (widget.onDismissed != null) {
            widget.onDismissed(undo);
          }
        },
        child: Card(
            color: widget.backgroundColor,
            child: ListTile(
                onTap: () {
                  widget.onTap(widget.subTask);
                },
                title: Text(widget.subTask.title,
                    style: TextStyle(
                        fontWeight:
                            _state ? FontWeight.bold : FontWeight.normal)),
                leading: Checkbox(
                  activeColor: widget.activeCheckcolor,
                  value: _state,
                  onChanged: (bool value) async {
                    await widget.subTask.subTaskState(
                        MainInherited.of(context).userData.id, value);
                    setState(() {
                      _state = value;
                    });
                  },
                ))));
  }
}

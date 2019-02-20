import 'package:flutter/material.dart';
import 'package:work_together/helpers/date_time_helpers.dart';
import 'package:work_together/helpers/sub_task_data.dart';
import 'package:work_together/helpers/user_data.dart';
import 'package:work_together/ui/main/main_inheretedwidget.dart';

class SubTaskRow extends StatefulWidget {
  final SubTaskData subTask;
  final Color backgroundColor;
  final Color activeCheckcolor;
  final Color dismissColor;
  final Color textColor;
  final ValueChanged<bool> onDismissed;
  final ValueChanged<SubTaskData> onTap;
  final ValueChanged<bool> onCheckboxTap;

  const SubTaskRow(
      {Key key,
      this.subTask,
      this.onDismissed,
      this.backgroundColor,
      this.activeCheckcolor,
      this.dismissColor,
      this.onCheckboxTap,
      this.textColor,
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
                  if (!_state) {
                    widget.onTap(widget.subTask);
                  }
                },
                title: Text(widget.subTask.title,
                    style: TextStyle(
                        fontWeight:
                            _state ? FontWeight.bold : FontWeight.normal)),
                subtitle: !widget.subTask.closed
                    ? null
                    : FutureBuilder(
                        future: widget.subTask.getClosedByUser(),
                        builder: (BuildContext context,
                            AsyncSnapshot<UserData> snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          }

                          String name = snapshot.data.name;
                          return Column(
                            children: <Widget>[
                              SizedBox(height: 5),
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Icon(
                                      Icons.calendar_today,
                                      size: 14,
                                      color: widget.textColor,
                                    ),
                                  ),
                                  Text(
                                      DateTimeHelpers.ddmmyyyyHHnn(
                                          widget.subTask.closedDate),
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: widget.textColor))
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Icon(Icons.person,
                                        size: 14, color: widget.textColor),
                                  ),
                                  Text(name,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: widget.textColor))
                                ],
                              )
                            ],
                          );
                        },
                      ),
                leading: Checkbox(
                  activeColor: widget.activeCheckcolor,
                  value: _state,
                  onChanged: (bool value) async {
                    await widget.subTask.subTaskState(
                        MainInherited.of(context).userData.id, value);
                    setState(() {
                      _state = value;
                    });

                    if (widget.onCheckboxTap != null) {
                      widget.onCheckboxTap(value);
                    }
                  },
                ))));
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_together/helpers/config.dart';
import 'package:work_together/helpers/sub_task_data.dart';
import 'package:work_together/helpers/task_data.dart';
import 'package:work_together/helpers/user_data.dart';
import 'package:work_together/ui/main/main_inheretedwidget.dart';
import 'package:work_together/ui/task/sub_task_row.dart';
import 'package:work_together/ui/widgets/dialog_color_widget.dart';
import 'package:work_together/ui/widgets/loader_progress_widet.dart';
import 'package:work_together/ui/widgets/no_data_widget.dart';
import 'package:work_together/ui/widgets/round_button_widget.dart';

class TaskDetail extends StatefulWidget {
  static final String routeName = "taskdetail";
  final TaskData task;

  const TaskDetail({Key key, this.task}) : super(key: key);

  @override
  TaskDetailState createState() {
    return new TaskDetailState();
  }
}

///TODO: Vis info om subtask / task  og projekt
class TaskDetailState extends State<TaskDetail> {
  List<SubTaskData> _items;
  final Future<SharedPreferences> _prefsInstance =
      SharedPreferences.getInstance();
  SharedPreferences _prefs;
  Map<String, dynamic> _orderMap;
  @override
  void initState() {
    super.initState();

    _getSubTasks();
  }

  void _getSubTasks() async {
    List<SubTaskData> items = await widget.task.getSubTasks();
    _orderMap = await _getListOrder();
    if (_orderMap == null) {
      _orderMap = await _saveListOrder(items);
    }
    List<SubTaskData> itemsOrdered = await _orderList(items);

    setState(() {
      _items = itemsOrdered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor:
              DialogColorConvert.getColorFromInt(widget.task.color),
          title: Text("Under opgaver"),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor:
              DialogColorConvert.getColorFromInt(widget.task.color),
          onPressed: () async {
            String text = await _showSubTaskEditDialog(context);
            if (text != null && text.isNotEmpty) {
              _createSubTask(MainInherited.of(context).userData, text);
            }
          },
          child: Icon(Icons.add),
        ),
        body: _items == null
            ? Container()
            : _items.length == 0
                ? Center(
                    child: NoData(
                      icon: FontAwesomeIcons.tasks,
                      text: "Ingen under opgaver",
                    ),
                  )
                : LoaderProgress(
                    showStream: MainInherited.of(context).loaderProgressStream,
                    color:
                        DialogColorConvert.getColorFromInt(widget.task.color),
                    child: Container(
                      child: _getList(),
                    ),
                  ));
  }

  Widget _getList() {
    if (_items.length == 1) {
      return _createSubTaskRow(_items[0], 0);
    } else {
      return Scrollbar(
        child: DragAndDropList<SubTaskData>(
          _items,
          itemBuilder: (BuildContext context, item) {
            int index = _items.indexOf(item);
            return _createSubTaskRow(item, index);
          },
          canBeDraggedTo: (int oldIndex, int newIndex) {
            return true;
          },
          onDragFinish: (int before, int after) async {
            SubTaskData data = _items[before];
            _items.removeAt(before);
            _items.insert(after, data);
            _orderMap = await _saveListOrder(_items);
          },
          dragElevation: 8,
        ),
      );
    }
  }

  void _createSubTask(UserData user, String text) async {
    MainInherited.of(context).showProgressLayer(true);
    SubTaskData subTask = SubTaskData(
      title: text,
      createdByUserId: user.id,
      projectId: widget.task.projectId,
      taskId: widget.task.id,
    );

    await subTask.save();
    setState(() {
      _items.add(subTask);
    });
    MainInherited.of(context).showProgressLayer(false);
  }

  Future<String> _showSubTaskEditDialog(BuildContext context,
      [SubTaskData subTask]) {
    String text = subTask == null ? "" : subTask.title;
    GlobalKey<FormState> _formState = GlobalKey<FormState>();
    return showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return SimpleDialog(
            titlePadding: EdgeInsets.all(0),
            contentPadding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[CloseButton()],
            ),
            children: <Widget>[
              Form(
                key: _formState,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      maxLines: 2,
                      decoration: InputDecoration(labelText: "Tekst"),
                      initialValue: text,
                      validator: (String value) {
                        if (value.trim().isEmpty) {
                          return "Feltet skal udfyldes";
                        }
                      },
                      onEditingComplete: () {
                        if (_formState.currentState.validate()) {
                          _formState.currentState.save();
                        }
                      },
                      onSaved: (String value) {
                        Navigator.of(dialogContext).pop(value);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 10),
                      child: RoundButton(
                        backgroundColor: DialogColorConvert.getColorFromInt(
                            widget.task.color),
                        text: "Gem",
                        onPressed: () {
                          if (_formState.currentState.validate()) {
                            _formState.currentState.save();
                          }
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        });
  }

  Widget _createSubTaskRow(SubTaskData subTask, int index) {
    return SubTaskRow(
      textColor: Config.rowTextColor,
      subTask: subTask,
      onTap: (_) async {
        String text = await _showSubTaskEditDialog(context, subTask);
        if (text != null && text.isNotEmpty) {
          MainInherited.of(context).showProgressLayer(true);
          await subTask.updateTitle(text);
          setState(() {});
          MainInherited.of(context).showProgressLayer(false);
        }
      },
      onDismissed: (bool undo) async {
        _items.removeAt(index);
        if (undo) {
          _items.insert(index, subTask);
        } else {
          await subTask.delete();
          _orderMap = await _saveListOrder(_items);
        }

        setState(() {});
      },
      onCheckboxTap: (_) {
        _getSubTasks();
      },
      backgroundColor:
          DialogColorConvert.getDialogLightColor(widget.task.color),
      activeCheckcolor: DialogColorConvert.getColorFromInt(widget.task.color),
      dismissColor: DialogColorConvert.getColorFromInt(widget.task.color),
    );
  }

  Future<Map<String, dynamic>> _saveListOrder(
      List<SubTaskData> subTasks) async {
    Map<String, dynamic> orderMap = Map<String, dynamic>();
    if (_prefs == null) {
      _prefs = await _prefsInstance;
    }

    for (var i = 0; i < subTasks.length; i++) {
      orderMap.putIfAbsent(subTasks[i].id, () => i);
    }

    String stringMap = json.encode(orderMap);

    await _prefs.setString(widget.task.id, stringMap);

    return orderMap;
  }

  Future<Map<String, dynamic>> _getListOrder() async {
    if (_prefs == null) {
      _prefs = await _prefsInstance;
    }

    String stringMap = _prefs.getString(widget.task.id);

    if (stringMap == null) {
      return null;
    }

    return json.decode(stringMap);
  }

  Future<List<SubTaskData>> _orderList(List<SubTaskData> subTasks) async {
    if (_orderMap == null) {
      _orderMap = await _getListOrder();
    }
    List<SubTaskData> subTasksCopy = List<SubTaskData>.filled(
        _orderMap.length, SubTaskData.dummy(),
        growable: true);

    subTasks.forEach((SubTaskData data) {
      if (_orderMap[data.id] != null) {
        int index = _orderMap[data.id].toInt();
        subTasksCopy.removeAt(index);
        subTasksCopy.insert(index, data);
      } else {
        subTasksCopy.add(data);
      }
    });

    return subTasksCopy;
  }
}

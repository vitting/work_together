import 'package:meta/meta.dart';
import 'package:work_together/helpers/comment_data.dart';
import 'package:work_together/helpers/file_data.dart';
import 'package:work_together/helpers/item_data.dart';
import 'package:work_together/helpers/participant_data.dart';
import 'package:work_together/helpers/system_helpers.dart';
import 'package:work_together/helpers/task_firestore.dart';

class TaskData extends ItemData {
  String projectId;

  TaskData(
      {String id,
      @required String title,
      String description = "",
      int progress = 0,
      int numberOfSub = 0,
      int color = 0,
      @required this.projectId})
      : super(
            id: id,
            title: title,
            description: description,
            progress: progress,
            numberOfSub: numberOfSub,
            color: color);

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        "projectId": projectId,
      });
  }

  Future<void> save() {
    if (id == null) {
      id = SystemHelpers.generateUuid();
      return TaskFirestore.add(this);
    } else {
      return TaskFirestore.update(this);
    }
  }

  Future<void> delete() {
    return TaskFirestore.delete(id);
  }

  void getSubTasks() {}

  List<ParticipantData> getParticipants() {
    return null;
  }

  List<CommentData> getComments() {
    return null;
  }

  List<FileData> getFiles() {
    return null;
  }

  factory TaskData.fromMap(Map<String, dynamic> item) {
    return TaskData(
        projectId: item["projectId"],
        id: item["id"],
        title: item["title"],
        description: item["description"],
        progress: item["progress"],
        numberOfSub: item["numberOfSub"],
        color: item["color"]);
  }
}

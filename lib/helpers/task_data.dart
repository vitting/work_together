import 'package:cloud_firestore/cloud_firestore.dart';
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
      String createdByUserId,
      String title = "",
      String description = "",
      DateTime createdDate,
      int progress = 0,
      int numberOfSub = 0,
      int color = 0,
      @required this.projectId})
      : super(
            id: id,
            createdByUserId: createdByUserId,
            title: title,
            description: description,
            createdDate: createdDate,
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
      createdDate = DateTime.now();
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
        createdByUserId: item["createdByUserId"],
        title: item["title"],
        description: item["description"],
        createdDate: (item["createdDate"] as Timestamp).toDate(),
        progress: item["progress"],
        numberOfSub: item["numberOfSub"],
        color: item["color"]);
  }
}

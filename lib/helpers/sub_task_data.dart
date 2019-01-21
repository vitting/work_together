import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:work_together/helpers/comment_data.dart';
import 'package:work_together/helpers/file_data.dart';
import 'package:work_together/helpers/item_data.dart';
import 'package:work_together/helpers/participant_data.dart';
import 'package:work_together/helpers/sub_task_firestore.dart';
import 'package:work_together/helpers/system_helpers.dart';

class SubTaskData extends ItemData {
  String projectId;
  String taskId;

  SubTaskData(
      {String id,
      String createdByUserId,
      String title = "",
      String description = "",
      DateTime createdDate,
      int progress = 0,
      int numberOfSub = 0,
      int color = 0,
      @required this.projectId,
      @required this.taskId})
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
    return super.toMap()..addAll({"projectId": projectId, "taskId": taskId});
  }

  Future<void> save() {
    if (id == null) {
      id = SystemHelpers.generateUuid();
      createdDate = DateTime.now();
      return SubTaskFirestore.add(this);
    } else {
      return SubTaskFirestore.update(this);
    }
  }

  Future<void> delete() {
    return SubTaskFirestore.delete(id);
  }

  List<ParticipantData> getParticipants() {
    return null;
  }

  List<CommentData> getComments() {
    return null;
  }

  List<FileData> getFiles() {
    return null;
  }

  factory SubTaskData.fromMap(Map<String, dynamic> item) {
    return SubTaskData(
        projectId: item["projectId"],
        taskId: item["taskId"],
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

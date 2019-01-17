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
      @required String title,
      String description = "",
      int progress = 0,
      int numberOfSub = 0,
      int color = 0,
      @required this.projectId,
      @required this.taskId})
      : super(
            id: id,
            title: title,
            description: description,
            progress: progress,
            numberOfSub: numberOfSub,
            color: color);

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()..addAll({"projectId": projectId, "taskId": taskId});
  }

  Future<void> save() {
    if (id == null) {
      id = id ?? SystemHelpers.generateUuid();
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
        title: item["title"],
        description: item["description"],
        progress: item["progress"],
        numberOfSub: item["numberOfSub"],
        color: item["color"]);
  }
}

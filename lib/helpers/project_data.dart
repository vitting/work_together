import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:work_together/helpers/comment_data.dart';
import 'package:work_together/helpers/file_data.dart';
import 'package:work_together/helpers/item_data.dart';
import 'package:work_together/helpers/participant_data.dart';
import 'package:work_together/helpers/project_firestore.dart';
import 'package:work_together/helpers/system_helpers.dart';
import 'package:work_together/helpers/task_data.dart';

class ProjectData extends ItemData {
  ProjectData(
      {String id,
      String createdByUserId,
      String updatedByUserId,
      String title = "",
      String description = "",
      DateTime createdDate,
      DateTime updatedDate,
      int progress = 0,
      int numberOfSub = 0,
      int color = 0})
      : super(
            id: id,
            createdByUserId: createdByUserId,
            updatedByUserId: updatedByUserId,
            title: title,
            createdDate: createdDate,
            updatedDate: updatedDate,
            description: description,
            progress: progress,
            numberOfSub: numberOfSub,
            color: color);

  Future<void> save() {
    if (id == null) {
      id = SystemHelpers.generateUuid();
      createdDate = DateTime.now();
      updatedDate = createdDate;
      createdByUserId = updatedByUserId;
      return ProjectFirestore.add(this);
    } else {
      return ProjectFirestore.update(this);
    }
  }

  Future<void> updateColor(int color) {
    this.color = color;
    return ProjectFirestore.updateColor(id, color);
  }

  Future<QuerySnapshot> getProjects() {
    return ProjectFirestore.getAllProjects();
  }

  Future<void> delete() {
    return ProjectFirestore.delete(this.id);
  }


  Stream<QuerySnapshot> getTasksAsStream() {
    return TaskData.getTasksAsStream(id);
  }

  List<ParticipantData> getParticipants() {
    return null;
  }

  Stream<QuerySnapshot> getCommentsAsStream() {
    return CommentData.getCommentsByProjectId(id);
  }

  Stream<QuerySnapshot> getFilesAsStream() {
    return FileData.getFilesByProjectId(id);
  }

  factory ProjectData.fromMap(Map<String, dynamic> item) {
    return ProjectData(
        id: item["id"],
        createdByUserId: item["createdByUserId"],
        updatedByUserId: item["updatedByUserId"],
        title: item["title"],
        createdDate: (item["createdDate"] as Timestamp).toDate(),
        updatedDate: (item["updatedDate"] as Timestamp).toDate(),
        description: item["description"],
        progress: item["progress"],
        numberOfSub: item["numberOfSub"],
        color: item["color"]);
  }

  static Stream<QuerySnapshot> getProjectsAsStream() {
    return ProjectFirestore.getAllProjectsAsStream();
  }
}

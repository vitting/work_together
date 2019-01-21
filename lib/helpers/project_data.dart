import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:work_together/helpers/comment_data.dart';
import 'package:work_together/helpers/file_data.dart';
import 'package:work_together/helpers/item_data.dart';
import 'package:work_together/helpers/participant_data.dart';
import 'package:work_together/helpers/project_firestore.dart';
import 'package:work_together/helpers/system_helpers.dart';

class ProjectData extends ItemData {
  ProjectData(
      {String id,
      String createdByUserId,
      String title = "",
      String description = "",
      DateTime createdDate,
      int progress = 0,
      int numberOfSub = 0,
      int color = 0})
      : super(
            id: id,
            createdByUserId: createdByUserId,
            title: title,
            createdDate: createdDate,
            description: description,
            progress: progress,
            numberOfSub: numberOfSub,
            color: color);

  Future<void> save() {
    if (id == null) {
      id = SystemHelpers.generateUuid();
      createdDate = DateTime.now();
      return ProjectFirestore.add(this);
    } else {
      return ProjectFirestore.update(this);
    }
  }

  Future<QuerySnapshot> getProjects() {
    return ProjectFirestore.getAllProjects();
  }

  Future<void> delete() {
    return ProjectFirestore.delete(this.id);
  }


  void getTasks() {}
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
        title: item["title"],
        createdDate: (item["createdDate"] as Timestamp).toDate(),
        description: item["description"],
        progress: item["progress"],
        numberOfSub: item["numberOfSub"],
        color: item["color"]);
  }

  static Stream<QuerySnapshot> getProjectsAsStream() {
    return ProjectFirestore.getAllProjectsAsStream();
  }
}

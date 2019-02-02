import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:work_together/helpers/comment_data.dart';
import 'package:work_together/helpers/file_data.dart';
import 'package:work_together/helpers/item_data.dart';
import 'package:work_together/helpers/participant_data.dart';
import 'package:work_together/helpers/project_firestore.dart';
import 'package:work_together/helpers/system_helpers.dart';
import 'package:work_together/helpers/task_data.dart';

class ProjectData extends ItemData {
  List<String> participants;

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
      int color = 0,
      this.participants})
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

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        "participants": participants,
      });
  }

  Future<void> save() {
    if (id == null) {
      id = SystemHelpers.generateUuid();
      createdDate = DateTime.now();
      updatedDate = createdDate;
      createdByUserId = updatedByUserId;
      participants = [createdByUserId];
      return ProjectFirestore.add(this);
    } else {
      return ProjectFirestore.update(this);
    }
  }

  Future<void> addParticipant(String userId) {
    return ProjectFirestore.addParticipant(id, userId);
  }

  Future<void> removeParticipant(String userId) {
    return ProjectFirestore.removeParticipant(id, userId);
  }

  Future<void> updateColor(int color) {
    this.color = color;
    return ProjectFirestore.updateColor(id, color);
  }

  Future<QuerySnapshot> getProjects() {
    return ProjectFirestore.getAllProjects();
  }

  Future<void> delete() {
    /// TODO: We have to delete tasks, comments, files
    return ProjectFirestore.delete(id);
  }

  Stream<QuerySnapshot> getTasksAsStream() {
    return TaskData.getTasksAsStream(id);
  }

  List<ParticipantData> getParticipants() {
    return null;
  }

  Stream<QuerySnapshot> getCommentsAsStream() {
    return CommentData.getCommentsByProjectIdAsStream(id);
  }

  Stream<QuerySnapshot> getFilesAsStream() {
    return FileData.getFilesByProjectIdAsStream(id);
  }

  Future<List<FileData>> getFiles() {
    return FileData.getFilesByProjectId(id);
  }

  Future<List<CommentData>> getComments() {
    return CommentData.getCommentsByProjectId(id);
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
        color: item["color"],
        participants: (item["participants"] as List<dynamic>)
            .map((dynamic item) => (item as String))
            .toList());
  }

  static Stream<QuerySnapshot> getProjectsAsStream(String userId) {
    return ProjectFirestore.getProjectsByUserIdAsStream(userId);
  }
}

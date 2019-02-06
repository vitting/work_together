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
  List<String> participantsWaiting;
  List<String> projectAdmins;

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
      int color = 3,
      this.participantsWaiting,
      this.participants,
      this.projectAdmins})
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
        "participantsWaiting": participantsWaiting,
        "projectAdmins": projectAdmins
      });
  }

  Future<void> save() {
    if (id == null) {
      id = SystemHelpers.generateUuid();
      createdDate = DateTime.now();
      updatedDate = createdDate;
      createdByUserId = updatedByUserId;
      participants = [createdByUserId];
      participantsWaiting = [];
      projectAdmins = [createdByUserId];
      return ProjectFirestore.add(this);
    } else {
      return ProjectFirestore.update(this);
    }
  }

  Future<void> addProjectAdmin(String userId) {
    return ProjectFirestore.addProjectAdmin(id, userId);
  }

  Future<void> removeProjectAdmin(String userId) {
    return ProjectFirestore.removeProjectAdmin(id, userId);
  }

  Future<void> addParticipant(String userId) {
    return ProjectFirestore.addParticipant(id, userId);
  }

  Future<void> removeParticipant(String userId) {
    return ProjectFirestore.removeParticipant(id, userId);
  }

  Future<void> addWaitingParticipant(String userId) {
    return ProjectFirestore.addWaitingParticipant(id, userId);
  }

  Future<void> removeWaitingParticipant(String userId) {
    return ProjectFirestore.removeWaitingParticipant(id, userId);
  }

  Future<void> updateColor(int color) {
    this.color = color;
    return ProjectFirestore.updateColor(id, color);
  }

  Future<QuerySnapshot> getProjects() {
    return ProjectFirestore.getAllProjects();
  }

  Future<void> delete() {
    /// TODO: We have to delete tasks, comments, files, requests
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
        projectAdmins: (item["projectAdmins"] as List<dynamic>)
            .map((dynamic item) => (item as String))
            .toList(),
        participantsWaiting: (item["participantsWaiting"] as List<dynamic>)
            .map((dynamic item) => (item as String))
            .toList(),
        participants: (item["participants"] as List<dynamic>)
            .map((dynamic item) => (item as String))
            .toList());
  }

  static Stream<QuerySnapshot> getProjectsAsStream(String userId) {
    return ProjectFirestore.getProjectsByUserIdAsStream(userId);
  }

  static Future<List<ProjectData>> getProjectsWaitingForUserAccept(
      String userId) async {
    QuerySnapshot snapshot =
        await ProjectFirestore.getProjectsWaitingForUserAccept(userId);
    return snapshot.documents.map<ProjectData>((DocumentSnapshot doc) {
      return ProjectData.fromMap(doc.data);
    }).toList();
  }
}

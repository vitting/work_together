import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:work_together/helpers/comment_firestore.dart';
import 'package:work_together/helpers/system_helpers.dart';

class CommentData {
  String id;
  String projectId;
  String taskId;
  String subTaskId;
  /// Types p = project, t = task, s = subtask
  String type; 
  String userId;
  String name;
  String comment;
  DateTime commentDate;

  CommentData({this.id, @required this.projectId, this.taskId = "", this.subTaskId = "", @required this.type, @required this.userId, @required this.name, @required this.comment, this.commentDate});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "projectId": projectId,
      "taskId": taskId,
      "subTaskId": subTaskId,
      "type": type,
      "userId": userId,
      "name": name,
      "comment": comment,
      "commentDate": Timestamp.fromDate(commentDate)
    };
  }

  Future<void> save() {
    if (id == null) {
      id = SystemHelpers.generateUuid();
      commentDate = DateTime.now();
      return CommentFirestore.add(this);
    } else {
      return CommentFirestore.update(this);
    }
  }

  Future<void> delete() {
    return CommentFirestore.delete(id);
  }

  factory CommentData.fromMap(dynamic item) {
    return CommentData(
      id: item["id"],
      projectId: item["projectId"],
      taskId: item["taskId"],
      subTaskId: item["subTaskId"],
      type: item["type"],
      userId: item["userId"],
      name: item["name"],
      comment: item["comment"],
      commentDate: (item["commentDate"] as Timestamp).toDate()
    );
  }

  static Stream<QuerySnapshot> getCommentsByProjectId(String projectId) {
    return CommentFirestore.getCommentsByProjectId(projectId);
  }

  static Stream<QuerySnapshot> getCommentsByTaskId(String taskId) {
    return CommentFirestore.getCommentsByTaskId(taskId);
  }

  static Stream<QuerySnapshot> getCommentsBySubTaskId(String subTaskId) {
    return CommentFirestore.getCommentsBySubTaskId(subTaskId);
  }
}
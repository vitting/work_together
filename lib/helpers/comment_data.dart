import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:work_together/helpers/comment_firestore.dart';
import 'package:work_together/helpers/system_helpers.dart';
import 'package:work_together/helpers/user_data.dart';

class CommentData {
  String id;
  String subCommentId;
  String projectId;
  String taskId;

  /// Types p = project, t = task, s = subtask
  String type;
  String userId;
  String name;
  String photoUrl;
  String comment;
  DateTime commentDate;

  CommentData(
      {this.id,
      this.subCommentId,
      @required this.projectId,
      this.taskId,
      @required this.type,
      @required this.userId,
      @required this.name,
      @required this.photoUrl,
      @required this.comment,
      this.commentDate});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "subCommentId": subCommentId,
      "projectId": projectId,
      "taskId": taskId,
      "type": type,
      "userId": userId,
      "name": name,
      "photoUrl": photoUrl,
      "comment": comment,
      "commentDate": Timestamp.fromDate(commentDate)
    };
  }

  Future<void> save() {
    commentDate = DateTime.now();
    
    if (id == null) {
      id = SystemHelpers.generateUuid();
      return CommentFirestore.add(this);
    } else {
      return CommentFirestore.update(this);
    }
  }

  Future<void> delete() {
    return CommentFirestore.delete(id);
  }

  Stream<QuerySnapshot> getSubCommentsAsStream() {
    return CommentFirestore.getSubCommentsBySubCommentId(id);
  }

  static Future<List<CommentData>> getCommentsByProjectId(String projectId) async {
    QuerySnapshot snapshot = await CommentFirestore.getCommentsByProjectId(projectId);
    return snapshot.documents.map<CommentData>((DocumentSnapshot doc) {
      return CommentData.fromMap(doc.data);
    }).toList();
  }

  factory CommentData.fromMap(dynamic item) {
    return CommentData(
        id: item["id"],
        subCommentId: item["subCommentId"],
        projectId: item["projectId"],
        taskId: item["taskId"],
        type: item["type"],
        userId: item["userId"],
        name: item["name"],
        photoUrl: item["photoUrl"],
        comment: item["comment"],
        commentDate: (item["commentDate"] as Timestamp).toDate());
  }

  factory CommentData.subComment(CommentData commentData, String comment, UserData user) {
    return CommentData(
      projectId: commentData.projectId,
      taskId: commentData.taskId,
      type: commentData.type,
      comment: comment,
      name: user.name,
      userId: user.id,
      photoUrl: user.photoUrl,
      subCommentId: commentData.id
    );
  }

  static Stream<QuerySnapshot> getCommentsByProjectIdAsStream(String projectId) {
    return CommentFirestore.getCommentsByProjectIdAsStream(projectId);
  }

  static Stream<QuerySnapshot> getCommentsByTaskId(String taskId) {
    return CommentFirestore.getCommentsByTaskId(taskId);
  }

  static Stream<QuerySnapshot> getCommentsBySubTaskId(String subTaskId) {
    return CommentFirestore.getCommentsBySubTaskId(subTaskId);
  }
}

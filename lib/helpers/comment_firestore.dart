import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:work_together/helpers/comment_data.dart';

class CommentFirestore {
  static Firestore _firestore = Firestore.instance;
  static String _collectionName = "comments";

  static Future<void> add(CommentData item) {
    return _firestore
        .collection(_collectionName)
        .document(item.id)
        .setData(item.toMap());
  }

  static Future<void> update(CommentData item) {
    return _firestore
        .collection(_collectionName)
        .document(item.id)
        .updateData(item.toMap());
  }

  static Future<void> delete(String id) {
    return _firestore.collection(_collectionName).document(id).delete();
  }

  static Stream<QuerySnapshot> getCommentsByProjectId(String projectId) {
    return _firestore
        .collection(_collectionName)
        .where("projectId", isEqualTo: projectId)
        .where("type", isEqualTo: "p")
        .orderBy("commentDate")
        .snapshots();
  }

  static Stream<QuerySnapshot> getCommentsByTaskId(String taskId) {
    return _firestore
        .collection(_collectionName)
        .where("taskId", isEqualTo: taskId)
        .where("type", isEqualTo: "t")
        .orderBy("commentDate")
        .snapshots();
  }

  static Stream<QuerySnapshot> getCommentsBySubTaskId(String subTaskId) {
    return _firestore
        .collection(_collectionName)
        .where("subTaskId", isEqualTo: subTaskId)
        .where("type", isEqualTo: "s")
        .orderBy("commentDate")
        .snapshots();
  }

  static Stream<QuerySnapshot> getSubCommentsBySubCommentId(
      String subCommentId) {
    return _firestore
        .collection(_collectionName)
        .where("subCommentId", isEqualTo: subCommentId)
        .orderBy("commentDate")
        .snapshots();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:work_together/helpers/sub_task_data.dart';

class SubTaskFirestore {
  static Firestore _firestore = Firestore.instance;
  static String _collectionName = "subtasks";

  static Future<void> add(SubTaskData item) {
    return _firestore
        .collection(_collectionName)
        .document(item.id)
        .setData(item.toMap());
  }

  static Future<void> update(SubTaskData item) {
    return _firestore
        .collection(_collectionName)
        .document(item.id)
        .updateData(item.toMap());
  }

  static Future<void> delete(String id) {
    return _firestore.collection(_collectionName).document(id).delete();
  }

  static Future<void> subTaskState(
      String id, String closedByUserId, Timestamp closedDate, bool closed) {
    return _firestore.collection(_collectionName).document(id).updateData({
      "closedByUserId": closedByUserId,
      "closedDate": closedDate,
      "closed": closed
    });
  }

  static Future<void> updateTitle(String id, String title) {
    return _firestore
        .collection(_collectionName)
        .document(id)
        .updateData({"title": title});
  }

  static Future<void> updateDeleted(String id, bool deleted) {
    return _firestore
        .collection(_collectionName)
        .document(id)
        .updateData({"deleted": deleted});
  }

  static Future<QuerySnapshot> getSubTasksByTaskId(String taskId) {
    return _firestore
        .collection(_collectionName)
        .where("taskId", isEqualTo: taskId)
        .getDocuments();
  }
}

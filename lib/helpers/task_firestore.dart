import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:work_together/helpers/task_data.dart';

class TaskFirestore {
  static Firestore _firestore = Firestore.instance;
  static String _collectionName = "tasks";

  static Future<void> add(TaskData item) {
    return _firestore
        .collection(_collectionName)
        .document(item.id)
        .setData(item.toMap());
  }

  static Future<void> update(TaskData item) {
    return _firestore
        .collection(_collectionName)
        .document(item.id)
        .updateData(item.toMap());
  }

  static Future<void> updateColor(String id, int color) {
    return _firestore.collection(_collectionName).document(id).updateData({
      "color": color
    });
  }

  static Future<void> delete(String id) {
    return _firestore.collection(_collectionName).document(id).delete();
  }

  static Stream<QuerySnapshot> getTasksByProjectId(String id) {
    return _firestore
        .collection(_collectionName)
        .where("projectId", isEqualTo: id)
        .orderBy("title")
        .snapshots();
  }
}

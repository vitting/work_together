import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:work_together/helpers/file_data.dart';

class FileFirestore {
  static Firestore _firestore = Firestore.instance;
  static String _collectionName = "files";

  static Future<void> add(FileData item) {
    return _firestore.collection(_collectionName).document(item.id).setData(item.toMap());
  } 

  static Future<void> update(FileData item) {
    return _firestore.collection(_collectionName).document(item.id).updateData(item.toMap());
  } 

  static Future<void> delete(String id) {
    return _firestore.collection(_collectionName).document(id).delete();
  }    

  static Future<QuerySnapshot> getFilesByProjectId(String projectId) {
    return _firestore
        .collection(_collectionName)
        .where("projectId", isEqualTo: projectId)
        .where("type", isEqualTo: "p")
        .orderBy("name")
        .getDocuments();
  }

  static Stream<QuerySnapshot> getFilesByProjectIdAsStream(String projectId) {
    return _firestore
        .collection(_collectionName)
        .where("projectId", isEqualTo: projectId)
        .where("type", isEqualTo: "p")
        .orderBy("name")
        .snapshots();
  }

  static Stream<QuerySnapshot> getFilesByTaskIdAsStream(String taskId) {
    return _firestore
        .collection(_collectionName)
        .where("taskId", isEqualTo: taskId)
        .where("type", isEqualTo: "t")
        .orderBy("name")
        .snapshots();
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:work_together/helpers/project_data.dart';

class ProjectFirestore {
  static Firestore _firestore = Firestore.instance;
  static String _collectionName = "projects";

  static Future<void> add(ProjectData item) {
    return _firestore.collection(_collectionName).document(item.id).setData(item.toMap());
  } 

  static Future<void> update(ProjectData item) {
    return _firestore.collection(_collectionName).document(item.id).updateData(item.toMap());
  } 

  static Future<void> delete(String id) {
    return _firestore.collection(_collectionName).document(id).delete();
  }
}
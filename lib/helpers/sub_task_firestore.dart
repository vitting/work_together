import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:work_together/helpers/sub_task_data.dart';

class SubTaskFirestore {
  static Firestore _firestore = Firestore.instance;
  static String _collectionName = "subtasks";

  static Future<void> add(SubTaskData item) {
    return _firestore.collection(_collectionName).document(item.id).setData(item.toMap());
  } 

  static Future<void> update(SubTaskData item) {
    return _firestore.collection(_collectionName).document(item.id).updateData(item.toMap());
  } 

  static Future<void> delete(String id) {
    return _firestore.collection(_collectionName).document(id).delete();
  }  
}
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
}
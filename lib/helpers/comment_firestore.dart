import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:work_together/helpers/comment_data.dart';

class CommentFirestore {
  static Firestore _firestore = Firestore.instance;
  static String _collectionName = "comments";

  static Future<void> add(CommentData item) {
    return _firestore.collection(_collectionName).document(item.id).setData(item.toMap());
  } 

  static Future<void> update(CommentData item) {
    return _firestore.collection(_collectionName).document(item.id).updateData(item.toMap());
  } 

  static Future<void> delete(String id) {
    return _firestore.collection(_collectionName).document(id).delete();
  }    
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:work_together/helpers/user_data.dart';

class UserFirestore {
  static Firestore _firestore = Firestore.instance;
  static String _collectionName = "users";

  static Future<void> add(UserData item, {bool merge = false}) {
    return _firestore.collection(_collectionName).document(item.id).setData(item.toMap(), merge: merge);
  } 

  static Future<void> update(UserData item) {
    return _firestore.collection(_collectionName).document(item.id).updateData(item.toMap());
  } 

  static Future<void> delete(String id) {
    return _firestore.collection(_collectionName).document(id).delete();
  }  

  static Future<void> updateEnabled(String id, bool enabled) {
    return _firestore.collection(_collectionName).document(id).updateData({
      "enabled": enabled
    });
  }

  static Future<QuerySnapshot> getAllUsers() {
    return _firestore.collection(_collectionName).getDocuments();
  }
}
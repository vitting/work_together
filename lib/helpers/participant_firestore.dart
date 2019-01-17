import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:work_together/helpers/participant_data.dart';

class ParticipantFirestore {
  static Firestore _firestore = Firestore.instance;
  static String _collectionName = "participants";

  static Future<void> add(ParticipantData item) {
    return _firestore.collection(_collectionName).document(item.id).setData(item.toMap());
  } 

  static Future<void> update(ParticipantData item) {
    return _firestore.collection(_collectionName).document(item.id).updateData(item.toMap());
  } 

  static Future<void> delete(String id) {
    return _firestore.collection(_collectionName).document(id).delete();
  }    
}
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

  static Future<void> updateColor(String id, int color) {
    return _firestore.collection(_collectionName).document(id).updateData({
      "color": color
    });
  }

  static Future<void> delete(String id) {
    return _firestore.collection(_collectionName).document(id).delete();
  }

  static Future<QuerySnapshot> getAllProjects() {
    return _firestore.collection(_collectionName).orderBy("title").getDocuments();
  }

  static Stream<QuerySnapshot> getProjectsByUserIdAsStream(String userId) {
    return _firestore.collection(_collectionName).where("participants", arrayContains: userId).orderBy("title").snapshots();
  }

  static Future<void> addParticipant(String id, String userId) {
    return _firestore.collection(_collectionName).document(id).updateData({
      "participants": FieldValue.arrayUnion([userId])
    });
  }

  static Future<void> removeParticipant(String id, String userId) {
    return _firestore.collection(_collectionName).document(id).updateData({
      "participants": FieldValue.arrayRemove([userId])
    });
  }
}
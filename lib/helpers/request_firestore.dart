import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:work_together/helpers/request_data.dart';

class RequestFirestore {
  static Firestore _firestore = Firestore.instance;
  static String _collectionName = "requests";

  static Future<void> add(RequestData item) {
    return _firestore
        .collection(_collectionName)
        .document(item.id)
        .setData(item.toMap());
  }

  static Future<void> update(RequestData item) {
    return _firestore
        .collection(_collectionName)
        .document(item.id)
        .updateData(item.toMap());
  }

  static Future<void> delete(String id) {
    return _firestore.collection(_collectionName).document(id).delete();
  }

  static Future<void> updateStatus(String id, String status) {
    return _firestore.collection(_collectionName).document(id).updateData({
      "requestStatus": status
    });
  }

  /// User want's status on projects who has reqeusted user to join project
  static Future<QuerySnapshot> getProjectRequestsForUser(String userId) {
    return _firestore
        .collection(_collectionName)
        .where("requestFrom", isEqualTo: "project")
        .where("userId", isEqualTo: userId)
        .getDocuments();
  }

  /// Project owner want's status on users who has requested to join project
  static Future<QuerySnapshot> getUserRequestsForProject(String projectId) {
    return _firestore
        .collection(_collectionName)
        .where("requestFrom", isEqualTo: "user")
        .where("projectId", isEqualTo: projectId)
        .getDocuments();
  }

  /// Project owner want's status on users he has asked to join project
  static Future<QuerySnapshot> getProjectRequestStatusForUsers(
      String projectId) {
    return _firestore
        .collection(_collectionName)
        .where("requestFrom", isEqualTo: "project")
        .where("projectId", isEqualTo: projectId)
        .getDocuments();
  }

  static Future<QuerySnapshot> getProjectRequestStatusForUser(
      String projectId, String userId) {
    return _firestore
        .collection(_collectionName)
        .where("requestFrom", isEqualTo: "project")
        .where("userId", isEqualTo: userId)
        .where("projectId", isEqualTo: projectId)
        .getDocuments();
  }

  /// User want's status on user request to join projects
  static Future<QuerySnapshot> getUserRequestStatusForProjects(String userId) {
    return _firestore
        .collection(_collectionName)
        .where("requestFrom", isEqualTo: "user")
        .where("userId", isEqualTo: userId)
        .getDocuments();
  }
}

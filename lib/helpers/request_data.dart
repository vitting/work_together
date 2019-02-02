import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:work_together/helpers/request_firestore.dart';
import 'package:work_together/helpers/system_helpers.dart';

class RequestData {
  String id;
  DateTime requestDate;
  String projectId;
  String userId;

  /// project = requests a user to join project | user = request to join a project
  String requestFrom;

  ///a = accepted | w = waiting for accept | d = declined
  String requestStatus;

  RequestData(
      {this.id,
      this.requestDate,
      @required this.projectId,
      @required this.userId,
      @required this.requestFrom,
      @required this.requestStatus});

  Future<void> save() {
    id = id ?? SystemHelpers.generateUuid();
    requestDate = requestDate ?? DateTime.now();
    return RequestFirestore.add(this);
  }

  Future<void> delete() {
    return RequestFirestore.delete(id);
  }

  ///Status: a = accepted | w = waiting for accept | d = declined
  Future<void> updateStatus(String status) {
    return RequestFirestore.updateStatus(id, status);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "requestDate": Timestamp.fromDate(requestDate),
      "projectId": projectId,
      "userId": userId,
      "requestFrom": requestFrom,
      "requestStatus": requestStatus
    };
  }

  factory RequestData.fromMap(Map<String, dynamic> item) {
    return RequestData(
        id: item["id"],
        requestDate: (item["requestDate"] as Timestamp).toDate(),
        projectId: item["projectId"],
        userId: item["userId"],
        requestFrom: item["requestFrom"],
        requestStatus: item["requestStatus"]);
  }

  static Future<Map<String, RequestData>> getProjectRequestsForUser(
      String userId) async {
    QuerySnapshot snapshot =
        await RequestFirestore.getProjectRequestsForUser(userId);
    Map<String, RequestData> map = Map<String, RequestData>();
    List<RequestData> list = snapshot.documents
        .map<RequestData>(
            (DocumentSnapshot doc) => RequestData.fromMap(doc.data))
        .toList();
    list.forEach((RequestData data) {
      map[data.userId] = data;
    });

    return map;
  }

  static Future<Map<String, RequestData>> getUserRequestsForProject(
      String projectId) async {
    Map<String, RequestData> map = Map<String, RequestData>();
    QuerySnapshot snapshot =
        await RequestFirestore.getUserRequestsForProject(projectId);
    List<RequestData> list = snapshot.documents
        .map<RequestData>(
            (DocumentSnapshot doc) => RequestData.fromMap(doc.data))
        .toList();

    list.forEach((RequestData data) {
      map[data.userId] = data;
    });

    return map;
  }

  static Future<Map<String, RequestData>> getProjectRequestStatusForUsers(
      String projectId) async {
    Map<String, RequestData> map = Map<String, RequestData>();
    QuerySnapshot snapshot =
        await RequestFirestore.getProjectRequestStatusForUsers(projectId);
    List<RequestData> list = snapshot.documents
        .map<RequestData>(
            (DocumentSnapshot doc) => RequestData.fromMap(doc.data))
        .toList();

    list.forEach((RequestData data) {
      map[data.userId] = data;
    });
    return map;
  }

  static Future<RequestData> getProjectRequestStatusForUser(String projectId, String userId) async {
    RequestData value;
    QuerySnapshot snapshot =await RequestFirestore.getProjectRequestStatusForUsers(projectId);
    if (snapshot.documents.length != 0) {
      value = RequestData.fromMap(snapshot.documents[0].data);
    }
    
    return value;
  }

  static Future<Map<String, RequestData>> getUserRequestStatusForProjects(
      String userId) async {
    Map<String, RequestData> map = Map<String, RequestData>();
    QuerySnapshot snapshot =
        await RequestFirestore.getUserRequestStatusForProjects(userId);
    List<RequestData> list = snapshot.documents
        .map<RequestData>(
            (DocumentSnapshot doc) => RequestData.fromMap(doc.data))
        .toList();

    list.forEach((RequestData data) {
      map[data.userId] = data;
    });
    return map;
  }
}

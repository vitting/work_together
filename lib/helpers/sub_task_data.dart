import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:work_together/helpers/sub_task_firestore.dart';
import 'package:work_together/helpers/system_helpers.dart';
import 'package:work_together/helpers/user_data.dart';

class SubTaskData {
  String id;
  String createdByUserId;
  DateTime createdDate;
  String closedByUserId;
  DateTime closedDate;
  String projectId;
  String taskId;
  String title;
  bool closed;

  SubTaskData(
      {this.id,
      @required this.title,
      @required this.createdByUserId,
      this.createdDate,
      @required this.projectId,
      @required this.taskId,
      this.closedByUserId,
      this.closedDate,
      this.closed = false});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "createdByUserId": createdByUserId,
      "createdDate": Timestamp.fromDate(createdDate),
      "closedByUserId": closedByUserId,
      "closedDate": Timestamp.fromDate(closedDate),
      "projectId": projectId,
      "taskId": taskId,
      "title": title,
      "closed": closed
    };
  }

  Future<void> save() {
    if (id == null) {
      id = SystemHelpers.generateUuid();
      createdDate = DateTime.now();
      closedDate = DateTime.now();
      return SubTaskFirestore.add(this);
    } else {
      return SubTaskFirestore.update(this);
    }
  }

  Future<void> delete() {
    return SubTaskFirestore.delete(id);
  }

  Future<void> subTaskState(String userId, bool closed) {
    if (closed) {
      return SubTaskFirestore.subTaskState(id, userId, Timestamp.now(), closed);
    } else {
      return SubTaskFirestore.subTaskState(
          id, null, Timestamp.fromDate(createdDate), closed);
    }
  }

  Future<void> updateTitle(String title) {
    this.title = title;
    return SubTaskFirestore.updateTitle(id, title);
  }

  Future<UserData> getClosedByUser() async {
    UserData user;
    if (closedByUserId != null) {
      user = await UserData.getUser(closedByUserId);  
    }

    return user;
  }

  factory SubTaskData.fromMap(Map<String, dynamic> item) {
    return SubTaskData(
        projectId: item["projectId"],
        taskId: item["taskId"],
        id: item["id"],
        createdByUserId: item["createdByUserId"],
        closedByUserId: item["closedByUserId"],
        createdDate: (item["createdDate"] as Timestamp).toDate(),
        closedDate: (item["closedDate"] as Timestamp).toDate(),
        title: item["title"],
        closed: item["closed"]);
  }

  factory SubTaskData.dummy() {
    return SubTaskData(
        createdByUserId: "", projectId: "", taskId: "", title: "");
  }

  static Future<List<SubTaskData>> getSubTasks(String taskId) async {
    QuerySnapshot snapshot = await SubTaskFirestore.getSubTasksByTaskId(taskId);
    return snapshot.documents.map<SubTaskData>((DocumentSnapshot doc) {
      return SubTaskData.fromMap(doc.data);
    }).toList();
  }
}

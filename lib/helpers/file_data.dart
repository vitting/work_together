import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:work_together/helpers/file_firestore.dart';
import 'package:work_together/helpers/system_helpers.dart';

class FileData {
  String id;
  String projectId;
  String taskId;
  String userId;
  /// Types p = project, t = task
  String type; 
  String name;
  String description;
  String extension;

  FileData({this.id, @required this.projectId, this.taskId = "", @required this.userId, @required this.type, @required this.name, this.description = "", @required this.extension});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "projectId": projectId,
      "taskId": taskId,
      "userId": userId,
      "type": type,
      "name": name,
      "description": description,
      "extension": extension
    };
  }

  Future<void> save() {
    if (id == null) {
      id = SystemHelpers.generateUuid();
      return FileFirestore.add(this);
    } else {
      return FileFirestore.update(this);
    }
  }

  Future<void> delete() {
    return FileFirestore.delete(id);
  }

  factory FileData.fromMap(Map<String, dynamic> item) {
    return FileData(
      id: item["id"],
      projectId: item["projectId"],
      taskId: item["taskId"],
      userId: item["userId"],
      type: item["type"],
      name: item["name"],
      description: item["description"],
      extension: item["extension"]
    );
  }

  static Stream<QuerySnapshot> getFilesByProjectId(String projectId) {
    return FileFirestore.getFilesByProjectId(projectId);
  }

  static Stream<QuerySnapshot> getFilesByTaskId(String taskId) {
    return FileFirestore.getFilesByTaskId(taskId);
  }
}
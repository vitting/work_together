import 'package:meta/meta.dart';
import 'package:work_together/helpers/participant_firestore.dart';
import 'package:work_together/helpers/system_helpers.dart';

class ParticipantData {
  String id;
  String projectId;
  String taskId;
  /// Types p = project, t = task
  String type; 
  String userId;
  String name;  

  ParticipantData({this.id, @required this.projectId, this.taskId = "", @required this.type, @required this.userId, @required this.name});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "projectId": projectId,
      "taskId": taskId,
      "type": type,
      "userId": userId,
      "name": name
    };
  }

  Future<void> save() {
    if (id == null) {
      id = SystemHelpers.generateUuid();
      return ParticipantFirestore.add(this);
    } else {
      return ParticipantFirestore.update(this);
    }
  }

  Future<void> delete() {
    return ParticipantFirestore.delete(id);
  }

  factory ParticipantData.fromMap(dynamic item) {
    return ParticipantData(
      id: item["id"],
      projectId: item["projectId"],
      taskId: item["taskId"],
      type: item["type"],
      userId: item["userId"],
      name: item["name"]
    );
  }
}
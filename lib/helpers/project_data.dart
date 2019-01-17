import 'package:meta/meta.dart';
import 'package:work_together/helpers/comment_data.dart';
import 'package:work_together/helpers/file_data.dart';
import 'package:work_together/helpers/item_data.dart';
import 'package:work_together/helpers/participant_data.dart';
import 'package:work_together/helpers/project_firestore.dart';
import 'package:work_together/helpers/system_helpers.dart';

class ProjectData extends ItemData {
  ProjectData(
      {String id,
      @required String title,
      String description = "",
      int progress = 0,
      int numberOfSub = 0,
      int color = 0})
      : super(
            id: id,
            title: title,
            description: description,
            progress: progress,
            numberOfSub: numberOfSub,
            color: color);

  Future<void> save() {
    if (id == null) {
      id = id ?? SystemHelpers.generateUuid();
      return ProjectFirestore.add(this);
    } else {
      return ProjectFirestore.update(this);
    }
  }

  Future<void> delete() {
    return ProjectFirestore.delete(this.id);
  }
  void getTasks() {}
  List<ParticipantData> getParticipants() {
    return null;
  }

  List<CommentData> getComments() {
    return null;
  }

  List<FileData> getFiles() {
    return null;
  }

  factory ProjectData.fromMap(Map<String, dynamic> item) {
    return ProjectData(
        id: item["id"],
        title: item["title"],
        description: item["description"],
        progress: item["progress"],
        numberOfSub: item["numberOfSub"],
        color: item["color"]);
  }
}

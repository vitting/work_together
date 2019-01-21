
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemData {
  String id;
  String createdByUserId;
  String title;
  String description;
  DateTime createdDate;
  int progress;
  int numberOfSub;
  int color;

  ItemData({this.id, this.createdByUserId, this.title, this.description, this.createdDate, this.progress, this.numberOfSub, this.color});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "createdByUserId": createdByUserId,
      "title": title,
      "description": description,
      "createdDate": Timestamp.fromDate(createdDate),
      "progress": progress,
      "numberOfSub": numberOfSub,
      "color": color
    };
  }
}
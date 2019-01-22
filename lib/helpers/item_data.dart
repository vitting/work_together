
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemData {
  String id;
  String createdByUserId;
  String updatedByUserId;
  String title;
  String description;
  DateTime createdDate;
  DateTime updatedDate;
  int progress;
  int numberOfSub;
  int color;

  ItemData({this.id, this.createdByUserId, this.updatedByUserId, this.title, this.description, this.createdDate, this.updatedDate, this.progress, this.numberOfSub, this.color});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "createdByUserId": createdByUserId,
      "updatedByUserId": updatedByUserId,
      "title": title,
      "description": description,
      "createdDate": Timestamp.fromDate(createdDate),
      "updatedDate": Timestamp.fromDate(updatedDate),
      "progress": progress,
      "numberOfSub": numberOfSub,
      "color": color
    };
  }
}
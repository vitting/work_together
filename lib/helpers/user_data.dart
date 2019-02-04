import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:work_together/helpers/project_data.dart';
import 'package:work_together/helpers/user_firestore.dart';
import 'package:work_together/ui/main/main_inheretedwidget.dart';

class UserData {
  String id;
  String email;
  String name;
  String uniqueName;
  String photoUrl;
  String photoFileName;
  bool enabled;
  bool admin;
  
  UserData(
      {this.id,
      @required this.email,
      @required this.name,
      this.uniqueName,
      this.photoUrl,
      this.photoFileName,
      this.admin = false,
      this.enabled = true});

  Future<void> delete() {
    return UserFirestore.delete(id);
  }

  Future<void> updateEnabled(bool enabled) {
    this.enabled = enabled;
    return UserFirestore.updateEnabled(id, enabled);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "email": email,
      "name": name,
      "uniqueName": uniqueName,
      "photoUrl": photoUrl,
      "photoFileName": photoFileName,
      "enabled": enabled,
      "admin": admin
    };
  }

  Future<List<ProjectData>> getProjectsWaitingForAccept() {
    return ProjectData.getProjectsWaitingForUserAccept(id);
  }

  Stream<QuerySnapshot> getProjects() {
    return ProjectData.getProjectsAsStream(id);
  }

  factory UserData.fromMap(Map<String, dynamic> item) {
    return UserData(
        id: item["id"],
        email: item["email"],
        name: item["name"],
        uniqueName: item["uniqueName"],
        photoUrl: item["photoUrl"],
        photoFileName: item["photoFileName"],
        enabled: item["enabled"],
        admin: item["admin"]);
  }

  static Future<UserData> initUser(FirebaseUser user) async {
    List<String> meta = user.photoUrl.split("|");
    UserData userData = UserData(
        id: user.uid,
        name: user.displayName,
        uniqueName: meta[0],
        email: user.email,
        photoFileName: meta[1],
        photoUrl: meta[2]);

    await UserFirestore.add(userData, merge: true);

    return userData;
  }

  static Future<List<UserData>> getAllUsers() async {
    QuerySnapshot snapshot = await UserFirestore.getAllUsers();
    return snapshot.documents.map((DocumentSnapshot doc) {
      return UserData.fromMap(doc.data);
    }).toList();
  }

  static isCreationUser(BuildContext context, String itemCreatedUserId) {
    bool status = false;
    if (MainInherited.of(context).userData.admin ||
        MainInherited.of(context).userData.id == itemCreatedUserId) {
      status = true;
    }
    return status;
  }
}

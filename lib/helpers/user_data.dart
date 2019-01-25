import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:work_together/helpers/config.dart';
import 'package:work_together/helpers/system_helpers.dart';
import 'package:work_together/helpers/user_firestore.dart';

class UserData {
  String id;
  String email;
  String name;
  String photoUrl;
  bool enabled;
  bool admin;

  UserData({this.id, @required this.email, @required this.name, this.photoUrl, this.admin = false, this.enabled = true});

  Future<void> save() {
    if (id == null) {
      id = SystemHelpers.generateUuid();
      return UserFirestore.add(this);
    } else {
      return UserFirestore.update(this);
    }
  }

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
      "photoUrl": photoUrl,
      "enabled": enabled,
      "admin": admin
    };
  }

  factory UserData.fromMap(Map<String, dynamic> item) {
    return UserData(
      id: item["id"],
      email: item["email"],
      name: item["name"],
      photoUrl: item["photoUrl"],
      enabled: item["enabled"],
      admin: item["admin"]
    );
  }

  static Future<UserData> initUser(FirebaseUser user) async {
    UserData userData = UserData(
      id: user.uid,
      name: user.displayName,
      email: user.email,
      photoUrl: user.photoUrl ?? Config.noProfilePicture
    );

    await UserFirestore.add(userData);
    
    return userData;
  }

}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:work_together/helpers/system_helpers.dart';
import 'package:work_together/helpers/user_firestore.dart';

class UserData {
  String id;
  String email;
  String name;
  String photoUrl;
  String photoFileName;
  bool enabled;
  bool admin;

  UserData({this.id, @required this.email, @required this.name, this.photoUrl, this.photoFileName, this.admin = false, this.enabled = true});

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
      "photoFileName": photoFileName,
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
      photoFileName: item["photoFileName"],
      enabled: item["enabled"],
      admin: item["admin"]
    );
  }

  static Future<UserData> initUser(FirebaseUser user) async {
    List<String> photo = user.photoUrl.split("|");
    print(photo);
    UserData userData = UserData(
      id: user.uid,
      name: user.displayName,
      email: user.email,
      photoFileName: photo[0],
      photoUrl: photo[1]
    );

    await UserFirestore.add(userData, merge: true);
    
    return userData;
  }

  static Future<UserData> createUser(FirebaseUser user, String name, String photoUrl) async {
    UserData userData = UserData(
      id: user.uid,
      name: name,
      email: user.email,
      photoUrl: photoUrl
    );

    await UserFirestore.add(userData);
    
    return userData;
  }

}
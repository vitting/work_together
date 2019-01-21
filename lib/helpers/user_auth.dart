import 'package:firebase_auth/firebase_auth.dart';

class UserAuth {
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static Future<void> sendResetEmail(String email) {
    return firebaseAuth.sendPasswordResetEmail(email: email);
  }

  static Future<FirebaseUser> createUser(String email, String password, String name, String photoUrl) async {
    FirebaseUser user;
    try {
      user = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      await UserAuth.updateProfile(user, name: name, photoUrl: photoUrl);
    } catch (e) {
      print("CreateUser: $e");
    }

    return user;
  }

  static Future<FirebaseUser> login(String email, String password) {
    return firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  static Future<void> logout() {
    return firebaseAuth.signOut();
  }

  static Future<void> updateProfile(FirebaseUser user, {String name, String photoUrl}) async {
    try {
      if (user != null) {
        UserUpdateInfo userInfo = UserUpdateInfo();
        userInfo.photoUrl = photoUrl;
        userInfo.displayName = name;
        await user.updateProfile(userInfo);
      }
    } catch (e) {
      print("UpdateProfile: $e");
    }
  }
}

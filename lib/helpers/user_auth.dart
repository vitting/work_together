import 'package:firebase_auth/firebase_auth.dart';

enum UserAuthState {
  user,
  wrongPassword,
  userNotFound,
  emailAlreadyInUse,
  other
}

class UserAuthData {
  final FirebaseUser user;
  final UserAuthState userAuthLoginState;

  UserAuthData(this.user, this.userAuthLoginState);
}

class UserAuth {
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static Future<void> sendResetEmail(String email) {
    return firebaseAuth.sendPasswordResetEmail(email: email);
  }

  static Future<FirebaseUser> createUser(
      String email, String password, String name, String photoUrl) async {
    FirebaseUser user;
    try {
      user = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      await UserAuth.updateProfile(user, name: name, photoUrl: photoUrl);
      await firebaseAuth.signOut();
      user = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      if (e.toString().contains("ERROR_EMAIL_ALREADY_IN_USE")) {}
    }

    return user;
  }

  static Future<UserAuthData> login(String email, String password) async {
    UserAuthData userAuthData = UserAuthData(null, UserAuthState.other);
    FirebaseUser user;
    try {
      user = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      userAuthData = UserAuthData(user, UserAuthState.user);
    } catch (e) {
      if (e.toString().contains("ERROR_WRONG_PASSWORD")) {
        userAuthData = UserAuthData(user, UserAuthState.wrongPassword);
      } else if (e.toString().contains("ERROR_USER_NOT_FOUND")) {
        userAuthData = UserAuthData(user, UserAuthState.userNotFound);
      }
    }

    return userAuthData;
  }

  static Future<void> logout() {
    return firebaseAuth.signOut();
  }

  static Future<void> updateProfile(FirebaseUser user,
      {String name, String photoUrl}) async {
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

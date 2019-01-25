import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:work_together/helpers/system_helpers.dart';

class FirebaseStorageHelper {
  static final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  static final String _profileImages = "profiles";
  
  static StorageUploadTask uploadProfileImage(File file) {
    String filename = basename(file.path);
    String ext = extension(file.path);
    StorageMetadata meta = StorageMetadata(
      customMetadata: {
        "orginalFilename": filename
      }
    );
    return _firebaseStorage.ref().child("$_profileImages/${SystemHelpers.generateUuid()}$ext").putFile(file, meta);
  }

  Future<void> deleteProfileImage(String filename) {
    return _firebaseStorage.ref().child("$_profileImages/$filename").delete();
  }
}
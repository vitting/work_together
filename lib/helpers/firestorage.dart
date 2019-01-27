import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:work_together/helpers/system_helpers.dart';

class StorageUploadTaskData {
  final StorageUploadTask task;
  final String filename;

  StorageUploadTaskData({this.task, this.filename});
}

class FirebaseStorageHelper {
  static final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  static final String _profileImages = "profiles";
  
  static StorageUploadTaskData uploadProfileImage(File file) {
    String filename = basename(file.path);
    String ext = extension(file.path).toLowerCase();
    String uid = SystemHelpers.generateUuid();
    StorageMetadata meta = StorageMetadata(
      customMetadata: {
        "orginalFilename": filename
      }
    );

    return StorageUploadTaskData(
      task: _firebaseStorage.ref().child("$_profileImages/$uid$ext").putFile(file, meta),
      filename: "$uid$ext"
    );
  }

  static Future<void> deleteProfileImage(String filename) {
    return _firebaseStorage.ref().child("$_profileImages/$filename").delete();
  }
}
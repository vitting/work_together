import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:work_together/helpers/system_helpers.dart';

class StorageUploadTaskData {
  final StorageUploadTask task;
  final String storageFilename;
  final String storageFilenameWithoutExtension;
  final String extension;

  StorageUploadTaskData(
      {this.task,
      this.storageFilename,
      this.storageFilenameWithoutExtension,
      this.extension});
}

class FirebaseStorageHelper {
  static final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  static final String _profileImages = "profiles";

  static StorageUploadTaskData uploadProfileImage(File file) {
    String filename = basename(file.path);
    String ext = extension(file.path).toLowerCase();
    String uid = SystemHelpers.generateUuid();
    StorageMetadata meta =
        StorageMetadata(customMetadata: {"originalFilename": filename});

    return StorageUploadTaskData(
        task: _firebaseStorage
            .ref()
            .child("$_profileImages/$uid$ext")
            .putFile(file, meta),
        storageFilename: "$uid$ext",
        extension: ext,
        storageFilenameWithoutExtension: uid);
  }

  static Future<void> deleteProfileImage(String filename) {
    return _firebaseStorage.ref().child("$_profileImages/$filename").delete();
  }

  static StorageUploadTaskData uploadFile(
      String projectId, File file, String originalFilename, String extension) {
    String uid = SystemHelpers.generateUuid();
    StorageMetadata meta = StorageMetadata(
        customMetadata: {"originalFilename": "$originalFilename.$extension"});

    return StorageUploadTaskData(
        task: _firebaseStorage
            .ref()
            .child("projects/$projectId/$uid.$extension")
            .putFile(file, meta),
        storageFilename: "$uid.$extension",
        extension: extension,
        storageFilenameWithoutExtension: uid);
  }

  static Future<int> downloadFile(
      String projectId, String storageFilename, File file) async {
    final StorageFileDownloadTask task = _firebaseStorage
        .ref()
        .child("projects/$projectId/$storageFilename")
        .writeToFile(file);
    final FileDownloadTaskSnapshot snapshot = await task.future;

    return snapshot.totalByteCount;
  }

  static Future<void> deleteFile(String projectId, String filename) {
    return _firebaseStorage
        .ref()
        .child("projects/$projectId/$filename")
        .delete();
  }

  static Future<void> deleteProjectFiles(String projectId) {
    return _firebaseStorage.ref().child("projects/$projectId").delete();
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';
import 'package:work_together/helpers/file_firestore.dart';
import 'package:work_together/helpers/firestorage.dart';
import 'package:work_together/helpers/user_data.dart';
import 'package:work_together/ui/file/file_create.dart';

class FileData {
  String id;
  DateTime creationDate;
  String projectId;
  String taskId;
  String userId;
  String name;
  String photoUrl;
  /// Types p = project, t = task
  String type; 
  String storageFilename;
  String originalFilename;
  String description;
  String extension;
  int fileSize;
  String downloadUrl;

  FileData({this.id, this.creationDate, this.projectId, this.taskId = "", this.userId, this.name, this.photoUrl, this.type, @required this.storageFilename, @required this.originalFilename, this.description = "", @required this.extension, @required this.downloadUrl, @required this.fileSize});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "creationDate": Timestamp.fromDate(creationDate),
      "projectId": projectId,
      "taskId": taskId,
      "userId": userId,
      "name": name,
      "photoUrl": photoUrl,
      "type": type,
      "storageFilename": storageFilename,
      "originalFilename": originalFilename,
      "description": description,
      "extension": extension,
      "fileSize": fileSize,
      "downloadUrl": downloadUrl
    };
  }

  Future<void> save() {
    creationDate = creationDate ?? DateTime.now();
    return FileFirestore.add(this);
  }

  Future<void> delete() async {
    await FirebaseStorageHelper.deleteFile(projectId, storageFilename);
    return FileFirestore.delete(id);
  }

  Future<String> downloadFile() async {
    final Directory systemTempDir = Directory.systemTemp;
    final String fileLocation = "${systemTempDir.path}/$storageFilename"; 
    final File tempFile = File(fileLocation);
    if (tempFile.existsSync()) {
      await tempFile.delete();
    }
    
    await tempFile.create();

    int totalByteCount = await FirebaseStorageHelper.downloadFile(projectId, storageFilename, tempFile);
    print(totalByteCount);

    return fileLocation;
  }

  factory FileData.fromMap(Map<String, dynamic> item) {
    return FileData(
      id: item["id"],
      creationDate: (item["creationDate"] as Timestamp).toDate(),
      projectId: item["projectId"],
      taskId: item["taskId"],
      userId: item["userId"],
      name: item["name"],
      photoUrl: item["photoUrl"],
      type: item["type"],
      storageFilename: item["storageFilename"],
      originalFilename: item["originalFilename"],
      description: item["description"],
      extension: item["extension"],
      fileSize: item["fileSize"],
      downloadUrl: item["downloadUrl"]
    );
  }

  static Future<List<FileData>> getFilesByProjectId(String projectId) async {
    QuerySnapshot snapshot = await FileFirestore.getFilesByProjectId(projectId);
    return snapshot.documents.map<FileData>((DocumentSnapshot doc) {
      return FileData.fromMap(doc.data);
    }).toList();
  }

  static Stream<QuerySnapshot> getFilesByProjectIdAsStream(String projectId) {
    return FileFirestore.getFilesByProjectIdAsStream(projectId);
  }

  static Stream<QuerySnapshot> getFilesByTaskIdAsStream(String taskId) {
    return FileFirestore.getFilesByTaskIdAsStream(taskId);
  }

  static Future<FileData> uploadFile(String projectId, UserData userData, File file, FileCreateData fileCreateData) async {
    FileData fileData;
    try {
      if (fileCreateData != null) {
        StorageUploadTaskData uploadTask = FirebaseStorageHelper.uploadFile(projectId, file, fileCreateData.name, fileCreateData.extension);
        StorageUploadTask task = uploadTask.task;
        StorageTaskSnapshot snapshot = await task.onComplete;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        fileData = FileData(
          id: uploadTask.storageFilenameWithoutExtension,
          projectId: projectId,
          userId: userData.id,
          name: userData.name,
          photoUrl: userData.photoUrl,
          downloadUrl: downloadUrl,
          extension: fileCreateData.extension,
          description: fileCreateData.comment,
          originalFilename: fileCreateData.name,
          storageFilename: uploadTask.storageFilename,
          fileSize: snapshot.totalByteCount,
        );
      }
    } catch (e) {
      print(e);
    }

    return fileData;
  }
}
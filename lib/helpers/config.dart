import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Config {
  static final String noProfilePicture =
      "https://firebasestorage.googleapis.com/v0/b/work-together-46425.appspot.com/o/profile%2Fblank_profile_picture_250x250.png?alt=media&token=66a92b0b-f020-4348-bbb4-9b95403eba2d";
  static final String noProfilePictureFilename =
      "blank_profile_picture_250x250.png";
  static final String noProfilePictureBlueAsset =
      "assets/images/blank_profile_picture_blue_transparent_250x250.png";
  static final String noProfilePictureWhiteAsset =
      "assets/images/blank_profile_picture_white_transparent_250x250.png";
  static final Color drawerIconColor = Colors.blue[700];
  static final List<String> allowedFileExtensions = [
    "jpg",
    "jpeg",
    "png",
    "bmp",
    "webp",
    "gif",
    "pdf",
    "doc",
    "docx",
    "ppt",
    "pptx",
    "xls",
    "xlsx",
    "mp4"
  ];

  static IconData getFileIcon(String extension) {
    IconData icon;
    switch (extension) {
      case "jpg":
        icon = FontAwesomeIcons.fileImage;
        break;
      case "jpg":
        icon = FontAwesomeIcons.fileImage;
        break;
      case "png":
        icon = FontAwesomeIcons.fileImage;
        break;
      case "gif":
        icon = FontAwesomeIcons.fileImage;
        break;
      case "bmp":
        icon = FontAwesomeIcons.fileImage;
        break;
      case "webp":
        icon = FontAwesomeIcons.fileImage;
        break;
      case "pdf":
        icon = FontAwesomeIcons.filePdf;
        break;
      case "doc":
        icon = FontAwesomeIcons.fileWord;
        break;
      case "docx":
        icon = FontAwesomeIcons.fileWord;
        break;
      case "ppt":
        icon = FontAwesomeIcons.filePowerpoint;
        break;
      case "pptx":
        icon = FontAwesomeIcons.filePowerpoint;
        break;
      case "xls":
        icon = FontAwesomeIcons.fileExcel;
        break;
      case "xlsx":
        icon = FontAwesomeIcons.fileExcel;
        break;
      case "mp4":
        icon = FontAwesomeIcons.fileVideo;
        break;
      default:
        icon = FontAwesomeIcons.file;
    }

    return icon;
  }
}

import 'package:flutter/material.dart';
import 'package:work_together/helpers/comment_data.dart';
import 'package:work_together/helpers/file_data.dart';
import 'package:work_together/helpers/project_data.dart';
import 'package:work_together/ui/project/detail/project_detail_main.dart';
import 'package:work_together/ui/project/search/search_comment_delegate.dart';
import 'package:work_together/ui/project/search/search_file_delegate.dart';

void showProjectSearch(
    BuildContext context, ProjectData project, ProjectDetailType type) async {
  dynamic result;
  switch (type) {
    case ProjectDetailType.tasks:
      break;
    case ProjectDetailType.comments:
      result = await showSearch<CommentData>(
        context: context,
        delegate: CommentSearchDelegate(await project.getComments()),
      );
      break;
    case ProjectDetailType.files:
      result = await showSearch<FileData>(
        context: context,
        delegate: FileSearchDelegate(await project.getFiles()),
      );
      break;
    default:
  }

  print(result);
}

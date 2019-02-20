import 'package:flutter/material.dart';
import 'package:work_together/helpers/config.dart';
import 'package:work_together/helpers/date_time_helpers.dart';
import 'package:work_together/helpers/file_data.dart';
import 'package:work_together/ui/widgets/square_thumb_image_widget.dart';
import 'package:work_together/ui/widgets/text_expand_widget.dart';
import 'package:work_together/ui/widgets/title_row_icon_widget.dart';

class FileRow extends StatelessWidget {
  final FileData file;
  final ValueChanged<bool> onTapMenu;
  final ValueChanged<FileData> onTapRow;
  final Color backgroundColor;
  final Color textColor;

  const FileRow(
      {Key key,
      @required this.file,
      this.onTapMenu,
      this.onTapRow,
      this.backgroundColor = Colors.white,
      this.textColor = Colors.black})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      child: ListTile(
        contentPadding: EdgeInsets.all(5),
        onTap: () {
          if (onTapRow != null) {
            onTapRow(file);
          }
        },
        title: TitleRowIcon(
          textColor: textColor,
          leading: _getIconImage(file),
          title: "${file.originalFilename}.${file.extension}",
          onTapMenu: onTapMenu,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            file.description.isEmpty
                ? Container()
                : Container(
                    padding: const EdgeInsets.only(left: 50, right: 35),
                    child: TextExpand(
                        text: file.description, textColor: textColor)),
            SizedBox(height: 10),
            Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Icon(Icons.calendar_today,
                            size: 12, color: textColor),
                      ),
                      Flexible(
                        child: Text(
                            DateTimeHelpers.ddmmyyyyHHnn(file.creationDate),
                            style: TextStyle(fontSize: 12, color: textColor)),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Icon(Icons.person, size: 14, color: textColor),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Text(file.name,
                              style: TextStyle(fontSize: 12, color: textColor)),
                          onTap: () {},
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  dynamic _getIconImage(FileData file) {
    if (Config.isImage(file.extension)) {
      return SquareThumbImage(
        textColor: textColor,
        imageUrl: file.downloadUrl,
      );
    } else {
      return Container(
        padding: EdgeInsets.all(5),
        child: Icon(Config.getFileIcon(file.extension),
            size: 30, color: textColor),
      );
    }
  }
}

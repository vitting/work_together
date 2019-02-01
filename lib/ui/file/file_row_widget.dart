import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:work_together/helpers/config.dart';
import 'package:work_together/helpers/date_time_helpers.dart';
import 'package:work_together/helpers/file_data.dart';
import 'package:work_together/ui/widgets/text_expand_widget.dart';
import 'package:work_together/ui/widgets/title_row_icon_widget.dart';

class FileRow extends StatelessWidget {
  final FileData file;
  final ValueChanged<bool> onTapMenu;
  final ValueChanged<FileData> onTapRow;

  const FileRow({Key key, @required this.file, this.onTapMenu, this.onTapRow})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: EdgeInsets.all(5),
        onTap: () {
          if (onTapRow != null) {
            onTapRow(file);
          }
        },
        title: TitleRowIcon(
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
                    child: TextExpand(text: file.description)),
            SizedBox(height: 10),
            Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Icon(Icons.calendar_today, size: 12),
                      ),
                      Flexible(
                        child: Text(
                            DateTimeHelpers.ddmmyyyyHHnn(file.creationDate),
                            style: TextStyle(fontSize: 12)),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Icon(Icons.person, size: 14),
                      ),
                      Expanded(
                        child: InkWell(
                          child:
                              Text(file.name, style: TextStyle(fontSize: 12)),
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
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: CachedNetworkImage(
          imageUrl: file.downloadUrl,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorWidget: Icon(Icons.image, size: 40, color: Colors.blue[700]),
          placeholder: Icon(Icons.image, size: 40, color: Colors.blue[700]),
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(5),
        child: Icon(Config.getFileIcon(file.extension), size: 30),
      );
    }
  }
}

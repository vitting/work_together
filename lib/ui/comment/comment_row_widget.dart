import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:work_together/helpers/comment_data.dart';
import 'package:work_together/helpers/date_time_helpers.dart';
import 'package:work_together/ui/widgets/text_expand_widget.dart';
import 'package:work_together/ui/widgets/title_row_icon_widget.dart';

class CommentRow extends StatelessWidget {
  final CommentData comment;
  final ValueChanged<bool> onTapMenu;
  final ValueChanged<CommentData> onTapRow;
  final ValueChanged<bool> onTapDescription;
  final bool showExpanded;
  final Color backgroundColor;
  final Color textColor;

  const CommentRow(
      {Key key,
      this.comment,
      this.onTapMenu,
      this.onTapRow,
      this.showExpanded = false,
      this.backgroundColor = Colors.white,
      this.textColor = Colors.black,
      this.onTapDescription})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      child: ListTile(
        onTap: () {
          if (onTapRow != null) {
            onTapRow(comment);
          }
        },
        title: TitleRowIcon(
          textColor: textColor,
          onTapMenu: onTapMenu,
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(comment.photoUrl),
          ),
          title: comment.name,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 35),
              child: TextExpand(
                  text: comment.comment,
                  showExpanded: showExpanded,
                  textColor: textColor,
                  onTap: onTapDescription),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Icon(Icons.calendar_today, size: 10, color: textColor),
                ),
                Text(DateTimeHelpers.ddmmyyyyHHnn(comment.commentDate),
                    style: TextStyle(fontSize: 12, color: textColor))
              ],
            )
          ],
        ),
      ),
    );
  }
}

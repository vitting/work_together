import 'package:flutter/material.dart';
import 'package:work_together/helpers/comment_data.dart';
import 'package:work_together/ui/comment/comment_row_widget.dart';
import 'package:work_together/ui/widgets/no_data_widget.dart';

class CommentSearchDelegate extends SearchDelegate<CommentData> {
  final List<CommentData> items;
  List<CommentData> _selected = [];
  CommentSearchDelegate(this.items);

  @override
  ThemeData appBarTheme(BuildContext context) {
    // TODO: implement appBarTheme
    return super.appBarTheme(context);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'Clear',
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          _selected = [];
          showSuggestions(context);
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (_selected.length == 0) {
      return Center(
        child: NoData(
          text: "Ingen resultater",
          icon: Icons.comment,
        ),
      );
    } else {
      return ListView.builder(
        itemCount: _selected.length,
        itemBuilder: (BuildContext context, int position) {
          CommentData commentData = _selected[position];
          return CommentRow(
            comment: commentData,
            onTapMenu: null,
            onTapRow: (CommentData value) {
              close(context, value);
            },
          );
        },
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (items.length == 0) {
      return Center(
        child: NoData(
          text: "Ingen kommentar",
          icon: Icons.comment,
        ),
      );
    }
    if (query.isEmpty) {
      return ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int position) {
          CommentData commentData = items[position];
          return CommentRow(
            comment: commentData,
            onTapMenu: null,
            onTapRow: (CommentData value) {
              close(context, commentData);
            },
          );
        },
      );
    } else {
      _selected = items.where((CommentData data) {
        return data.comment.toLowerCase().contains(query);
      }).toList();

      if (_selected.length == 0) {
        return Center(
          child: NoData(
            text: "Ingen resultater",
            icon: Icons.comment,
          ),
        );
      } else {
        return ListView.builder(
          itemCount: _selected.length,
          itemBuilder: (BuildContext context, int position) {
            CommentData data = _selected[position];
            return CommentRow(
              comment: data,
              onTapMenu: null,
              onTapRow: (CommentData value) {
                close(context, value);
              },
            );
          },
        );
      }
    }
  }
}

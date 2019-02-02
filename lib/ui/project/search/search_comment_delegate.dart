import 'package:flutter/material.dart';
import 'package:work_together/helpers/comment_data.dart';
import 'package:work_together/ui/comment/comment_row_widget.dart';
import 'package:work_together/ui/widgets/no_data_widget.dart';

class CommentSearchDelegate extends SearchDelegate<CommentData> {
  final List<CommentData> searchItems;
  final Color textColor;
  final Color backgroundColor;
  List<CommentData> _selected = [];
  CommentSearchDelegate(
      {this.searchItems,
      this.textColor = Colors.black,
      this.backgroundColor = Colors.white});

  @override
  ThemeData appBarTheme(BuildContext context) {
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
      return _noResult("Ingen kommentar");
    } else {
      return _results(_selected);
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (searchItems.length == 0) {
      return _noResult("Ingen kommentar");
    }
    if (query.isEmpty) {
      return ListView.builder(
        itemCount: searchItems.length,
        itemBuilder: (BuildContext context, int position) {
          CommentData commentData = searchItems[position];
          return CommentRow(
            comment: commentData,
            backgroundColor: backgroundColor,
            textColor: textColor,
            onTapMenu: null,
            onTapRow: (CommentData value) {
              close(context, commentData);
            },
          );
        },
      );
    } else {
      _selected = searchItems.where((CommentData data) {
        return data.comment.toLowerCase().contains(query);
      }).toList();

      if (_selected.length == 0) {
        return _noResult("Ingen kommentar");
      } else {
        return _results(_selected);
      }
    }
  }

  Widget _noResult(String text) {
    return Center(
      child: NoData(
        text: text,
        icon: Icons.comment,
      ),
    );
  }

  Widget _results(List<CommentData> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int position) {
        CommentData data = items[position];
        return CommentRow(
          comment: data,
          backgroundColor: backgroundColor,
          textColor: textColor,
          onTapMenu: null,
          onTapRow: (CommentData value) {
            close(context, value);
          },
        );
      },
    );
  }
}

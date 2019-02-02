import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:work_together/helpers/file_data.dart';
import 'package:work_together/ui/file/file_row_widget.dart';
import 'package:work_together/ui/widgets/no_data_widget.dart';

class FileSearchDelegate extends SearchDelegate<FileData> {
  final List<FileData> searchItems;
  final Color textColor;
  final Color backgroundColor;
  List<FileData> _selected = [];
  FileSearchDelegate(
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
      return _noResult("Ingen filer");
    } else {
      return _results(_selected);
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (searchItems.length == 0) {
      return _noResult("Ingen filer");
    }
    if (query.isEmpty) {
      return ListView.builder(
        itemCount: searchItems.length,
        itemBuilder: (BuildContext context, int position) {
          FileData fileData = searchItems[position];
          return FileRow(
            file: fileData,
            backgroundColor: backgroundColor,
            textColor: textColor,
            onTapMenu: null,
            onTapRow: (FileData value) {
              close(context, value);
            },
          );
        },
      );
    } else {
      _selected = searchItems.where((FileData data) {
        return data.originalFilename.toLowerCase().contains(query) ||
            data.description.toLowerCase().contains(query);
      }).toList();

      if (_selected.length == 0) {
        return _noResult("Ingen filer");
      } else {
        return _results(_selected);
      }
    }
  }

  Widget _noResult(String text) {
    return Center(
      child: NoData(
        text: text,
        icon: FontAwesomeIcons.file,
      ),
    );
  }

  Widget _results(List<FileData> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int position) {
        FileData fileData = items[position];
        return FileRow(
          file: fileData,
          backgroundColor: backgroundColor,
          textColor: textColor,
          onTapMenu: null,
          onTapRow: (FileData value) {
            close(context, value);
          },
        );
      },
    );
  }
}

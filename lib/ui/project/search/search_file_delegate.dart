import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:work_together/helpers/file_data.dart';
import 'package:work_together/ui/file/file_row_widget.dart';
import 'package:work_together/ui/widgets/no_data_widget.dart';

class FileSearchDelegate extends SearchDelegate<FileData> {
  final List<FileData> items;
  List<FileData> _selected = [];
  FileSearchDelegate(this.items);

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
          icon: FontAwesomeIcons.file,
        ),
      );
    } else {
      return ListView.builder(
        itemCount: _selected.length,
        itemBuilder: (BuildContext context, int position) {
          FileData fileData = _selected[position];
          return FileRow(
            file: fileData,
            onTapMenu: null,
            onTapRow: (FileData value) {
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
          text: "Ingen filer",
          icon: FontAwesomeIcons.file,
        ),
      );
    }
    if (query.isEmpty) {
      return ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int position) {
          FileData fileData = items[position];
          return FileRow(
            file: fileData,
            onTapMenu: null,
            onTapRow: (FileData value) {
              close(context, fileData);
            },
          );
        },
      );
    } else {
      _selected = items.where((FileData data) {
        return data.originalFilename.toLowerCase().contains(query) ||
            data.description.toLowerCase().contains(query);
      }).toList();

      if (_selected.length == 0) {
        return Center(
          child: NoData(
            text: "Ingen resultater",
            icon: FontAwesomeIcons.file,
          ),
        );
      } else {
        return ListView.builder(
          itemCount: _selected.length,
          itemBuilder: (BuildContext context, int position) {
            FileData fileData = _selected[position];
            return FileRow(
              file: fileData,
              onTapMenu: null,
              onTapRow: (FileData value) {
                close(context, value);
              },
            );
          },
        );
      }
    }
  }
}

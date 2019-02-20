import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:work_together/helpers/config.dart';
import 'package:work_together/helpers/file_data.dart';
import 'package:work_together/helpers/project_data.dart';
import 'package:work_together/ui/widgets/dialog_color_widget.dart';
import 'package:work_together/ui/widgets/dot_icon_widget.dart';
import 'package:work_together/ui/widgets/round_button_widget.dart';

class FileCreateData {
  String name;
  String extension;
  String comment;

  FileCreateData({this.name, this.extension, this.comment});
}

class FileCreate extends StatefulWidget {
  final String path;
  final FileData fileData;
  final ProjectData project;

  const FileCreate({Key key, this.path, this.fileData, this.project}) : super(key: key);
  @override
  _FileCreateState createState() => _FileCreateState();
}

class _FileCreateState extends State<FileCreate> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FileCreateData _fileCreateData;
  Color _backgroundColor;

  @override
  void initState() {
    super.initState();
    _backgroundColor = DialogColorConvert.getColorFromInt(widget.project.color);
    if (widget.fileData == null) {
      String filename = basenameWithoutExtension(widget.path);
      String fileExtension =
          extension(widget.path).replaceAll(".", "").toLowerCase();
      _fileCreateData =
          FileCreateData(name: filename, extension: fileExtension, comment: "");
    } else {
      _fileCreateData = FileCreateData(
        name: widget.fileData.originalFilename,
        comment: widget.fileData.description,
        extension: widget.fileData.extension
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        title: Text("Tilføj fil"),
      ),
      body: Card(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: <Widget>[
                      Config.isImage(_fileCreateData.extension) ? DotIcon(
                        imagePath: widget.path ?? widget.fileData.downloadUrl,
                      ) : DotIcon(
                        backgroundColor: _backgroundColor,
                        icon: Config.getFileIcon(_fileCreateData.extension),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[Text(_fileCreateData.extension)],
                      )
                    ],
                  ),
                ),
                TextFormField(
                  initialValue: _fileCreateData.name,
                  maxLength: 100,
                  decoration: InputDecoration(labelText: "Fil navn"),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "Fil navnet skal udfyldes";
                    }
                  },
                  onSaved: (String value) {
                    _fileCreateData.name = value.trim();
                  },
                ),
                TextFormField(
                  initialValue: _fileCreateData.comment,
                  maxLength: 1000,
                  maxLines: 4,
                  decoration: InputDecoration(labelText: "Kommentar"),
                  onSaved: (String value) {
                    _fileCreateData.comment = value.trim();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RoundButton(
                        text: "Gem",
                        backgroundColor: _backgroundColor,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            Navigator.of(context).pop(_fileCreateData);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

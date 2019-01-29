import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart';
import 'package:work_together/helpers/config.dart';
import 'package:work_together/ui/widgets/round_button_widget.dart';

class FileCreateData {
  String name;
  String extension;
  String comment;

  FileCreateData({this.name, this.extension, this.comment});
}

class FileCreate extends StatefulWidget {
  final String path;

  const FileCreate({Key key, this.path}) : super(key: key);
  @override
  _FileCreateState createState() => _FileCreateState();
}

class _FileCreateState extends State<FileCreate> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FileCreateData _fileData;
  @override
  void initState() {
    super.initState();
    String filename = basenameWithoutExtension(widget.path);
    String fileExtension =
        extension(widget.path).replaceAll(".", "").toLowerCase();
    _fileData =
        FileCreateData(name: filename, extension: fileExtension, comment: "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Config.getFileIcon(_fileData.extension), size: 40)
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[Text(_fileData.extension)],
                      )
                    ],
                  ),
                ),
                TextFormField(
                  initialValue: _fileData.name,
                  maxLength: 100,
                  decoration: InputDecoration(labelText: "Fil navn"),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "Fil navnet skal udfyldes";
                    }
                  },
                  onSaved: (String value) {
                    _fileData.name = value.trim();
                  },
                ),
                TextFormField(
                  initialValue: _fileData.comment,
                  maxLength: 1000,
                  maxLines: 4,
                  decoration: InputDecoration(labelText: "Kommentar"),
                  onSaved: (String value) {
                    _fileData.comment = value.trim();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RoundButton(
                        text: "Gem",
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            Navigator.of(context).pop(_fileData);
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

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:work_together/helpers/config.dart';
import 'package:work_together/helpers/firestorage.dart';
import 'package:work_together/helpers/user_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:work_together/ui/widgets/circle_profile_image_widget.dart';

enum ImageFileDialogAction { add, remove }

class ImageFileDialog {
  final dynamic image;
  final ImageFileDialogAction action;
  final CircleProfileImageType imageType;

  ImageFileDialog(this.image, this.action, this.imageType);
}

class SignupMain extends StatefulWidget {
  static final String routeName = "signupmain";

  @override
  _SignupMainState createState() => _SignupMainState();
}

class _SignupMainState extends State<SignupMain> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _passwordKey = GlobalKey<FormFieldState>();
  final TextEditingController _nameController = TextEditingController(text: "");
  final TextEditingController _emailController =
      TextEditingController(text: "");
  final TextEditingController _passwordController =
      TextEditingController(text: "");
  final TextEditingController _password2Controller =
      TextEditingController(text: "");
  String _profileImageDefault =
      "assets/images/blank_profile_picture_blue_transparent_250x250.png";
  dynamic _profileImage =
      "assets/images/blank_profile_picture_blue_transparent_250x250.png";
  CircleProfileImageType _profileImageType = CircleProfileImageType.asset;
  IconData _profileImageIcon = Icons.add_a_photo;
  int _fileUploadBytesTransferred = 0;
  bool _profileImageLoaded = false;

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _password2Controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Opret bruger"),
      ),
      body: Card(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleProfileImage(
                      type: _profileImageType,
                      image: _profileImage,
                      size: 80,
                      icon: _profileImageIcon,
                      iconColor: Colors.white70,
                      iconSize: 40,
                      backgroundColor: Colors.blue,
                      onTap: (_) {
                        _showBottomMenu(context);
                      },
                    ),
                  ],
                ),
                Text(_fileUploadBytesTransferred.toString()),
                TextFormField(
                  initialValue: _nameController.text,
                  maxLength: 50,
                  decoration: InputDecoration(labelText: "Navn"),
                  validator: (String value) {
                    if (value.trim().isEmpty) {
                      return "Udfyld navn";
                    }
                  },
                  onSaved: (String value) {
                    _nameController.text = value.trim();
                  },
                ),
                TextFormField(
                  initialValue: _emailController.text,
                  maxLength: 50,
                  decoration: InputDecoration(labelText: "E-mail"),
                  validator: (String value) {
                    if (value.trim().isEmpty) {
                      return "Udfyld e-email adresse";
                    }
                  },
                  onSaved: (String value) {
                    _emailController.text = value.trim();
                  },
                ),
                TextFormField(
                    key: _passwordKey,
                    initialValue: _passwordController.text,
                    maxLength: 50,
                    obscureText: true,
                    decoration: InputDecoration(labelText: "Kodeord"),
                    validator: (String value) {
                      if (value.trim().isEmpty) {
                        return "Udfyld kodeord";
                      } else if (value.trim().length < 6) {
                        return "Kodeordet skal være på mindst 6 tegn";
                      }
                    },
                    onSaved: (String value) {
                      _passwordController.text = value.trim();
                    }),
                TextFormField(
                  initialValue: _password2Controller.text,
                  maxLength: 50,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Gentag kodeord"),
                  validator: (String value) {
                    if (value.trim().isEmpty) {
                      return "Udfyld kodeord";
                    } else if (value != _passwordKey.currentState.value) {
                      return "Kodeord er ikke ens";
                    } else if (value.trim().length < 6) {
                      return "Kodeordet skal være på mindst 6 tegn";
                    }
                  },
                  onSaved: (String value) {
                    _password2Controller.text = value.trim();
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                FlatButton.icon(
                  icon: Icon(Icons.person_add),
                  label: Text("Opret"),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      FirebaseUser user = await UserAuth.createUser(
                          _emailController.text,
                          _passwordController.text,
                          _nameController.text,
                          Config.noProfilePicture);
                      if (user != null) {
                        Navigator.of(context).pop();
                      } else {
                        _showEmailError(context);
                      }
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEmailError(BuildContext context) async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text("E-mail eksistere"),
            content: Text(
                "Vi kan desværre ikke oprette din konto da den e-mail adresse du har indtastet allerede er i brug.\n\nPrøv med en anden e-mail adresse."),
            actions: <Widget>[
              FlatButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              )
            ],
          );
        });
  }

  void _showBottomMenu(BuildContext context) async {
    ImageFileDialog imageFileDialog =
        await showModalBottomSheet<ImageFileDialog>(
            context: context,
            builder: (BuildContext bottomMenuContext) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _profileImageLoaded ? ListTile(
                    leading: Icon(Icons.image),
                    title: Text("Fjern billede"),
                    onTap: () async {
                      Navigator.of(bottomMenuContext).pop(ImageFileDialog(
                          _profileImageDefault,
                          ImageFileDialogAction.remove,
                          CircleProfileImageType.asset));
                    },
                  ) : Container(),
                  ListTile(
                    leading: Icon(Icons.image),
                    title: Text("Tilføj billede fra galleri"),
                    onTap: () async {
                      File image = await ImagePicker.pickImage(
                          source: ImageSource.gallery,
                          maxHeight: 100,
                          maxWidth: 100);
                      Navigator.of(bottomMenuContext).pop(ImageFileDialog(
                          image,
                          ImageFileDialogAction.add,
                          CircleProfileImageType.file));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.camera_alt),
                    title: Text("Tilføj billede fra kamera"),
                    onTap: () async {
                      File image = await ImagePicker.pickImage(
                          source: ImageSource.camera,
                          maxHeight: 100,
                          maxWidth: 100);
                      Navigator.of(bottomMenuContext).pop(ImageFileDialog(
                          image,
                          ImageFileDialogAction.add,
                          CircleProfileImageType.file));
                    },
                  )
                ],
              );
            });

    if (imageFileDialog != null) {
      if (imageFileDialog.action == ImageFileDialogAction.add) {
        StorageUploadTask task =
            FirebaseStorageHelper.uploadProfileImage(imageFileDialog.image);

        task.events.listen((StorageTaskEvent event) {
            setState(() {
              print("${event.snapshot.bytesTransferred} / ${event.snapshot.totalByteCount}");
              double a = event.snapshot.bytesTransferred * 100 / event.snapshot.totalByteCount;
              print(a.toString());
              _fileUploadBytesTransferred = event.snapshot.bytesTransferred;
            });
        });

        StorageTaskSnapshot snapshot = await task.onComplete;
        print(await snapshot.ref.getDownloadURL());
      }

      setState(() {
        _profileImageLoaded = true;
        _profileImage = imageFileDialog.image;
        _profileImageType = imageFileDialog.imageType;
        _profileImageIcon = imageFileDialog.action == ImageFileDialogAction.add
            ? null
            : Icons.add_a_photo;
      });
    }
  }
}

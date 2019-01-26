import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:validate/validate.dart';
import 'package:work_together/helpers/config.dart';
import 'package:work_together/helpers/firestorage.dart';
import 'package:work_together/helpers/user_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:work_together/helpers/user_data.dart';
import 'package:work_together/helpers/validator_helper.dart';
import 'package:work_together/ui/widgets/circle_profile_image_widget.dart';
import 'package:work_together/ui/widgets/round_button_widget.dart';

enum ImageFileDialogAction { add, remove }
enum FrontImageAction { image, noImage, loading }

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
  dynamic _profileImage =
      "assets/images/blank_profile_picture_blue_transparent_250x250.png";
  CircleProfileImageType _profileImageType = CircleProfileImageType.asset;
  bool _profileImageLoaded = false;
  Widget _profileImageFront;
  String _profileImageUrl = "";
  bool _isLoading = false;
  bool _obscurePassword = true;
  Color _showPasswordButtonColor;

  @override
  void initState() {
    super.initState();
    _profileImageFront = _getFrontIcon(FrontImageAction.noImage);
  }

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
                      front: _profileImageFront,
                      backgroundColor: Colors.blue,
                      onTap: (_) {
                        _showBottomMenu(context);
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  initialValue: _nameController.text,
                  inputFormatters: [LengthLimitingTextInputFormatter(50)],
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
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  initialValue: _emailController.text,
                  inputFormatters: [LengthLimitingTextInputFormatter(50)],
                  decoration: InputDecoration(labelText: "E-mail"),
                  validator: (String value) {
                    if (value.trim().isEmpty) {
                      return "Udfyld e-email adresse";
                    }

                    try {
                      Validate.isEmail(value);
                    } catch (e) {
                      return "Ikke en valid e-mail adresse";
                    }
                  },
                  onSaved: (String value) {
                    _emailController.text = value.trim();
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                    key: _passwordKey,
                    initialValue: _passwordController.text,
                    inputFormatters: [LengthLimitingTextInputFormatter(50)],
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                            color: _showPasswordButtonColor,
                            icon: Icon(Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                                _showPasswordButtonColor =
                                    _obscurePassword ? null : Colors.blue[900];
                              });
                            }),
                        labelText: "Kodeord",
                        helperText: "Skal bestå af mindst 6 tegn"),
                    validator: (String value) {
                      return ValidatorHelper.isPassword(value);
                    },
                    onSaved: (String value) {
                      _passwordController.text = value.trim();
                    }),
                TextFormField(
                  initialValue: _password2Controller.text,
                  inputFormatters: [LengthLimitingTextInputFormatter(50)],
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(labelText: "Gentag kodeord"),
                  validator: (String value) {
                    String returnValue = ValidatorHelper.isPassword(value);

                    if (returnValue != null) {
                      return returnValue;
                    } else if (value != _passwordKey.currentState.value) {
                      return "Kodeord er ikke ens";
                    }
                  },
                  onSaved: (String value) {
                    _password2Controller.text = value.trim();
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                RoundButton(
                  disabled: _isLoading,
                  text: "Opret",
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      String profileImage = Config.noProfilePicture;
                      if (_profileImageUrl.isNotEmpty) {
                        profileImage = _profileImageUrl;
                      }

                      FirebaseUser user = await UserAuth.createUser(
                          _emailController.text,
                          _passwordController.text,
                          _nameController.text,
                          profileImage);

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
          return SimpleDialog(
            contentPadding: EdgeInsets.all(20),
            title: Text("E-mail eksistere"),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                    "Vi kan desværre ikke oprette din konto da den e-mail adresse du har indtastet allerede er i brug.\n\nPrøv med en anden e-mail adresse.", textAlign: TextAlign.center,),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: RoundButton(
                  text: "Ok",
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                ),
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
                  _profileImageLoaded
                      ? ListTile(
                          leading: Icon(Icons.image),
                          title: Text("Fjern billede"),
                          onTap: () async {
                            Navigator.of(bottomMenuContext).pop(ImageFileDialog(
                                Config.noProfilePictureBlueAsset,
                                ImageFileDialogAction.remove,
                                CircleProfileImageType.asset));
                          },
                        )
                      : Container(),
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
        setState(() {
          _isLoading = true;
          _profileImageFront = _getFrontIcon(FrontImageAction.loading);
        });

        StorageUploadTask task =
            FirebaseStorageHelper.uploadProfileImage(imageFileDialog.image);

        StorageTaskSnapshot snapshot = await task.onComplete;
        String url = await snapshot.ref.getDownloadURL();

        setState(() {
          _isLoading = false;
          _profileImageFront = _getFrontIcon(FrontImageAction.image);
          _profileImageUrl = url;
        });
      } else if (imageFileDialog.action == ImageFileDialogAction.remove) {
        _profileImageUrl = "";
      }

      setState(() {
        _profileImageLoaded =
            imageFileDialog.action == ImageFileDialogAction.add;
        _profileImage = imageFileDialog.image;
        _profileImageType = imageFileDialog.imageType;
        _profileImageFront = imageFileDialog.action == ImageFileDialogAction.add
            ? _getFrontIcon(FrontImageAction.image)
            : _getFrontIcon(FrontImageAction.noImage);
      });
    }
  }

  Widget _getFrontIcon(FrontImageAction action) {
    Widget returnValue;
    switch (action) {
      case FrontImageAction.image:
        returnValue = null;
        break;
      case FrontImageAction.noImage:
        returnValue = Icon(Icons.add_a_photo, color: Colors.white70, size: 40);
        break;
      case FrontImageAction.loading:
        returnValue = CircularProgressIndicator(
          strokeWidth: 10,
        );
        break;
    }

    return returnValue;
  }
}

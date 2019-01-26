import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:validate/validate.dart';
import 'package:work_together/helpers/config.dart';
import 'package:work_together/helpers/user_auth.dart';
import 'package:work_together/helpers/validator_helper.dart';
import 'package:work_together/ui/signup/signup_main.dart';
import 'package:work_together/ui/widgets/circle_profile_image_widget.dart';
import 'package:work_together/ui/widgets/round_button_widget.dart';

class LoginMain extends StatefulWidget {
  static final String routeName = "loginmain";

  @override
  LoginMainState createState() {
    return new LoginMainState();
  }
}

class LoginMainState extends State<LoginMain> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController =
      TextEditingController(text: "");
  final TextEditingController _passwordController =
      TextEditingController(text: "");
  bool _obscurePassword = true;
  Color _showPasswordButtonColor;
  int _buttonIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
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
                        type: CircleProfileImageType.asset,
                        image: Config.noProfilePictureBlueAsset,
                        size: 80,
                        backgroundColor: Colors.blue),
                  ],
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
                  ),
                  validator: (String value) {
                    return ValidatorHelper.isPassword(value);
                  },
                  onSaved: (String value) {
                    _passwordController.text = value.trim();
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: IndexedStack(
                      index: _buttonIndex,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RoundButton(
                                text: "Login",
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                    setState(() {
                                      _buttonIndex = 1;
                                    });
                                    UserAuthData userAuthData =
                                        await UserAuth.login(
                                            _emailController.text,
                                            _passwordController.text);
                                    if (userAuthData.userAuthLoginState ==
                                            UserAuthState.userNotFound ||
                                        userAuthData.userAuthLoginState ==
                                            UserAuthState.wrongPassword) {
                                      setState(() {
                                        _buttonIndex = 0;
                                      });

                                      _showLoginError(context, 0);
                                    } else if (userAuthData
                                            .userAuthLoginState ==
                                        UserAuthState.other) {
                                      setState(() {
                                        _buttonIndex = 0;
                                      });
                                      _showLoginError(context, 1);
                                    }
                                  }
                                }),
                          ],
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[CircularProgressIndicator()])
                      ],
                    )),
                Text(
                  "eller",
                  textAlign: TextAlign.center,
                ),
                FlatButton(
                  textColor: Colors.blue[700],
                  child: Text("Opret ny bruger"),
                  onPressed: () {
                    Navigator.of(context).pushNamed(SignupMain.routeName);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLoginError(BuildContext context, int errorIndex) async {
    await showDialog<bool>(
        context: context,
        builder: (BuildContext dialogContext) {
          return SimpleDialog(
              contentPadding: EdgeInsets.all(20),
              title: Text("Kan ikke logge ind"),
              children: _getErrorContent(dialogContext, errorIndex));
        });
  }

  List<Widget> _getErrorContent(BuildContext context, int errorIndex) {
    List<Widget> widgets = [];

    switch (errorIndex) {
      case 0:
        widgets.addAll([
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
                "Din indtastede e-mail adresse eller kodeord er ikke korrekt.",
                textAlign: TextAlign.center),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text("Tjek din e-mail adresse og dit kodeord.",
                textAlign: TextAlign.center),
          )
        ]);
        break;
      case 1:
        widgets.addAll([
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text("Der skete en fejl under login. Prøv igen.",
                textAlign: TextAlign.center),
          )
        ]);
        break;
    }

    widgets.add(Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: RoundButton(
        text: "Ok",
        onPressed: () {
          Navigator.of(context).pop(true);
        },
      ),
    ));

    return widgets;
  }
}

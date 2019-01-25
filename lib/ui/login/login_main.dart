import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:work_together/helpers/user_auth.dart';
import 'package:work_together/ui/signup/signup_main.dart';

class LoginMain extends StatefulWidget {
  static final String routeName = "loginmain";

  @override
  LoginMainState createState() {
    return new LoginMainState();
  }
}

class LoginMainState extends State<LoginMain> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController(text: "");
  final TextEditingController _passwordController = TextEditingController(text: "");
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: ListView(
              // mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextFormField(
          initialValue: _emailController.text,
          maxLength: 50,
          decoration: InputDecoration(
            labelText: "E-mail"
          ),
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
          initialValue: _passwordController.text,
          maxLength: 50,
          obscureText: true,
          decoration: InputDecoration(
            labelText: "Kodeord"
          ),
          validator: (String value) {
            if (value.trim().isEmpty) {
              return "Udfyld kodeord";
            }
          },
          onSaved: (String value) {
            _passwordController.text = value.trim();
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
        ),
        FlatButton.icon(
          icon: Icon(FontAwesomeIcons.signInAlt),
          label: Text("Login"),
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              await UserAuth.login(_emailController.text, _passwordController.text);
            }
          },
        ),
        Text("eller", textAlign: TextAlign.center,),
        FlatButton.icon(
          icon: Icon(Icons.person_add),
          label: Text("Opret ny bruger"),
          onPressed: () {
            Navigator.of(context).pushNamed(SignupMain.routeName);
          },
        )
      ],
            ),
          ),
        ),
    );
  }
}
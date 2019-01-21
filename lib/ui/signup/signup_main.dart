import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:work_together/helpers/user_auth.dart';

class SignupMain extends StatefulWidget {
  static final String routeName = "signupmain";

  @override
  _SignupMainState createState() => _SignupMainState();
}

class _SignupMainState extends State<SignupMain> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _passwordKey = GlobalKey<FormFieldState>();
  final TextEditingController _nameController = TextEditingController(text: "");
  final TextEditingController _emailController = TextEditingController(text: "");
  final TextEditingController _passwordController = TextEditingController(text: "");
  final TextEditingController _password2Controller = TextEditingController(text: "");

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
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  initialValue: _nameController.text,
                  maxLength: 50,
                  decoration: InputDecoration(
                    labelText: "Navn"
                  ),
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
                  key: _passwordKey,
                  initialValue: _passwordController.text,
                  maxLength: 50,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Kodeord"
                  ),
                  validator: (String value) {
                    if (value.trim().isEmpty) {
                      return "Udfyld kodeord";
                    } else if (value.trim().length < 6) {
                      return "Kodeordet skal være på mindst 6 tegn";
                    }
                  },
                  onSaved: (String value) {
                    _passwordController.text = value.trim();
                  }  
                ),
                TextFormField(
                  initialValue: _password2Controller.text,
                  maxLength: 50,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Gentag kodeord"
                  ),
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
                     FirebaseUser user = await UserAuth.createUser(_emailController.text, _passwordController.text, _nameController.text, "");
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
          content: Text("Vi kan desværre ikke oprette din konto da den e-mail adresse du har indtastet allerede er i brug.\n\nPrøv med en anden e-mail adresse."),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            )
          ],
        );
      }
    );
  }
}
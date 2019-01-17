import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupMain extends StatefulWidget {
  static final String routeName = "signupmain";

  @override
  _SignupMainState createState() => _SignupMainState();
}

class _SignupMainState extends State<SignupMain> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController(text: "");
  final TextEditingController _passwordController = TextEditingController(text: "");

  @override
    void dispose() {
      super.dispose();
      _emailController.dispose();
      _passwordController.dispose();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Opret bruger"),
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _emailController.text,
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
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password"
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
              FlatButton.icon(
                icon: Icon(Icons.person_add),
                label: Text("Opret"),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    FirebaseUser user = await _auth.createUserWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passwordController.text
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
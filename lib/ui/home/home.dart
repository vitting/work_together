import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  static final String routeName = "home";

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Projekter"),
      ),
      body: Container(),
    );
  }
}
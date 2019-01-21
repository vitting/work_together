import 'package:flutter/material.dart';

class SubTaskMain extends StatelessWidget {
  static final String routeName = "subtaskmain";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Del opgaver"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        child: Icon(Icons.add),
      ),
      body: Container(

      ),
    );
  }
}
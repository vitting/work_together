import 'package:flutter/material.dart';

class TaskMain extends StatelessWidget {
  static final String routeName = "taskmain";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Opgaver"),
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
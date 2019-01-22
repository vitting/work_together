import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final ValueChanged<int> onTap;
  final int index;

  const BottomNavigationBarWidget({Key key, this.onTap, this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        onTap: (int index) {
          onTap(index);
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), title: Text("Oversigt")),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.tasks), title: Text("Opgaver")),
          BottomNavigationBarItem(
              icon: Icon(Icons.comment), title: Text("Kommentar")),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.file), title: Text("Filer"))
        ],
      );
  }
}
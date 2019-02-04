import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:work_together/helpers/project_data.dart';
import 'package:work_together/ui/widgets/dialog_color_widget.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final ValueChanged<int> onTap;
  final int index;
  final ProjectData project;

  const BottomNavigationBarWidget(
      {Key key, this.onTap, this.index, this.project})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      fixedColor: DialogColorConvert.getColor(
          DialogColorConvert.getDialogColor(project.color)),
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

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:work_together/helpers/project_data.dart';
import 'package:work_together/helpers/request_data.dart';
import 'package:work_together/helpers/user_data.dart';
import 'package:work_together/ui/main/main_inheretedwidget.dart';
import 'package:work_together/ui/widgets/dialog_color_widget.dart';
import 'package:work_together/ui/widgets/dot_icon_widget.dart';
import 'package:work_together/ui/widgets/invite_row_widget.dart';
import 'package:work_together/ui/widgets/loader_progress_widet.dart';

class ProjectInviteUsers extends StatefulWidget {
  final ProjectData project;

  const ProjectInviteUsers({Key key, this.project}) : super(key: key);
  @override
  _ProjectInviteUsersState createState() => _ProjectInviteUsersState();
}

class _ProjectInviteUsersState extends State<ProjectInviteUsers> {
  Map<String, RequestData> _requestsMap;
  Color _backgroundColor;

  @override
  void initState() {
    super.initState();
    _backgroundColor = DialogColorConvert.getColorFromInt(widget.project.color);
    _getRequestData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Invitere brugere"), backgroundColor: _backgroundColor),
      body: LoaderProgress(
        color: DialogColorConvert.getColorFromInt(widget.project.color),
        showStream: MainInherited.of(context).loaderProgressStream,
        child: FutureBuilder(
          future: UserData.getAllUsers(),
          builder:
              (BuildContext context, AsyncSnapshot<List<UserData>> snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }

            return ListView(
              primary: false,
              children: <Widget>[
                DotIcon(
                  backgroundColor: _backgroundColor,
                  margin: EdgeInsets.symmetric(vertical: 5),
                  icon: FontAwesomeIcons.users,
                ),
                ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int position) {
                      UserData user = snapshot.data[position];
                      if (user.id != MainInherited.of(context).userData.id) {
                        RequestData requestData;

                        if (_requestsMap != null) {
                          requestData = _requestsMap[user.id];
                        }

                        return InviteRow(
                          project: widget.project,
                          user: user,
                          requestData: requestData,
                        );
                      } else {
                        return Container();
                      }
                    }),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _getRequestData() async {
    Map<String, RequestData> requestsMap = await RequestData.getProjectInvitesStatusForUsers(widget.project.id);

    if (mounted) {
      setState(() {
        _requestsMap = requestsMap;
      });
    }
  }
}

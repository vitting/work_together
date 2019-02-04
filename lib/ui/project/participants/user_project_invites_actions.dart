import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:work_together/helpers/project_data.dart';
import 'package:work_together/helpers/request_data.dart';
import 'package:work_together/helpers/user_data.dart';
import 'package:work_together/ui/main/main_inheretedwidget.dart';
import 'package:work_together/ui/widgets/dot_icon_widget.dart';
import 'package:work_together/ui/widgets/invited_user_row.dart';
import 'package:work_together/ui/widgets/loader_progress_widet.dart';
import 'package:work_together/ui/widgets/no_data_widget.dart';

class UserProjectInvitesActions extends StatefulWidget {
  final UserData user;

  const UserProjectInvitesActions({Key key, this.user}) : super(key: key);
  @override
  UserProjectInvitesActionsState createState() {
    return new UserProjectInvitesActionsState();
  }
}

class UserProjectInvitesActionsState extends State<UserProjectInvitesActions> {
  Map<String, RequestData> _requestsMap;
  @override
  void initState() {
    super.initState();

    _getRequestData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Projekt invitationer")),
      body: LoaderProgress(
        showStream: MainInherited.of(context).loaderProgressStream,
        child: FutureBuilder(
          future: widget.user.getProjectsWaitingForAccept(),
          builder: (BuildContext context,
              AsyncSnapshot<List<ProjectData>> snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }

            if (snapshot.hasData && snapshot.data.length == 0) {
              return Center(
                child: NoData(
                  icon: FontAwesomeIcons.projectDiagram,
                  text: "Ingen invitationer",
                ),
              );
            }

            return ListView(
              primary: false,
              children: <Widget>[
                DotIcon(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  icon: FontAwesomeIcons.projectDiagram,
                ),
                ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int position) {
                      ProjectData project = snapshot.data[position];
                      RequestData requestData;

                      if (_requestsMap != null) {
                        requestData = _requestsMap[project.id];
                      }

                      return InvitedUserRow(
                        project: project,
                        user: widget.user,
                        requestData: requestData,
                      );
                    }),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _getRequestData() async {
    Map<String, RequestData> requestsMap =
        await RequestData.getProjectInvitesForUser(widget.user.id);

    if (mounted) {
      setState(() {
        _requestsMap = requestsMap;
      });
    }
  }
}

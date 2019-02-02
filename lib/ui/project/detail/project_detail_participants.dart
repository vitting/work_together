import 'package:flutter/material.dart';
import 'package:work_together/helpers/project_data.dart';
import 'package:work_together/helpers/request_data.dart';
import 'package:work_together/helpers/user_data.dart';
import 'package:work_together/ui/main/main_inheretedwidget.dart';
import 'package:work_together/ui/widgets/loader_progress_widet.dart';
import 'package:work_together/ui/widgets/request_row_widget.dart';

enum ParticipantsStatus { add, remove, waiting, declined }

class ProjectDetailParticipants extends StatefulWidget {
  final ProjectData project;

  const ProjectDetailParticipants({Key key, this.project}) : super(key: key);
  @override
  _ProjectDetailParticipantsState createState() =>
      _ProjectDetailParticipantsState();
}

class _ProjectDetailParticipantsState extends State<ProjectDetailParticipants> {
  Map<String, RequestData> _requestsMap;
  @override
  void initState() {
    super.initState();

    _getRequestData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tilføj projekt brugere")),
      body: LoaderProgress(
        showStream: MainInherited.of(context).loaderProgressStream,
        child: FutureBuilder(
          future: UserData.getAllUsers(),
          builder:
              (BuildContext context, AsyncSnapshot<List<UserData>> snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }

            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int position) {
                  UserData user = snapshot.data[position];
                  if (user.id != MainInherited.of(context).userData.id) {
                    RequestData requestData;

                    if (_requestsMap != null) {
                      requestData = _requestsMap[user.id];
                    }

                    return RequestRow(
                      project: widget.project,
                      user: user,
                      requestData: requestData,
                    );

                  } else {
                    return Container();
                  }
                });
          },
        ),
      ),
    );
  }

  Future<void> _getRequestData() async {
    Map<String, RequestData> requestsMap =
        await RequestData.getProjectRequestStatusForUsers(widget.project.id);

    if (mounted) {
      setState(() {
        _requestsMap = requestsMap;
      });
    }
  }
}

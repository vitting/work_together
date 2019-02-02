import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:work_together/helpers/project_data.dart';
import 'package:work_together/helpers/request_data.dart';
import 'package:work_together/helpers/user_data.dart';
import 'package:work_together/ui/project/detail/project_detail_participants.dart';
import 'package:work_together/ui/widgets/round_button_icon.dart';

class RequestRow extends StatefulWidget {
  final UserData user;
  final RequestData requestData;
  final ProjectData project;

  const RequestRow({Key key, this.user, this.requestData, this.project}) : super(key: key);

  @override
  RequestRowState createState() {
    return new RequestRowState();
  }
}

class RequestRowState extends State<RequestRow> {
  RequestData _requestData;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _requestData = widget.requestData;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(widget.user.photoUrl),
          ),
          title: Text(widget.user.name),
          subtitle: Text(widget.user.uniqueName, style: TextStyle(fontSize: 12)),
          trailing: _getStatus(_getUserRequestStatus())
        ),
      ),
    );
  }

  ParticipantsStatus _getUserRequestStatus() {
    ParticipantsStatus value;
    switch (_requestData?.requestStatus) {
      case "a":
        value = ParticipantsStatus.remove;
        break;
      case "w":
        value = ParticipantsStatus.waiting;
        break;
      case "d":
        value = ParticipantsStatus.declined;
        break;
      default:
        value = ParticipantsStatus.add;
    }

    return value;
  }

  Widget _getStatus(ParticipantsStatus status) {
    Widget button;
    switch (status) {
      case ParticipantsStatus.add:
        button = RoundIconButton(
          tooltip: "Tilføj person til projekt",
          icon: Icons.person_add,
          backgroundColor: Colors.blue[700],
          loading: _loading,
          onPressed: () {
            _addParticipant();
          },
        );
        break;
      case ParticipantsStatus.remove:
        button = RoundIconButton(
          tooltip: "Fjern person fra projekt",
          icon: Icons.delete_forever,
          backgroundColor: Colors.green[800],
          onPressed: () {
            _removeParticipant();
          },
        );
        break;
      case ParticipantsStatus.waiting:
        button = RoundIconButton(
          tooltip: "Venter på bruger godkendelse",
          icon: FontAwesomeIcons.hourglass,
          disabledColor: Colors.yellow[800],
          disabled: true,
          onPressed: () {},
        );
        break;
      case ParticipantsStatus.declined:
        button = RoundIconButton(
            tooltip: "Bruger har afslået",
            icon: FontAwesomeIcons.exclamation,
            disabledColor: Colors.red[800],
            disabled: true);
        break;
    }

    return button;
  }

  void _addParticipant() async {
    RequestData requestData = RequestData(
        projectId: widget.project.id,
        requestFrom: "project",
        requestStatus: "w",
        userId: widget.user.id);

    setState(() {
     _loading = true; 
    });
    await requestData.save();
    await _getRequestData();
    setState(() {
     _loading = false; 
    });
  }

  void _removeParticipant() async {
    setState(() {
     _loading = true; 
    });
    await widget.project.removeParticipant(_requestData.userId);
    await _requestData.delete();
    await _getRequestData();
    setState(() {
     _loading = false; 
    });
  }

  Future<void> _getRequestData() async {
    RequestData requestData = await RequestData.getProjectRequestStatusForUser(widget.project.id, widget.user.id);

    if (mounted) {
      setState(() {
        _requestData = requestData;
      });
    }
  }
}

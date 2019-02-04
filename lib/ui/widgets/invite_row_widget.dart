import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:work_together/helpers/project_data.dart';
import 'package:work_together/helpers/request_data.dart';
import 'package:work_together/helpers/user_data.dart';
import 'package:work_together/ui/widgets/round_button_icon.dart';

class InviteRow extends StatefulWidget {
  final UserData user;
  final RequestData requestData;
  final ProjectData project;

  const InviteRow({Key key, this.user, this.requestData, this.project})
      : super(key: key);

  @override
  InviteRowState createState() {
    return new InviteRowState();
  }
}

class InviteRowState extends State<InviteRow> {
  RequestData _requestData;
  bool _loading = false;
  String _tooltip = "";
  IconData _icon = Icons.add;
  Color _backgroundColor;
  Color _disabledColor;
  bool _disabled;

  @override
  void initState() {
    super.initState();
    _requestData = widget.requestData;
    _setButtonProperties(RequestConvert.requestStatusToParticipantsStatus(
        _requestData?.requestStatus));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        color: Colors.grey[50],
        child: ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(widget.user.photoUrl),
            ),
            title: Text(widget.user.name),
            subtitle:
                Text(widget.user.uniqueName, style: TextStyle(fontSize: 12)),
            trailing: RoundIconButton(
              tooltip: _tooltip,
              icon: _icon,
              backgroundColor: _backgroundColor,
              loading: _loading,
              disabled: _disabled,
              disabledColor: _disabledColor,
              onPressed: () {
                _buttonAction(RequestConvert.requestStatusToParticipantsStatus(
                    _requestData?.requestStatus));
              },
            )),
      ),
    );
  }

  void _setButtonProperties(ParticipantsStatus status) {
    switch (status) {
      case ParticipantsStatus.add:
        _tooltip = "Tilføj person til projekt";
        _icon = Icons.person_add;
        _backgroundColor = Colors.blue[700];
        _disabled = false;
        break;
      case ParticipantsStatus.remove:
        _tooltip = "Fjern person fra projekt";
        _icon = Icons.delete_forever;
        _backgroundColor = Colors.green[800];
        _disabled = false;
        break;
      case ParticipantsStatus.waiting:
        _tooltip = "Venter på bruger godkendelse";
        _icon = FontAwesomeIcons.hourglass;
        _backgroundColor = Colors.yellow[800];
        // _disabledColor = Colors.yellow[800];
        _disabled = false;
        break;
      case ParticipantsStatus.declined:
        _tooltip = "Bruger har afslået";
        _icon = FontAwesomeIcons.exclamation;
        _backgroundColor = Colors.red[800];
        _disabled = false;
        break;
    }
  }

  void _buttonAction(ParticipantsStatus status) async {
    switch (status) {
      case ParticipantsStatus.add:
        _addParticipant();
        break;
      case ParticipantsStatus.remove:
        _removeParticipant();
        break;
      case ParticipantsStatus.waiting:
        Scaffold.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.yellow[800],
          content:
              Text("Afventer accept fra brugeren", textAlign: TextAlign.center),
        ));
        break;
      case ParticipantsStatus.declined:
        Scaffold.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red[800],
          content: Text("Brugeren har afslået invitationen",
              textAlign: TextAlign.center),
        ));
        break;
    }
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
    await widget.project.addWaitingParticipant(widget.user.id);
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
    RequestData requestData = await RequestData.getProjectInviteStatusForUser(
        widget.project.id, widget.user.id);

    if (mounted) {
      setState(() {
        _requestData = requestData;
        _setButtonProperties(RequestConvert.requestStatusToParticipantsStatus(
            _requestData?.requestStatus));
      });
    }
  }
}

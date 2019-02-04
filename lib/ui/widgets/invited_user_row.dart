import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:work_together/helpers/config.dart';
import 'package:work_together/helpers/project_data.dart';
import 'package:work_together/helpers/request_data.dart';
import 'package:work_together/helpers/user_data.dart';
import 'package:work_together/ui/widgets/round_button_icon.dart';
import 'package:work_together/ui/widgets/text_expand_widget.dart';

enum ChoiceMenuAction { accept, decline }

class InvitedUserRow extends StatefulWidget {
  final UserData user;
  final RequestData requestData;
  final ProjectData project;

  const InvitedUserRow({Key key, this.user, this.requestData, this.project})
      : super(key: key);

  @override
  InvitedUserRowState createState() {
    return new InvitedUserRowState();
  }
}

class InvitedUserRowState extends State<InvitedUserRow> {
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
            title: Text(widget.project.title),
            subtitle: TextExpand(
              text: widget.project.description,
            ),
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
      case ParticipantsStatus.remove:
        _tooltip = "Fjern person fra projekt";
        _icon = Icons.check;
        _backgroundColor = Colors.green[800];
        _disabled = false;
        break;
      case ParticipantsStatus.waiting:
        _tooltip = "Venter på godkendelse";
        _icon = FontAwesomeIcons.question;
        _backgroundColor = Colors.yellow[800];
        _disabled = false;
        break;
      case ParticipantsStatus.declined:
        _tooltip = "Du har afslået";
        _icon = FontAwesomeIcons.exclamation;
        _backgroundColor = Colors.red[800];
        _disabled = false;
        break;
      default:
    }
  }

  void _buttonAction(ParticipantsStatus status) async {
    switch (status) {
      case ParticipantsStatus.remove:
        Scaffold.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green[800],
          content:
              Text("Du er medlem af projektet", textAlign: TextAlign.center),
        ));
        break;
      case ParticipantsStatus.waiting:
        _showChoiceMenu();
        break;
      case ParticipantsStatus.declined:
        Scaffold.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red[800],
          content: Text("Du har afslået har afslået invitationen",
              textAlign: TextAlign.center),
        ));
        break;
      default:
    }
  }

  void _showChoiceMenu() async {
    ChoiceMenuAction result = await showModalBottomSheet<ChoiceMenuAction>(
        context: context,
        builder: (BuildContext modalContext) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Card(
                color: Config.bottomSheetBackgroundColor,
                child: ListTile(
                  leading: Icon(Icons.check_circle,
                      color: Config.bottomSheetTextColor),
                  title: Text("Godkend projekt",
                      style: TextStyle(color: Config.bottomSheetTextColor)),
                  onTap: () {
                    Navigator.of(context).pop(ChoiceMenuAction.accept);
                  },
                ),
              ),
              Card(
                color: Config.bottomSheetBackgroundColor,
                child: ListTile(
                  leading: Icon(Icons.remove_circle,
                      color: Config.bottomSheetTextColor),
                  title: Text("Afslå projekt",
                      style: TextStyle(color: Config.bottomSheetTextColor)),
                  onTap: () {
                    Navigator.of(context).pop(ChoiceMenuAction.decline);
                  },
                ),
              )
            ],
          );
        });

    if (result != null) {
      setState(() {
        _loading = true;
      });
      await widget.project.removeWaitingParticipant(widget.user.id);
      if (result == ChoiceMenuAction.accept) {
        await widget.project.addParticipant(widget.user.id);
        await widget.requestData.updateStatus("a");
      } else {
        await widget.requestData.updateStatus("d");
      }

      await _getRequestData();
      setState(() {
        _loading = false;
      });
    }
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

import 'package:flutter/material.dart';

class LoaderProgress extends StatefulWidget {
  final Stream<bool> showStream;
  final Widget child;

  const LoaderProgress({Key key, this.showStream, this.child}) : super(key: key);
  @override
  LoaderProgressState createState() {
    return new LoaderProgressState();
  }
}

class LoaderProgressState extends State<LoaderProgress> {
  bool _show = false;
  @override
  void initState() {
    super.initState();
    if (widget.showStream != null) {
      widget.showStream.listen((bool data) {
        if (mounted) {
          setState(() {
            _show = data;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [widget.child];
    if (_show) {
      widgets.addAll([_showBarrier(), _showProgressBox()]);
    }

    return Stack(
      children: widgets,
    );
  }

  Widget _showProgressBox() {
    return Positioned(
      child: Center(
        child: Container(
          width: 100,
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                ],
              )
            ],
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(width: 8, color: Colors.blue[700])),
        ),
      ),
    );
  }

  Widget _showBarrier() {
    return Positioned(
      child: ModalBarrier(
        dismissible: false,
        color: Colors.black26,
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hippie/widgets/nav_list.dart';

class LeftDrawerWidget extends StatefulWidget {
  final List verify;
  final bool private;
  final List players;
  final bool creator;

  const LeftDrawerWidget({Key key, this.verify, this.players, this.private, this.creator}) : super(key: key);
  @override
  _LeftDrawerWidgetState createState() => _LeftDrawerWidgetState();
}

class _LeftDrawerWidgetState extends State<LeftDrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          AppBar( title: Text('Navigation'),),
          new MenuListTileWidget(verficiations: widget.verify,
          players: widget.players,
            private: widget.private,
            creator: widget.creator,
          ),
        ],
      ),
    );
  }
}

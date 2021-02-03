import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hippie/widgets/nav_list.dart';

class LeftDrawerWidget extends StatefulWidget {
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
          AppBar( title:           Text('Navigation'),),
          new MenuListTileWidget(),
        ],
      ),
    );
  }
}

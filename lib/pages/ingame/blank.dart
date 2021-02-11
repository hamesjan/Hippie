import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../widgets/left_drawer.dart';

class Blank extends StatefulWidget {
  @override
  _BlankState createState() => _BlankState();
}

class _BlankState extends State<Blank> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: LeftDrawerWidget(),
      appBar: AppBar(),
      body: Container(),
    );
  }
}

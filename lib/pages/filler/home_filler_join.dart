import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class JoinAGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text('Join A Tournament first.\nUse the button at the bottom to join a tournament.',
      textAlign: TextAlign.center, style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25
        ),)),
    );
  }
}

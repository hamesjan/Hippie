import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LeaveTourney extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Are you sure you want to leave this tournament?', style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),),
            RaisedButton(
              child: Text('Leave'),
              onPressed: (){

              },
            )
          ],
        ),
      ),
    );
  }
}

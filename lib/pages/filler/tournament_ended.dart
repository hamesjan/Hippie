import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hippie/pages/home.dart';
import 'package:hippie/pages/pregame/join_or_create.dart';

class TournamentEnded extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.login),
          onPressed: (){
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(
                    builder: (BuildContext context) => JoinOrCreate()
                ));
          },
        ),
      ),
      body: Center(
        child: Text('This tournament has ended.',
          textAlign: TextAlign.center,
          style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 32,

        ),),
      ),
    );
  }
}

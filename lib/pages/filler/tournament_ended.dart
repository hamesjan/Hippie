import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hippie/pages/home.dart';
import 'package:hippie/pages/ingame/player_results.dart';
import 'package:hippie/pages/pregame/join_or_create.dart';
import 'package:expandable/expandable.dart';
import 'package:hippie/widgets/player_results_sport_record_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TournamentEnded extends StatelessWidget {
  final List players;

  const TournamentEnded({Key key, this.players}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.login),
          onPressed: ()async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setBool('inGame', false);
            prefs.setString('uuid', 'none');
            prefs.setString('name', '1023417');
            prefs.remove('name');
            prefs.remove('number');
            prefs.setBool('creator', false);
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.push(context,
                MaterialPageRoute(
                    builder: (BuildContext context) => JoinOrCreate()
                ));
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100,),
            Text('This tournament has ended.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),),
            TextButton(
              child: Container(
                padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  child: Text('See Results', style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 35
                  ),)),
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PlayerResults(
                          players: players,
                        )
                    )
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

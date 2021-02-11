import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PlayerResultsSportWidget extends StatelessWidget {
  final bool played;
  final bool verified;
  final String score;
  final String winner;

  const PlayerResultsSportWidget({Key key, this.played, this.verified, this.score, this.winner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if( played) {
      return Container(
        padding: EdgeInsets.only(bottom:  10),
        child: Row(
          children: [
            verified ?
            Icon(
              Icons.check,
              color: Colors.green,
              size: 20,
            ) : Icon(Icons.refresh, color: Colors.orange, size: 20,),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Score: $score'),
                Text('Winner: $winner'),
                verified ? Container(): Text('Waiting for Verification', style: TextStyle(
                    color: Colors.orange
                ),)
              ],)

          ],
        ),
      );
    } else {
      return (Container(
        padding: EdgeInsets.only(bottom:  10),
        child: Row(
          children: [
            Icon(Icons.close, color: Colors.red,
              size: 20,),
            Text('You need to play this sport.')
          ],
        ),
      ));
    }
  }
}

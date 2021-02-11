import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hippie/pages/ingame/blank.dart';
import 'package:expandable/expandable.dart';
import 'package:hippie/pages/ingame/versus_page.dart';

class PlayersListWidget extends StatelessWidget {
  final String name;
  final String number;
  final Map playerData;
  const PlayersListWidget({Key key, this.name, this.number, this.playerData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        List<GameHistoryStructure> tempPlayerData =
            playerData.entries.map( (entry) => GameHistoryStructure(entry.key, entry.value)).toList();
        List tempSports = [];
        tempPlayerData.forEach((element) {
          if(element.sport != 'number'){
            tempSports.add(element.sport);
          }
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => VersusPage(
                  name: name,
                  history: tempPlayerData,
                  sports: tempSports,
                )));
      },
      child: new Ink(
          child:  Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: MediaQuery.of(context).size.width,),
                Row(children: [
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    child:
                    Text('$name', style: TextStyle(fontSize: 20, color: Colors.blue), ),
                  ),
                  Expanded(child: Container(),),
                  Container(
                    padding: EdgeInsets.only(right: 10),
                    child:
                    Text(number, style: TextStyle(fontSize: 15),),)

                ],),
                Divider(thickness: 2,),

              ],
            ),
          )
      )
    );
  }
}

class GameHistoryStructure {
  final String sport;
  final dynamic history;
  GameHistoryStructure(this.sport, this.history);
}
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hippie/widgets/player_results_sport_record_widget.dart';
import 'package:hippie/widgets/sport_record_widget.dart';
import 'package:hippie/widgets/players_list_widget.dart';

class PlayerResults extends StatelessWidget {
  final List players;

  const PlayerResults({Key key, this.players}) : super(key: key);

  Future<List<Widget>> getList (Map oldList)async{
    List newList = oldList.entries.map((entry) => GameHistoryStructure(entry.key, entry.value)).toList();
    List<Widget> renderPlz = [];
    newList.forEach((element) {
      renderPlz.add(
      element.sport != 'number' ?
      new ExpandablePanel(
        hasIcon: false,
        header: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(element.sport, style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                ),),
                Divider(thickness: 2,)
              ],
            )
        ),
        expanded: Column(
          children: [
            PlayerResultsSportWidget(
              played: element.history['played'],
              verified: element.history['verified'],
              myScore: element.history['myScore'],
              oppScore: element.history['oppScore'],
              winner: element.history['winner'],
            ),
          ],
        ),
      ) : new Container());
    });
    return renderPlz;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Current Standings'),
      ),
      body:ListView.builder
        (
          itemCount: players.length,
          itemBuilder: (BuildContext context, int index) {
            List tempList = players[index]['versus'].entries.map( (entry) => PlayerDataStructure(entry.key, entry.value)).toList();
            return
              new ExpandablePanel(
                header:Container(
                  padding: EdgeInsets.all(16),
                  child: Row(children: [
                    Text("${players[index]['name']}", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontSize: 25,
                    ),),
                    Expanded(child: Container(),),
                    Text("${players[index]['overallScore']}", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),),
                  ],)

                ),
                expanded: Column(children: tempList.map((item) =>
                new ExpandablePanel(
                  hasIcon: false,
                  header: Container(child: Text("vs. ${item.against}", style: TextStyle(
                    color: Colors.red,
                    fontSize: 25
                  ),),
                  padding: EdgeInsets.only(left: 32)
                  ),
                  expanded: Container(padding: EdgeInsets.only(left: 48),
                  child: FutureBuilder(
                    future: getList(item.sports),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.hasData){
                        return Column(
                          children: snapshot.data,
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  )
                )
                )
                ).toList()),
              );
          }
      )
    );
  }
}

class PlayerDataStructure {
  final String against;
  final Map sports;

  PlayerDataStructure(this.against, this.sports,);
}


class GameHistoryStructure {
  final String sport;
  final dynamic history;
  GameHistoryStructure(this.sport, this.history);
}

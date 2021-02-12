import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hippie/pages/home.dart';
import 'package:hippie/pages/pregame/join_or_create.dart';
import 'package:hippie/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';


class CreatorProfile extends StatefulWidget {
  final String name;
  final String number;
  final bool started;
  final bool creator;
  final int overallScore;
  final String code;
  final List players ;
  final List opponents ;

  const CreatorProfile({Key key, this.name, this.number, this.creator, this.started, this.players, this.overallScore, this.opponents, this.code}) : super(key: key);

  @override
  _CreatorProfileState createState() => _CreatorProfileState();
}

class _CreatorProfileState extends State<CreatorProfile> {
  final snackBar = SnackBar(content: Text('Code Copied to Clipboard'));

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue, Colors.white10]),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.blue,
                  size: 125,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        widget.name,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.number,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text('Creator', style: TextStyle(
                      fontSize: 15,
                      color: Colors.red
                    ),)
                  ],
                )
              ],
            ),
          ),
          Divider(thickness: 2,),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Text('Overall Score', style: TextStyle(
                  fontSize: 20,
                ),),
                Text(widget.overallScore.toString(), style: TextStyle(
                    fontSize: 40,
                    color: Colors.blue
                ))
              ],
            ),
          ),
          Divider(thickness: 2,),
          Text('Tourney Code', style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold
          ),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.code.substring(2, 7), style: TextStyle(
                fontSize: 32,
              )),
              IconButton(
                  icon: Icon(Icons.copy),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: widget.code.substring(2, 7)))
                        .then((value) { //only if ->
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    );
                  }
              )
            ],
          ),
          Divider(thickness: 2,),

          Container(
            child: Text('Players', style: TextStyle(fontSize: 20, color: Colors.blue,)
          ),
          ),
          SizedBox(height: 10,),
          Row(children: [
            Container(
              padding: EdgeInsets.only(left: 10),
              child:
              Text('Name', style: TextStyle(fontSize: 20), ),
            ),
            Expanded(child: Container(),),
            Container(
              padding: EdgeInsets.only(right: 10),
              child:
              Text('Phone Number', style: TextStyle(fontSize: 20),),
            ),
            Expanded(child: Container(),),
            Container(
              padding: EdgeInsets.only(right: 10),
              child:
              Text('Overall Score', style: TextStyle(fontSize: 20),),)

          ],),
          Divider(thickness: 2,),
         widget.players.length == 1 ? Text('Invite more people.') :
          // Column(children: widget.opponents.map((item) =>
         //  new PlayersListWidget(
         //    name: item.against,
         //    number: item.sports['number'],
         //    playerData: item.sports,
         //  )).toList()),
         Column(children: widget.players.map((item) => new Container(
           padding: EdgeInsets.all(16),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Container(width: MediaQuery.of(context).size.width,),

               Row(children: [
                 Container(
                   padding: EdgeInsets.only(left: 10),
                   child:
                   Text(item['name'], style: TextStyle(fontSize: 20, color: Colors.blue), ),
                 ),
                 Expanded(child: Container(),),
                 Container(
                   padding: EdgeInsets.only(right: 10),
                   child:
                   Text(item['number'], style: TextStyle(fontSize: 15),),
                 ),
                 Expanded(child: Container(),),
                 Container(
                   padding: EdgeInsets.only(right: 10),
                   child:
                   Text(item['overallScore'].toString(), style: TextStyle(fontSize: 15),),)

               ],),
             ],
           ),
         )).toList()),
          SizedBox(height: 10,),
          !widget.started  ? CustomButton(
            text: 'Start Tournament',
            callback: () async{
              showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Are you sure you want to start the tournament?', textAlign: TextAlign.center,),
                      actions: <Widget>[
                        ElevatedButton(
                          child: Text('Let the games begin!', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),),
                          onPressed: ()async {
                            Firestore _firestore = Firestore.instance;
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            String uuid = prefs.getString('uuid');
                            List newPlayerData = [];
                            var tData = await _firestore.collection('tourneys').document(uuid).get();
                            List sports = tData.data['sports'];


                            tData.data['players'].forEach((ele) {
                              Map tempPlayers = {};
                              tData.data['players'].forEach((el) {
                                if( el['name'] == ele['name']){
                                }else {
                                  Map tempSports = {};
                                  sports.add('number');
                                  sports.forEach((element) {
                                    if (element == 'number') {
                                      tempSports[element] = el['number'];
                                    }else {
                                      tempSports[element] = {
                                        'played': false,
                                        'recorded': '',
                                        'verified': false,
                                        'myScore': 0,
                                        'oppScore': 0,
                                        'winner': '',
                                      };
                                    }
                                  });

                                  tempPlayers[el['name']] = tempSports;
                                }
                              });
                              newPlayerData.add({
                                'name': ele['name'],
                                'number': ele['number'],
                                'verify' : [],
                                'overallScore': 0,
                                'versus': tempPlayers
                              });
                            }
                            );
                            await _firestore.collection('tourneys').document(uuid).updateData({
                              'started': true,
                              'players': newPlayerData
                            });
                            Navigator.of(context).popUntil((route) => route.isFirst);
                            Navigator.of(context).pop();
                            Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => Home()
                                ));
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  });
            },
          ) : Container(),
          SizedBox(height: 10,),
          widget.started  ? CustomButton(
            text: 'End Tournament',
            callback: () async{
              showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Are you sure you want to end the tournament?', textAlign: TextAlign.center,),
                      content: Text('This action can not be undone.', textAlign: TextAlign.center, style: TextStyle(
                          color: Colors.red
                      ),),
                      actions: <Widget>[
                        ElevatedButton(
                          child: Text('End', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),),
                          onPressed: ()async {
                            Firestore _firestore = Firestore.instance;
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            String uuid = prefs.getString('uuid');
                            await _firestore.collection('tourneys').document(uuid).updateData({
                              'ended': true
                            });
                            Navigator.of(context).popUntil((route) => route.isFirst);
                            Navigator.of(context).pop();
                            Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => Home()
                                ));
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  });
            },
          ) : Container(),
        ],
      ),
    );
  }
}

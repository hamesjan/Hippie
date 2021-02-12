import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hippie/pages/creator_profile.dart';
import 'package:hippie/pages/filler/tournament_ended.dart';
import 'package:hippie/pages/ingame/blank.dart';
import 'package:hippie/pages/ingame/player_results.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hippie/pages/ingame/message_board.dart';
import 'package:hippie/pages/pregame/join_or_create.dart';
import 'package:hippie/pages/ingame/record_match.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hippie/widgets/left_drawer.dart';

import 'profile.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController _tabController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  Future getInformation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('name');
    String number = prefs.getString('number');
    String uuid = prefs.getString('uuid');
    bool creator = prefs.getBool('creator');
    var tourneyInfo = await _firestore.collection('tourneys').document(uuid).get();

    if (tourneyInfo.data['ended']) {
      prefs.setBool('inGame', false);
      prefs.remove('uuid');
      prefs.remove('name');
      prefs.remove('name');
      prefs.remove('number');
      prefs.setBool('creator', false);
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.of(context).pop();
      Navigator.push(context,
          MaterialPageRoute(
              builder: (BuildContext context) => TournamentEnded(players: tourneyInfo.data['players'],)
          ));
    }

    List info = [];
    Map opponents = {};
    int score;
    List verifications = [];
    tourneyInfo.data['players'].forEach((ele) => {
      if(ele['name'] == name){
      opponents = ele['versus'],
        score = ele['overallScore'],
        verifications = ele['verify'],
      }
    });

    info.add(tourneyInfo);
    info.add(name);
    info.add(number);
    info.add(creator);
    info.add(opponents);
    info.add(uuid);
    info.add(score);
    info.add(verifications);

    return info;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getInformation(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text(
                'podiplay',
                style: TextStyle(fontSize: 22),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: ()async{
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.pop(context);
                    Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) => Home()
                    ));
                  },
                ),

                // IconButton(
                //   icon: Icon(Icons.login),
                //   onPressed: ()async{
                //     Navigator.of(context).popUntil((route) => route.isFirst);
                //     Navigator.pop(context);
                //     Navigator.push(context,
                //         MaterialPageRoute(builder: (BuildContext context) => JoinOrCreate()
                //         ));
                //   },
                // ),
                // IconButton(
                //   icon: Icon(Icons.admin_panel_settings),
                //   onPressed: ()async{
                //     SharedPreferences prefs = await SharedPreferences
                //         .getInstance();
                //     prefs.setString('name', 'Tom');
                //     prefs.setString('number', '1');
                //     prefs.setBool('creator', true);
                //   },
                // ),
                // IconButton(
                //   icon: Icon(Icons.person),
                //   onPressed: ()async{
                //     SharedPreferences prefs = await SharedPreferences
                //         .getInstance();
                //     prefs.setString('name', 'Joe');
                //     prefs.setString('number', '2');
                //     prefs.setBool('creator', false);
                //   },
                // )
              ],
            ),
            body: SafeArea(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  MessageBoard(
                    name: snapshot.data[1],
                    uuid: snapshot.data[5],
                  ),
                  snapshot.data[3] ? CreatorProfile(
                    name: snapshot.data[1],
                    number: snapshot.data[2],
                    players: snapshot.data[0].data['players'],
                    started: snapshot.data[0].data['started'],
                    code: snapshot.data[5],
                    overallScore: snapshot.data[6],
                  ):
                  Profile(
                    private: snapshot.data[0].data['score_visibility'],
                    name: snapshot.data[1],
                    number: snapshot.data[2],
                    players: snapshot.data[0].data['players'],
                    started: snapshot.data[0].data['started'],
                    code: snapshot.data[5],
                    overallScore: snapshot.data[6],
                  ),
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              onPressed: ()  async{
                snapshot.data[0].data['started'] ?
                  Navigator.push(context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => RecordMatch(
                      opponents: snapshot.data[4].entries.map( (entry) => PlayerDataStructure(entry.key, entry.value)).toList(),
                    )
                  )) : showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Tournament has not been started yet.', textAlign: TextAlign.center,),
                        actions: <Widget>[
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
              child: Icon(Icons.add),
              backgroundColor: Colors.blue,
            ),
            drawer: LeftDrawerWidget(
              verify: snapshot.data[7],
              private: snapshot.data[0].data['score_visibility'],
              players: snapshot.data[0].data['players'],
              creator: snapshot.data[3]
            ),
            bottomNavigationBar: SafeArea(
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.black12,
                unselectedLabelColor: Colors.black38,
                tabs: <Widget>[
                  Tab(
                    icon: Icon(
                      Icons.home,
                      color: Colors.black,
                    ),
                  ),
                  Tab(
                      icon: Icon(
                    Icons.person,
                    color: Colors.black,
                  ))
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}

class PlayerDataStructure {
  final String against;
  final Map sports;

  PlayerDataStructure(this.against, this.sports,);
}
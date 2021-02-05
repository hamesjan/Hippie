import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hippie/pages/filler/tournament_ended.dart';
import 'package:hippie/pages/ingame/main_bracket.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    List info = [];
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
        builder: (BuildContext context) => TournamentEnded()
      ));
    }
    info.add(tourneyInfo);
    info.add(name);
    info.add(number);
    info.add(creator);
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
                    Navigator.pop(context);
                    Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) => Home()
                    ));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.admin_panel_settings),
                  onPressed: ()async{
                    SharedPreferences prefs = await SharedPreferences
                        .getInstance();
                    prefs.setString('name', 'Tom');
                    prefs.setString('number', '1234562134');
                    prefs.setBool('creator', true);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.person),
                  onPressed: ()async{
                    SharedPreferences prefs = await SharedPreferences
                        .getInstance();
                    prefs.setString('name', 'Bob');
                    prefs.setString('number', '1234123');
                    prefs.setBool('creator', false);
                  },
                )
              ],
            ),
            body: SafeArea(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  MainBracket(),
                  Profile(
                    name: snapshot.data[1],
                    number: snapshot.data[2],
                    creator: snapshot.data[3],
                    started: snapshot.data[0].data['started'],
                  ),
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              onPressed: ()  async{
                // SharedPreferences prefs = await SharedPreferences.getInstance();
                // prefs.setBool('creator', true);
                //   // Navigator.push(context,
                  // MaterialPageRoute(
                  //   builder: (BuildContext context) => RecordMatch()
                  // ));
                },
              child: Icon(Icons.add),
              backgroundColor: Colors.blue,
            ),
            drawer: LeftDrawerWidget(),
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
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

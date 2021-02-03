import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hippie/pages/ingame/main_bracket.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hippie/pages/pregame/join_or_create.dart';
import 'package:hippie/pages/ingame/record_match.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hippie/widgets/left_drawer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController _tabController;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
    bool inGame = prefs.getBool('inGame') == null ? false : prefs.getBool('inGame');
    print(prefs.getString('uuid'));
    info.add(inGame);
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
              title: Text(
                'podiplay',
                style: TextStyle(fontSize: 22),
              ),
              actions: <Widget>[

              ],
            ),
            body: SafeArea(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  MainBracket(),
                  MainBracket(),
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                  Navigator.push(context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => RecordMatch()
                  ));
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

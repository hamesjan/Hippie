import 'package:flutter/material.dart';
import 'package:hippie/pages/filler/error_occ.dart';
import 'package:hippie/pages/filler/loading.dart';
import 'package:hippie/pages/home.dart';
import 'package:hippie/pages/pregame/join_or_create.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  Future getInformation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool inGame = prefs.getBool('inGame') == null ? false : prefs.getBool('inGame');
    return inGame;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: getInformation(),
        builder: (context, snapshot){
          if (snapshot.hasData) {
         return snapshot.data ?  Home() : JoinOrCreate();
          }
          if (snapshot.connectionState == ConnectionState.waiting){
            return Loading();
          }else {
            return ErrorOccurred();
          }
        },
      )
    );
  }
}


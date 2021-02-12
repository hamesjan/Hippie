import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hippie/pages/pregame/create_game.dart';
import 'package:hippie/pages/pregame/join_game.dart';
import 'package:hippie/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hippie/pages/home.dart';

class JoinOrCreate extends StatefulWidget {
  @override
  _JoinOrCreateState createState() => _JoinOrCreateState();
}

class _JoinOrCreateState extends State<JoinOrCreate> {
  String code;
  String _errorMessage;
  bool _validate = false;
  final _joinFormKey = GlobalKey<FormState>();
  final Firestore _firestore = Firestore.instance;



  String validateCode(String value) {
    if (value == null || value.isEmpty) {
      return "Missing Code";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        actions: [
          // IconButton(
          //   icon: Icon(Icons.admin_panel_settings),
          //   onPressed: ()async{
          //     SharedPreferences prefs = await SharedPreferences
          //         .getInstance();
          //     prefs.setBool('inGame', true);
          //     prefs.setString('uuid', '[#6715f]');
          //     prefs.setString('name', 'Joe');
          //     prefs.setString('number', '2');
          //     prefs.setBool('creator', false);
          //     Navigator.of(context).popUntil((route) => route.isFirst);
          //     Navigator.of(context).pop();
          //     Navigator.push(context,
          //         MaterialPageRoute(
          //             builder: (BuildContext context) => Home()
          //         ));
          //   },
          // )
        ],
      title: Text('Join Tournament'),
        leading: Container(),
      ),
      body: Form(
      key: _joinFormKey,
      child:
          Container(
            padding: EdgeInsets.all(16),
            child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
              TextFormField(
                  autocorrect: false,
                  validator: (value) => validateCode(value),
                  onChanged: (value) => code = value,
                  toolbarOptions: ToolbarOptions(
                    copy: true,
                    paste: true,
                    selectAll: true,
                    cut: true,
                  ),
                  decoration: InputDecoration(
                      icon: Icon(Icons.vpn_key),
                      errorText: _validate ? 'Invalid Code' : null,
                      hintText: '5 Digit Tournament Code',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3))))),
          SizedBox(height: 10,),
          CustomButton(
            text: 'Join Tournament',
            callback: ()async {
              bool tourneyExists = false;
              bool started = false;
              var currGames = await _firestore.collection('tourneys').getDocuments();
              currGames.documents.forEach((element) {
                String temp = element.data['uuid'].toString();
                if (code == temp.substring(2, 7)){
                  tourneyExists = true;
                  if (element.data['started']) {
                    started = true;
                  }
                }
              });

              if (_joinFormKey.currentState.validate() && tourneyExists && !started) {
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => JoinGame(
                          code: code,
                        )
                    ));
              } else if (started){
                showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('This tournament has already started.', textAlign: TextAlign.center,),
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
              }
              else {
                setState(() {
                  _validate = true;
                });
              }
            },
          ),
          SizedBox(height: 10,),
          CustomButton(
            text: 'Create a new tournament',
            callback: (){
              print('create');
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => CreateGame()
                  ));
            },
          )
        ],
      ),
          )

    )
    );
  }
}

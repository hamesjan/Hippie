import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hippie/pages/pregame/create_game.dart';
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
              var currGames = await _firestore.collection('tourneys').getDocuments();
              currGames.documents.forEach((element) {
                String temp = element.data['uuid'].toString();
                if (code == temp.substring(2, 7)){
                  tourneyExists = true;
                }
              });

              if (_joinFormKey.currentState.validate() && tourneyExists) {
                print('join');
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool('inGame', true);
                prefs.setString('uuid', '[#$code]');
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Home()
                    ));
              } else {
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

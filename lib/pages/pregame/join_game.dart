import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hippie/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:hippie/pages/home.dart';

class JoinGame extends StatefulWidget {
  final String code;

  const JoinGame({Key key, this.code}) : super(key: key);

  @override
  _JoinGameState createState() => _JoinGameState();
}

class _JoinGameState extends State<JoinGame> {
  final Firestore _firestore = Firestore.instance;
  final _createGameKey = GlobalKey<FormState>();

  String name;
  String yourName;
  String phonenumber;
  String errorMessage;



  String validateYourName(String value) {
    if (value == null || value.isEmpty) {
      return "Missing Name";
    }
    return null;
  }

  String validateNum(String value) {
    if (value == null || value.isEmpty) {
      return "Missing Number";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join Tournament'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _createGameKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                  onChanged: (value) => yourName = value,
                  autocorrect: false,
                  toolbarOptions: ToolbarOptions(
                    copy: true,
                    paste: true,
                    selectAll: true,
                    cut: true,
                  ),
                  maxLines: null,
                  validator: (value) => validateYourName(value),
                  decoration: InputDecoration(
                      hintText: "Bob",
                      labelText: 'Your Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3))
                      )
                  )
              ),
              SizedBox(height: 10,),

              TextFormField(
                  onChanged: (value) => phonenumber = value,
                  autocorrect: false,
                  maxLines: null,
                  toolbarOptions: ToolbarOptions(
                    copy: true,
                    paste: true,
                    selectAll: true,
                    cut: true,
                  ),
                  validator: (value) => validateNum(value),
                  decoration: InputDecoration(
                      hintText: "###-###-####",
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3))
                      )
                  )
              ),
              SizedBox(
                height: 15,
              ),
              errorMessage == null ? Container() : Text(errorMessage, style: TextStyle(
                  color: Colors.red
              ),),
              SizedBox(height: 10,),
              CustomButton(
                text: 'Join',
                callback: () async{
                  if (_createGameKey.currentState.validate()) {
                    try {
                      SharedPreferences prefs = await SharedPreferences
                          .getInstance();
                      prefs.setString('name', yourName);
                      prefs.setString('number', phonenumber);
                      prefs.setBool('inGame', true);
                      prefs.setString('uuid', '[#${widget.code}]');
                      prefs.setBool('creator', false);
                      Firestore _firestore = Firestore.instance;
                      var tourneyInfo = await _firestore.collection('tourneys').document('[#${widget.code}]').get();
                      List newPlayers = tourneyInfo.data['players'];
                      newPlayers.add({
                        'name': yourName,
                        'number': phonenumber,
                        'overallScore': 0,
                        'verify' : [],
                        'versus': {},
                      });
                      await _firestore.collection('tourneys').document('[#${widget.code}]').updateData({
                        'players': newPlayers
                      });
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Home()
                          ));
                    } catch (e){
                      print(e.toString());
                    }
                  }
                },

              ),

            ],
          ),
        ),
      ),
    );
  }
}

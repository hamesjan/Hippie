import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hippie/pages/pregame/join_or_create.dart';
import 'package:hippie/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatefulWidget {
  final String name;
  final String number;
  final bool started;
  final bool creator;

  const Profile({Key key, this.name, this.number, this.creator, this.started}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
                  ],
                )
              ],
            ),
          ),
          !widget.started ? widget.creator ? CustomButton(
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

                              Map tempSports = {};
                                sports.forEach((element) {
                                  // Just for Ping Pong
                                  List thirdLayer = [];
                                  tData.data['players'].forEach((el) {
                                    print(el['name']);
                                    print(prefs.getString('name'));
                                    if( el['name'] == ele['name']){
                                    } else {
                                      thirdLayer.add(
                                          {
                                            'versus': el['name'],
                                            'played': false,
                                            'verified': false,
                                            'score': ''
                                          }
                                      );
                                    }
                                  });
                                 tempSports[element]= thirdLayer;
                                });

                                newPlayerData.add({
                                  'name': ele['name'],
                                  'number': ele['number'],
                                  'sports': tempSports
                                });
                              }

                            );
                            await _firestore.collection('tourneys').document(uuid).updateData({
                              'started': true,
                              'players': newPlayerData
                            });
                            Navigator.pop(context);
                            setState(() {});
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
          ) : Text('Waiting for Tournament to Start...', textAlign: TextAlign.center, style: TextStyle(
            fontSize: 24
          ),) : Container(),
          SizedBox(height: 10,),
          widget.creator ? CustomButton(
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
                                    builder: (BuildContext context) => JoinOrCreate()
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

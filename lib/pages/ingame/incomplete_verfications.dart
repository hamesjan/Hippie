import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LinkRequests extends StatefulWidget {
  final List linkRequests;

  const LinkRequests({Key key, this.linkRequests}) : super(key: key);
  @override
  _LinkRequestsState createState() => _LinkRequestsState();
}

class _LinkRequestsState extends State<LinkRequests> {
  final Firestore _firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verification Requests'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Text('Confirm the accuracy of these results.'),
          ),
          Divider(thickness: 2,),
          widget.linkRequests.length == null || widget.linkRequests.length == 0 ?
          Container(
              padding: EdgeInsets.all(16),
              child: Text('You have no requests.')
          ) :
          ListView.builder(
              shrinkWrap: true,
              itemCount: widget.linkRequests.length,
              itemBuilder: (BuildContext context, int index) {
                final item = widget.linkRequests[index];
                return Dismissible(
                  key: Key(item['against'] + item['sport']),
                  child:  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(child: Text("Versus: ${widget.linkRequests[index]['against']}", style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              fontSize: 20
                          ),), padding: EdgeInsets.only(left: 16),),
                          Container(child: Text("Sport: ${widget.linkRequests[index]['sport']}", style: TextStyle(
                              fontSize: 15
                          ),), padding: EdgeInsets.only(left: 16),),
                          Container(child: Text("Score: ${widget.linkRequests[index]['myScore']} - ${widget.linkRequests[index]['oppScore']}", style: TextStyle(
                              fontSize: 15
                          ),), padding: EdgeInsets.only(left: 16),),
                          Container(child: Text("Winner: ${widget.linkRequests[index]['winner']}", style: TextStyle(
                              fontSize: 15
                          ),), padding: EdgeInsets.only(left: 16),),
                        ],
                      ),
                      Expanded(child: Container(),),
                      IconButton(
                          icon: Icon(Icons.check,color: Colors.green,),
                          onPressed: () async {
                            try {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              String name = prefs.getString('name');
                              String uuid = prefs.getString('uuid');
                              var tData = await _firestore.collection('tourneys').document(uuid).get();
                              List verifications = [];
                              List newPlayerData = [];

                              tData.data['players'].forEach((ele) => {
                                if(ele['name'] == name){
                                  verifications = ele['verify'],
                                }
                              });

                              verifications.removeAt(index);
                              print(verifications);
                              // Getting increment up
                              int incUpMe = widget.linkRequests[index]['myScore'];
                              int inc = widget.linkRequests[index]['myScore'];


                              tData.data['players'].forEach((ele) {
                                if (ele['name'] == name) {
                                  Map versus = ele['versus'];
                                  Map tempAgainst = versus[widget.linkRequests[index]['against']];
                                  Map tempSportPlayed = tempAgainst[widget.linkRequests[index]['sport']];
                                  tempSportPlayed['verified'] = true;
                                  tempAgainst[widget.linkRequests[index]['sport']] = tempSportPlayed;
                                  versus[widget.linkRequests[index]['against']] = tempAgainst;

                                  newPlayerData.add({
                                    'name': ele['name'],
                                    'number': ele['number'],
                                    'overallScore': ele['overallScore'] + widget.linkRequests[index]['myScore'],
                                    'verify': verifications,
                                    'versus': versus,
                                  });
                                } else if (ele['name'] == widget.linkRequests[index]['against']) {
                                  Map versus = ele['versus'];
                                  Map tempAgainst = versus[name];
                                  Map tempSportPlayed = tempAgainst[widget.linkRequests[index]['sport']];
                                  tempSportPlayed['verified'] = true;
                                  tempAgainst[widget.linkRequests[index]['sport']] = tempSportPlayed;
                                  versus[name] = tempAgainst;

                                  newPlayerData.add({
                                    'name': ele['name'],
                                    'number': ele['number'],
                                    'overallScore':  ele['overallScore'] + widget.linkRequests[index]['oppScore'],
                                    'verify': ele['verify'],
                                    'versus': versus,
                                  });
                                }  else {
                                  newPlayerData.add({
                                    'name': ele['name'],
                                    'number': ele['number'],
                                    'overallScore': ele['overallScore'],
                                    'verify': ele['verify'],
                                    'versus': ele['versus'],
                                  });
                                }
                              }
                              );
                              await _firestore.collection('tourneys')
                                  .document(uuid)
                                  .updateData({
                                'started': true,
                                'players': newPlayerData
                              });

                              setState(() {
                                widget.linkRequests.removeAt(index);
                              });
                            } catch (e) {
                              print(e.toString());
                              Navigator.pop(context);
                            }
                          }
                      ),
                      IconButton(
                          icon: Icon(Icons.close, color: Colors.red,),
                          onPressed: ()async{
                            try {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              String name = prefs.getString('name');
                              String uuid = prefs.getString('uuid');
                              var tData = await _firestore.collection('tourneys').document(uuid).get();
                              List verifications = [];
                              List newPlayerData = [];

                              tData.data['players'].forEach((ele) => {
                                if(ele['name'] == name){
                                  verifications = ele['verify'],
                                }
                              });
                              verifications.remove(widget.linkRequests[index]);
                              tData.data['players'].forEach((ele) {
                                if (ele['name'] == name) {
                                  newPlayerData.add({
                                    'name': ele['name'],
                                    'number': ele['number'],
                                    'overallScore': ele['overallScore'],
                                    'verify': verifications,
                                    'versus': ele['versus'],
                                  });
                                } else {
                                  newPlayerData.add({
                                    'name': ele['name'],
                                    'number': ele['number'],
                                    'overallScore': ele['overallScore'],
                                    'verify': ele['verify'],
                                    'versus': ele['versus'],
                                  });
                                }
                              }
                              );
                              await _firestore.collection('tourneys')
                                  .document(uuid)
                                  .updateData({
                                'started': true,
                                'players': newPlayerData
                              });

                              setState(() {
                                widget.linkRequests.removeAt(index);
                              });
                            } catch (e) {
                              print(e.toString());
                              Navigator.pop(context);
                            }
                          }
                      ),
                    ],),
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                  ),
                );
              })
        ],
      ),
    );
  }
}

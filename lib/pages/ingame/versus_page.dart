import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:expandable/expandable.dart';
import 'package:hippie/pages/home.dart';
import 'package:hippie/widgets/custom_button.dart';
import 'package:hippie/widgets/players_list_widget.dart';
import 'package:hippie/widgets/sport_record_widget.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VersusPage extends StatefulWidget {
  final String oppName; // Bob
  final String yourName;
  final List<GameHistoryStructure> history;
  final List sports;

  const VersusPage({Key key, this.oppName, this.yourName, this.history, this.sports}) : super(key: key);
  @override
  _VersusPageState createState() => _VersusPageState();
}

class _VersusPageState extends State<VersusPage> {
   String sportPlayed;
   int myScore;
   int oppScore;




   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      sportPlayed = widget.sports[0];
    });
  }

   String validateScore(String value) {
     if (value == null || value.isEmpty || value.trim() == '') {
       return "Missing Score";
     }
     return null;
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("vs. ${widget.oppName}"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                'What sport was played?', textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 32
                ),
              ),
            ),
            Row(
              children: [
                Expanded(child: Container(),),
                DropdownButton<String>(
                  value: sportPlayed,
                  icon: Icon(Icons.arrow_drop_down,
                      color: Colors.black),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.black),
                  underline: Container(
                    height: 2,
                    color: Colors.blue,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      sportPlayed = newValue;
                    });
                  },
                  items: widget.sports.map<DropdownMenuItem<String>>(
                          (value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 20
                          ),),
                        );
                      }).toList(),
                ),
                Expanded(child: Container(),)
              ],
            ),
            SizedBox(height: 10,),
            Row(children: [
              Container(
                  width: 150,
                  child:TextFormField(
                  onChanged: (value) => myScore = int.parse(value),
                  autocorrect: false,
                  toolbarOptions: ToolbarOptions(
                    copy: true,
                    paste: true,
                    selectAll: true,
                    cut: true,
                  ),
                  validator: (value) => validateScore(value.toString()),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "${widget.yourName}'s points ",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3))
                      )
                  )
              ),),
              Expanded(child: Container(child: Text('-',
                style: TextStyle(
                  fontSize: 50
                ), textAlign: TextAlign.center,),),),
              Container(
                  width: 150,
                  child:TextFormField(
                  onChanged: (value) => oppScore = int.parse(value),
                  autocorrect: false,
                  toolbarOptions: ToolbarOptions(
                    copy: true,
                    paste: true,
                    selectAll: true,
                    cut: true,
                  ),
                  validator: (value) => validateScore(value.toString()),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "${widget.oppName}'s points ",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3))
                      )
                  )
              ) ,),


            ],),
            Container(
              padding: EdgeInsets.all(16),
              child: CustomButton(
                text: 'Record',
                callback: ()async{
                  try {
                    Firestore _firestore = Firestore.instance;
                    SharedPreferences prefs = await SharedPreferences
                        .getInstance();
                    String uuid = prefs.getString('uuid');
                    String name = widget.yourName;
                    List newPlayerData = [];
                    var tData = await _firestore.collection('tourneys')
                        .document(uuid)
                        .get();


                    tData.data['players'].forEach((ele) {
                      if (ele['name'] == name) {
                        Map versus = ele['versus'];
                        Map tempAgainst = versus[widget.oppName];
                        Map tempSportPlayed = tempAgainst[sportPlayed];
                        tempSportPlayed['played'] = true;

                        tempSportPlayed['myScore'] = myScore;
                        tempSportPlayed['oppScore'] = oppScore;

                        tempSportPlayed['recorded'] = name;
                        tempSportPlayed['winner'] = myScore > oppScore ? name : widget.oppName;
                        tempAgainst[sportPlayed] = tempSportPlayed;
                        versus[widget.oppName] = tempAgainst;
                        newPlayerData.add({
                          'name': ele['name'],
                          'number': ele['number'],
                          'overallScore': ele['overallScore'],
                          'verify': ele['verify'],
                          'versus': versus,
                        });
                      } else if (ele['name'] == widget.oppName){
                        Map versus = ele['versus'];
                        Map tempAgainst = versus[name];
                        Map tempSportPlayed = tempAgainst[sportPlayed];
                        tempSportPlayed['played'] = true;

                        // Change to myScore
                        tempSportPlayed['myScore'] = oppScore;
                        tempSportPlayed['oppScore'] = myScore;


                        tempSportPlayed['recorded'] = name;
                        tempSportPlayed['winner'] = myScore > oppScore ? name : widget.oppName;
                        tempAgainst[sportPlayed] = tempSportPlayed;
                        versus[name] = tempAgainst;

                        List currVerificationRequests = ele['verify'];
                        currVerificationRequests.add({
                          'sport': sportPlayed,
                          'winner': myScore > oppScore ? name: widget.oppName,
                          'myScore': oppScore,
                          'oppScore': myScore,
                          'against' : name
                        });

                        newPlayerData.add({
                          'name': ele['name'],
                          'number': ele['number'],
                          'overallScore': ele['overallScore'],
                          'verify': currVerificationRequests,
                          'versus': versus,
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
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.of(context).pop();
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Home()
                        ));
                  } catch (e) {
                    print(e.toString());
                  }
                },
              ),
            ),
            Divider(thickness: 2,),
            Row(children: [
              Text('Your Record', style: TextStyle(
                  fontSize: 20
              ),),
            ],),
            Column(children: widget.history.map((item) =>
            item.sport != 'number' ?
            new ExpandablePanel(
              header: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                ),
          child: Text(item.sport, style: TextStyle(
            color: Colors.blue,
            fontSize: 30
          ),)
      ),
              expanded: SportRecordWidget(
                played: item.history['played'],
                verified: item.history['verified'],
                myScore: item.history['myScore'],
                oppScore: item.history['oppScore'],
                winner: item.history['winner'],
              ),
            ) : new Container()).toList()),

          ],
        ),
      ),
    );
  }
}

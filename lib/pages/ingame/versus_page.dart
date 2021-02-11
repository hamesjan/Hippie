import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:expandable/expandable.dart';
import 'package:hippie/pages/home.dart';
import 'package:hippie/widgets/custom_button.dart';
import 'package:hippie/widgets/players_list_widget.dart';
import 'package:hippie/widgets/sport_record_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VersusPage extends StatefulWidget {
  final String name; // Bob
  final List<GameHistoryStructure> history;
  final List sports;

  const VersusPage({Key key, this.name, this.history, this.sports}) : super(key: key);
  @override
  _VersusPageState createState() => _VersusPageState();
}

class _VersusPageState extends State<VersusPage> {
   String sportPlayed;
   String score;
   bool winner = false;



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
        title:  Text("vs. ${widget.name}"),
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
            Row(children: [
              Expanded(child: Container(),),
              Text('Did you win?',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15
                ),),
              Checkbox(
                  value: winner,
                  activeColor: Colors.green,
                  onChanged:(bool newValue){
                    setState(() {
                      winner = newValue;
                    });
                  }),
              Expanded(child: Container(),),
            ],),
            SizedBox(height: 10,),
            TextFormField(
                onChanged: (value) => score = value,
                autocorrect: false,
                toolbarOptions: ToolbarOptions(
                  copy: true,
                  paste: true,
                  selectAll: true,
                  cut: true,
                ),
                maxLines: null,
                validator: (value) => validateScore(value),
                decoration: InputDecoration(
                    hintText: "45-13",
                    labelText: 'Score',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3))
                    )
                )
            ),
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
                    String name = prefs.getString('name');
                    List newPlayerData = [];
                    var tData = await _firestore.collection('tourneys')
                        .document(uuid)
                        .get();



                    tData.data['players'].forEach((ele) {
                      if (ele['name'] == name) {
                        Map versus = ele['versus'];
                        Map tempAgainst = versus[widget.name];
                        Map tempSportPlayed = tempAgainst[sportPlayed];
                        tempSportPlayed['played'] = true;
                        tempSportPlayed['score'] = score;
                        tempSportPlayed['recorded'] = name;
                        tempSportPlayed['winner'] = winner ? name : widget.name;
                        tempAgainst[sportPlayed] = tempSportPlayed;
                        versus[widget.name] = tempAgainst;
                        newPlayerData.add({
                          'name': ele['name'],
                          'number': ele['number'],
                          'overallScore': ele['overallScore'],
                          'verify': ele['verify'],
                          'versus': versus,
                        });
                      } else if (ele['name'] == widget.name){
                        Map versus = ele['versus'];
                        Map tempAgainst = versus[name];
                        Map tempSportPlayed = tempAgainst[sportPlayed];
                        tempSportPlayed['played'] = true;
                        tempSportPlayed['score'] = score;
                        tempSportPlayed['recorded'] = name;
                        tempSportPlayed['winner'] = winner ? name : widget.name;
                        tempAgainst[sportPlayed] = tempSportPlayed;
                        versus[name] = tempAgainst;

                        List currVerificationRequests = ele['verify'];
                        currVerificationRequests.add({
                          'sport': sportPlayed,
                          'winner': winner ? name: widget.name,
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
                score: item.history['score'],
                winner: item.history['winner'],
              ),
            ) : new Container()).toList()),

          ],
        ),
      ),
    );
  }
}

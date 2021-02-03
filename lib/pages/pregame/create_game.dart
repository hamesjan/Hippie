import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hippie/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:hippie/pages/home.dart';

class CreateGame extends StatefulWidget {
  @override
  _CreateGameState createState() => _CreateGameState();
}

class _CreateGameState extends State<CreateGame> {
  final Firestore _firestore = Firestore.instance;
  final _createGameKey = GlobalKey<FormState>();

  String name;
  String phonenumber;
  DateTime endDate;
  bool tennis = false;
  bool badminton = false;
  bool pingpong = false;
  bool racquetball = false;
  bool squash = false;
  bool participate = false;
  bool pickelball = false;
  bool padel = false;
  bool paddeltennis = false;
  bool aussieracquetball = false;
  String score_privacy = 'Private';
  String bracket = 'Free For All';



  String validateName(String value) {
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
        title: Text('Create a Tournament'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
    key: _createGameKey,
    child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
                onChanged: (value) => name = value,
                autocorrect: false,
                toolbarOptions: ToolbarOptions(
                  copy: true,
                  paste: true,
                  selectAll: true,
                  cut: true,
                ),
                maxLines: null,
                validator: (value) => validateName(value),
                decoration: InputDecoration(
                    hintText: "Tom's Tourney",
                    labelText: 'Tournament Name',
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
            SizedBox(height: 20,),
            Divider(thickness: 2,),
            RaisedButton(
              child: Row(
                children: [
                  Icon(Icons.date_range),
                  SizedBox(width: 10,),
                  Text('Set Tournament Finish Date'),
                ],
              ),
              onPressed: (){
                DatePicker.showDatePicker(context,
                  showTitleActions: true,
                  minTime: DateTime.now(),
                  onChanged: (date) {
                    setState(() {
                      endDate = date;
                    });
                  }, currentTime: DateTime.now(),);
              },
            ),
            Text(
              endDate.toString() == 'null' ? 'Choose a Date' :endDate.toString().substring(0, 10) ,
              style: TextStyle(color: Colors.blue, fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Divider(thickness: 2,),
            Row(children: [
              Expanded(child: Container(),),
              Text('Will you be participating?',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15
                ),),
              Checkbox(
                  value: participate,
                  activeColor: Colors.green,
                  onChanged:(bool newValue){
                    setState(() {
                      participate = newValue;
                    });
                  }),
              Expanded(child: Container(),),
            ],),
            Row(
              children: [
                Expanded(child: Container(),),
                Text(
                  'Score Visibility',
                  style: TextStyle(
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 10,
                ),
                DropdownButton<String>(
                  value: score_privacy,
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
                      score_privacy = newValue;
                    });
                  },
                  items: <String>[
                    'Private',
                    'Public',
                  ].map<DropdownMenuItem<String>>(
                          (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: TextStyle(
                              fontWeight: FontWeight.normal
                          ),),
                        );
                      }).toList(),
                ),
                Expanded(child: Container(),)
              ],
            ),
            Row(
              children: [
                Expanded(child: Container(),),
                Text(
                  'Bracket Size',
                  style: TextStyle(
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 10,
                ),
                DropdownButton<String>(
                  value: bracket,
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
                      bracket = newValue;
                    });
                  },
                  items: <String>[
                    'Free For All',
                    'Brackets'
                  ].map<DropdownMenuItem<String>>(
                          (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: TextStyle(
                              fontWeight: FontWeight.normal
                          ),),
                        );
                      }).toList(),
                ),
                Expanded(child: Container(),)
              ],
            ),
            Divider(thickness: 2,),
            Text('Sports', style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),),
            Row(children: [
              Expanded(child: Container(),),
              Text('Badminton',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15
                ),),
              Checkbox(
                  value: badminton,
                  activeColor: Colors.green,
                  onChanged:(bool newValue){
                    setState(() {
                      badminton = newValue;
                    });
                  }),
              Expanded(child: Container(),),
            ],),
            Row(children: [
              Expanded(child: Container(),),
              Text('Tennis',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15
                ),),
              Checkbox(
                  value: tennis,
                  activeColor: Colors.green,
                  onChanged:(bool newValue){
                    setState(() {
                      tennis = newValue;
                    });
                  }),
              Expanded(child: Container(),),
            ],),
            Row(children: [
              Expanded(child: Container(),),
              Text('Padel',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15
                ),),
              Checkbox(
                  value: padel,
                  activeColor: Colors.green,
                  onChanged:(bool newValue){
                    setState(() {
                      padel = newValue;
                    });
                  }),
              Expanded(child: Container(),),
            ],),
            Row(children: [
              Expanded(child: Container(),),
              Text('Pickleball',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15
                ),),
              Checkbox(
                  value: pickelball,
                  activeColor: Colors.green,
                  onChanged:(bool newValue){
                    setState(() {
                      pickelball = newValue;
                    });
                  }),
              Expanded(child: Container(),),
            ],),
            Row(children: [
              Expanded(child: Container(),),
              Text('Paddle Tennis',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15
                ),),
              Checkbox(
                  value: paddeltennis,
                  activeColor: Colors.green,
                  onChanged:(bool newValue){
                    setState(() {
                      paddeltennis = newValue;
                    });
                  }),
              Expanded(child: Container(),),
            ],),
            Row(children: [
              Expanded(child: Container(),),
              Text('Ping Pong',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15
                ),),
              Checkbox(
                  value: pingpong,
                  activeColor: Colors.green,
                  onChanged:(bool newValue){
                    setState(() {
                      pingpong = newValue;
                    });
                  }),
              Expanded(child: Container(),),
            ],),
            Row(children: [
              Expanded(child: Container(),),
              Text('Racquetball',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15
                ),),
              Checkbox(
                  value: racquetball,
                  activeColor: Colors.green,
                  onChanged:(bool newValue){
                    setState(() {
                      racquetball = newValue;
                    });
                  }),
              Expanded(child: Container(),),
            ],),
            Row(children: [
              Expanded(child: Container(),),
              Text('Aussie Racquetball',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15
                ),),
              Checkbox(
                  value: aussieracquetball,
                  activeColor: Colors.green,
                  onChanged:(bool newValue){
                    setState(() {
                      aussieracquetball = newValue;
                    });
                  }),
              Expanded(child: Container(),),
            ],),
            Row(children: [
              Expanded(child: Container(),),
              Text('Squash',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15
                ),),
              Checkbox(
                  value: squash,
                  activeColor: Colors.green,
                  onChanged:(bool newValue){
                    setState(() {
                      squash = newValue;
                    });
                  }),
              Expanded(child: Container(),),
            ],),

            SizedBox(
              height: 15,
            ),
            CustomButton(
              text: 'Create',
              callback: () async{
                if (_createGameKey.currentState.validate()){
                  String id = UniqueKey().toString();
                  var newTourey = await _firestore.collection('tourneys').document(id).setData({
                    'uuid': id,
                    'name' : name,
                  });
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString('uuid', id);
                  prefs.setBool('inGame', true);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Home()
                      ));
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

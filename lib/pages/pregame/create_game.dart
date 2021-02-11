import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hippie/pages/filler/share_id.dart';
import 'package:flutter/services.dart';
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
  String yourName;
  String phonenumber;
  DateTime endDate;
  bool tennis = false;
  bool badminton = false;
  bool pingpong = false;
  bool racquetball = false;
  bool squash = false;
  bool pickelball = false;
  bool padel = false;
  bool paddeltennis = false;
  bool aussieracquetball = false;

  int tennisPoints = 0;
  int badmintonPoints = 0;
  int pingpongPoints = 0;
  int racquetballPoints = 0;
  int squashPoints = 0;
  int pickelballPoints = 0;
  int padelPoints = 0;
  int paddeltennisPoints = 0;
  int aussieracquetballPoints = 0;
  // bool participate = false;
  String score_privacy = 'Private';
  // String bracket = 'Free For All';
  String errorMessage;



  String validateName(String value) {
    if (value == null || value.isEmpty) {
      return "Missing Tournament Name";
    }
    return null;
  }

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
            SizedBox(height: 20,),
            Divider(thickness: 2,),
            ElevatedButton(
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
            // Row(children: [
            //   Expanded(child: Container(),),
            //   Text('Will you be participating?',
            //     textAlign: TextAlign.center,
            //     style: TextStyle(
            //         fontSize: 15
            //     ),),
            //   Checkbox(
            //       value: participate,
            //       activeColor: Colors.green,
            //       onChanged:(bool newValue){
            //         setState(() {
            //           participate = newValue;
            //         });
            //       }),
            //   Expanded(child: Container(),),
            // ],),
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
            // Row(
            //   children: [
            //     Expanded(child: Container(),),
            //     Text(
            //       'Tournament Type',
            //       style: TextStyle(
            //           fontWeight: FontWeight.bold),
            //     ),
            //     SizedBox(
            //       width: 10,
            //     ),
            //     DropdownButton<String>(
            //       value: bracket,
            //       icon: Icon(Icons.arrow_drop_down,
            //           color: Colors.black),
            //       iconSize: 24,
            //       elevation: 16,
            //       style: TextStyle(color: Colors.black),
            //       underline: Container(
            //         height: 2,
            //         color: Colors.blue,
            //       ),
            //       onChanged: (String newValue) {
            //         setState(() {
            //           bracket = newValue;
            //         });
            //       },
            //       items: <String>[
            //         'Free For All',
            //         'Brackets'
            //       ].map<DropdownMenuItem<String>>(
            //               (String value) {
            //             return DropdownMenuItem<String>(
            //               value: value,
            //               child: Text(value, style: TextStyle(
            //                   fontWeight: FontWeight.normal
            //               ),),
            //             );
            //           }).toList(),
            //     ),
            //     Expanded(child: Container(),)
            //   ],
            // ),
            // Divider(thickness: 2,),
            Row(children: [

            ],),
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
              Container(
                  width: 150,
                  padding: EdgeInsets.all(5),
                  child:
              badminton ? TextFormField(
                  onChanged: (value) => badmintonPoints = int.parse(value),
                  autocorrect: false,
                  toolbarOptions: ToolbarOptions(
                    copy: true,
                    paste: true,
                    selectAll: true,
                    cut: true,
                  ),
                  validator: (value) => validateNum(value),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Point Value',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3))
                      )
                  )
              ): Container()),
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
              Container(
                  width: 150,
                  padding: EdgeInsets.all(5),child:
              tennis ? TextFormField(
                  onChanged: (value) => tennisPoints = int.parse(value),
                  autocorrect: false,
                  toolbarOptions: ToolbarOptions(
                    copy: true,
                    paste: true,
                    selectAll: true,
                    cut: true,
                  ),
                  validator: (value) => validateNum(value),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Point Value',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3))
                      )
                  )
              ): Container()),
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
              Container(
                  width: 150,
                  padding: EdgeInsets.all(5),child:
              padel ? TextFormField(
                  onChanged: (value) => padelPoints = int.parse(value),
                  autocorrect: false,
                  toolbarOptions: ToolbarOptions(
                    copy: true,
                    paste: true,
                    selectAll: true,
                    cut: true,
                  ),
                  validator: (value) => validateNum(value),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Point Value',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3))
                      )
                  )
              ): Container()),
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
              Container(
                  width: 150,
                  padding: EdgeInsets.all(5),child:
              pickelball ? TextFormField(
                  onChanged: (value) => pickelballPoints = int.parse(value),
                  autocorrect: false,
                  toolbarOptions: ToolbarOptions(
                    copy: true,
                    paste: true,
                    selectAll: true,
                    cut: true,
                  ),
                  validator: (value) => validateNum(value),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Point Value',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3))
                      )
                  )
              ): Container()),
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
              Container(
                  width: 150,
                  padding: EdgeInsets.all(5),child:
              paddeltennis ? TextFormField(
                  onChanged: (value) => paddeltennisPoints = int.parse(value),
                  autocorrect: false,
                  toolbarOptions: ToolbarOptions(
                    copy: true,
                    paste: true,
                    selectAll: true,
                    cut: true,
                  ),
                  validator: (value) => validateNum(value),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Point Value',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3))
                      )
                  )
              ): Container()),
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
              Container(
                  width: 150,
                  padding: EdgeInsets.all(5),child:
              pingpong ? TextFormField(
                  onChanged: (value) => pingpongPoints = int.parse(value),
                  autocorrect: false,
                  toolbarOptions: ToolbarOptions(
                    copy: true,
                    paste: true,
                    selectAll: true,
                    cut: true,
                  ),
                  validator: (value) => validateNum(value),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Point Value',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3))
                      )
                  )
              ): Container()),
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
              Container(
                  width: 150,
                  padding: EdgeInsets.all(5),child:
              racquetball ? TextFormField(
                  onChanged: (value) => racquetballPoints = int.parse(value),
                  autocorrect: false,
                  toolbarOptions: ToolbarOptions(
                    copy: true,
                    paste: true,
                    selectAll: true,
                    cut: true,
                  ),
                  validator: (value) => validateNum(value),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Point Value',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3))
                      )
                  )
              ): Container()),
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
              Container(
                  width: 150,
                  padding: EdgeInsets.all(5),child:
              aussieracquetball ? TextFormField(
                  onChanged: (value) => aussieracquetballPoints = int.parse(value),
                  autocorrect: false,
                  toolbarOptions: ToolbarOptions(
                    copy: true,
                    paste: true,
                    selectAll: true,
                    cut: true,
                  ),
                  validator: (value) => validateNum(value),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Point Value',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3))
                      )
                  )
              ): Container()),
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
              Container(
                  width: 150,
                  padding: EdgeInsets.all(5),
                  child:
              squash ? TextFormField(
                  onChanged: (value) => squashPoints = int.parse(value),
                  autocorrect: false,
                  toolbarOptions: ToolbarOptions(
                    copy: true,
                    paste: true,
                    selectAll: true,
                    cut: true,
                  ),
                  validator: (value) => validateNum(value),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Point Value',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3))
                      )
                  )
              ): Container()),
              Expanded(child: Container(),),
            ],),

            SizedBox(
              height: 15,
            ),
            errorMessage == null ? Container() : Text(errorMessage, style: TextStyle(
              color: Colors.red
            ),),
            SizedBox(height: 10,),
            CustomButton(
              text: 'Create',
              callback: () async{
                if (_createGameKey.currentState.validate() && endDate != null) {
                  try {
                    List Sports = [];
                    Map points = {};
                    if (tennis) {
                      Sports.add('Tennis');
                      points['Tennis'] = tennisPoints;
                    }
                    if (badminton) {
                      Sports.add('Badminton');
                      points['Badminton'] = badmintonPoints;
                    }
                    if (pingpong) {
                      Sports.add('Ping Pong');
                      points['Ping Pong'] = pingpongPoints;
                    }
                    if (racquetball) {
                      Sports.add('Racquetball');
                      points['Racquetball'] = racquetballPoints;
                    }
                    if (squash) {
                      Sports.add('Squash');
                      points['Squash'] = squashPoints;
                    }
                    if (pickelball) {
                      Sports.add('Pickelball');
                      points['Pickelball'] = pickelballPoints;
                    }
                    if (padel) {
                      Sports.add('Padel');
                      points['Padel'] = padelPoints;
                    }
                    if (paddeltennis) {
                      Sports.add('Paddle Tennis');
                      points['Paddle Tennis'] = paddeltennisPoints;
                    }
                    if (aussieracquetball) {
                      Sports.add('Aussie Racquetball');
                      points['Aussie Racquetball'] = aussieracquetballPoints;

                    }
                    String id = UniqueKey().toString();
                    var newTourey = await _firestore.collection('tourneys')
                        .document(id)
                        .setData({
                      'uuid': id,
                      'name': name,
                      'creator_name': yourName,
                      'number': phonenumber,
                      'sports': Sports,
                      'pointValues': points,
                      // 'type': bracket,
                      'score_visibility': score_privacy == 'Private'
                          ? true
                          : false,
                      'ended': false,
                      'players': [
                        {
                          'name': yourName,
                          'number': phonenumber,
                          'versus': {},
                          'overallScore': 0,
                          'verify' : [],
                        }
                      ],
                      'started': false,
                      'endDate': endDate,
                    });
                    SharedPreferences prefs = await SharedPreferences
                        .getInstance();
                    prefs.setString('uuid', id);
                    prefs.setBool('inGame', true);
                    prefs.setString('name', yourName);
                    prefs.setString('number', phonenumber);
                    prefs.setBool('creator', true);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => SharedId(
                              code: id,
                            )
                        ));
                  } catch (e){
                    print(e.toString());
                }

                } else {
                  setState(() {
                    errorMessage = 'Pick a date.';
                  });
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

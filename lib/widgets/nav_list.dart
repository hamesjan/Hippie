import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hippie/pages/ingame/blank.dart';
import 'package:hippie/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hippie/pages/pregame/join_or_create.dart';

class MenuListTileWidget extends StatefulWidget {
  @override
  _MenuListTileWidgetState createState() => _MenuListTileWidgetState();
}

class _MenuListTileWidgetState extends State<MenuListTileWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.wb_sunny),
          title: Text('Home'),
          onTap: (){
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Home()
                )
            );
          },
        ),
        Divider(color: Colors.grey,),
        ListTile(
          leading: Icon(Icons.check_box_outline_blank),
          title: Text('Blank'),
          onTap: (){
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Blank()
                )
            );
          },
        ),
        Divider(color: Colors.grey),
        ListTile(
          leading: Icon(Icons.delete_forever, color: Colors.red,),
          title: Text('Leave Tournament?', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),),
          onTap: ()async {
            showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Are you sure you want to leave this tournament?\nThis action can not be undone.', textAlign: TextAlign.center,),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Leave Forever', style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red
                        ),),
                        onPressed: ()async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.setBool('inGame', false);
                          prefs.setString('uuid', 'none');
                          prefs.setString('name', '1023417');
                          prefs.remove('name');
                          prefs.remove('number');
                          prefs.setBool('creator', false);
                          Navigator.pop(context);
                          Navigator.pop(context);
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
        ),
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hippie/pages/ingame/blank.dart';
import 'package:hippie/pages/home.dart';
import 'package:hippie/pages/ingame/incomplete_verfications.dart';
import 'package:hippie/pages/ingame/player_results.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hippie/pages/pregame/join_or_create.dart';

class MenuListTileWidget extends StatefulWidget {
  final List verficiations;
  final List players;
  final bool private;
  final bool creator;

  const MenuListTileWidget({Key key, this.verficiations, this.players, this.private, this.creator}) : super(key: key);
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
        widget.verficiations.length == 0 ?
        ListTile(
          leading: Icon(Icons.verified),
          title: Text('Verify'),
          onTap: (){
            showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('You have no verification requests.', textAlign: TextAlign.center,),
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
          },
        ):
        ListTile(
          leading: Icon(Icons.verified, color: Colors.blue,),
          title: Text('Verify'),
          onTap: (){
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LinkRequests(
                      linkRequests: widget.verficiations,
                    )
                )
            );
          },
        ),
      !widget.private || widget.creator ? Divider(color: Colors.grey) : Container(),
        !widget.private || widget.creator ?  ListTile(
          leading: Icon(Icons.playlist_add_check_outlined,),
          title: Text('Current Standings'),
          onTap: (){
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PlayerResults(
                      players: widget.players,
                    )
                )
            );
          },
        ): Container(),
        Divider(color: Colors.grey),
        !widget.creator ? ListTile(
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
        ) : Container(),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';


class Profile extends StatefulWidget {
  final String name;
  final String number;
  final bool started;
  final bool creator;
  final String code;
  final List players;
  final int overallScore;

  const Profile({Key key, this.name, this.number, this.creator, this.started, this.players, this.code, this.overallScore}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final snackBar = SnackBar(content: Text('Code Copied to Clipboard'));

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
          Divider(thickness: 2,),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Text('Overall Score', style: TextStyle(
                  fontSize: 20,
                ),),
                Text(widget.overallScore.toString(), style: TextStyle(
                    fontSize: 40,
                    color: Colors.blue
                ))
              ],
            ),
          ),
          Divider(thickness: 2,),
          Text('Tourney Code', style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold
          ),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.code.substring(2, 7), style: TextStyle(
                fontSize: 32,
              )),
              IconButton(
                  icon: Icon(Icons.copy),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: widget.code.substring(2, 7)))
                        .then((value) { //only if ->
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    );
                  }
              )
            ],
          ),
          Divider(thickness: 2,),

          Container(
      child: Text('Players', style: TextStyle(fontSize: 20),),
    ),
    Column(children: widget.players.map((item) =>
    new Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(width: MediaQuery.of(context).size.width,),
          Row(children: [
            Container(
              padding: EdgeInsets.only(left: 10),
              child:
              Text(item['name'], style: TextStyle(fontSize: 20, color: Colors.blue), ),
            ),
            Expanded(child: Container(),),
            Container(
              padding: EdgeInsets.only(right: 10),
              child:
              Text(item['number'], style: TextStyle(fontSize: 15),),)
          ],),
        ],
      ),
    )
    // PlayersListWidget(
    //   name: item.against,
    //   number: item.sports['number'],
    //   playerData: item.sports,
    // )
    ).toList()),
    SizedBox(height: 10,),
          !widget.started ?  Text('Waiting for Tournament to Start...', textAlign: TextAlign.center, style: TextStyle(
            fontSize: 24
          ),) : Container(),
          SizedBox(height: 10,),

        ],
      ),
    );
  }
}

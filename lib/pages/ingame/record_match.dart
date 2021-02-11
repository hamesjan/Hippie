import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hippie/widgets/players_list_widget.dart';

class RecordMatch extends StatefulWidget {
  final List opponents;

  const RecordMatch({Key key, this.opponents}) : super(key: key);
  @override
  _RecordMatchState createState() => _RecordMatchState();
}

class _RecordMatchState extends State<RecordMatch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Record Match'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                'Who would you like to record a match against?', textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32
                ),
              ),
            ),
            Divider(thickness: 2,),
            Column(children: widget.opponents.map((item) =>
            new PlayersListWidget(
              name: item.against,
              number: item.sports['number'],
              playerData: item.sports,
            )
            ).toList())
          ],
        ),
      ),
    );
  }
}

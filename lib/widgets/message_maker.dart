import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Message extends StatelessWidget {
  final String date;
  final String text;


  final bool me;

  const Message({Key key, this.date, this.text, this.me}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Material(
            color: Colors.lightBlue,
            borderRadius: BorderRadius.circular(10),
            elevation: 6,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Text(text),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(date),
          // Text(DateFormat('yyyy-MM-dd hh:mm').format(DateTime.parse(date))),
        ],
      ),
    );
  }
}

import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hippie/widgets/message_maker.dart';
import 'package:hippie/widgets/custom_button.dart';

class MessageBoard extends StatefulWidget {
  final String name;
  final String uuid;

  const MessageBoard({Key key, this.name, this.uuid}) : super(key: key);

  @override
  _MessageBoardState createState() => _MessageBoardState();
}

class _MessageBoardState extends State<MessageBoard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;



  Future<void> callback() async {
    if (messageController.text.length > 0) {

      await _firestore.collection('tourneys').document(widget.uuid).collection('convo').add({
        'text': messageController.text,
        'from': widget.name,
        'date': DateTime.now().toIso8601String().toString(),
      });

      messageController.clear();
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }


  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Message Board', style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold
            ),),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('tourneys').document(widget.uuid).collection('convo').orderBy('date').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  List<DocumentSnapshot> docs = snapshot.data.documents;
                  List<Widget> messages = docs
                      .map((doc) => Message(
                    date: doc.data['from'],
                    text: doc.data['text'],
                    me: widget.name == doc.data['from'],
                  ))
                      .toList();

                  return ListView(
                    controller: scrollController,
                    children: <Widget>[
                      ...messages
                    ],
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16,
              right: 16,
              bottom: 50),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onSubmitted: (value) => callback(),
                      controller: messageController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(3))
                          )
                      ),
                    ),
                  ),
                  SendButton(
                    icon: Icon(Icons.send),
                    callback: (){
                      callback();
                    },
                  )
                ],
              ),
            )
          ],
        ),
      );
  }
}

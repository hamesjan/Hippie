import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hippie/pages/home.dart';
import 'package:flutter/services.dart';

class SharedId extends StatelessWidget {
  final String code;

  const SharedId({Key key, this.code}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final snackBar = SnackBar(content: Text('Code Copied to Clipboard'));

    return Scaffold(
      appBar: AppBar(
        title: Text('Tourney Code'),
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: (){
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(
                    builder: (BuildContext context) => Home()
                ));
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child:  Text('Your tournament has been created.\nCopy and share this code.\nThis will be the code used to join the tournament.',
              textAlign: TextAlign.center,),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(code.substring(2, 7), style: TextStyle(
                fontSize: 32,
              )),
              IconButton(
                icon: Icon(Icons.copy),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: code.substring(2, 7)))
                      .then((value) { //only if ->
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  );
                }
              )
            ],
          ),

        ],
      ),
    );
  }
}

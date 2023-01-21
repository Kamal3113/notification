

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notification_demo/messaging.dart';

// ignore: must_be_immutable
class Notify extends StatefulWidget {
  String to;
String dcid;
String toToken;
  // const Notify({Key key}) : super(key: key);
Notify({
this.to,this.dcid,this.toToken
});
  @override
  State<Notify> createState() => _NotifyState();
}

class _NotifyState extends State<Notify> {
 
    TextEditingController _messageController = TextEditingController();
    FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;
User user;
     handleInput(String input){
    db.collection("users").doc(widget.dcid.toString())
.collection("notifications").add({
  "message": input,
"title": user.email,
"date": FieldValue.serverTimestamp()
}).then((value){
  sendNotification();

 
});
  }
     Future sendNotification() async {
    await Messaging.sendToUser(
      alert:_messageController.text ,
      // description: _description.text,
     id:widget.toToken
    // amount: content,
    );
    _messageController.clear();
    }  
   @override
  void initState(){

    fetchUsers();
    super.initState();
  }
  fetchUsers()async{
    User u =  await auth.currentUser;
setState((){
user = u;
});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.to),
      ), // AppBar
      body: Container(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Flexible(
                  child: TextField(
                    controller: _messageController,
                decoration: InputDecoration(
                  hintText: "Write message here",
                ), 
                textInputAction: TextInputAction.send,
                onSubmitted: handleInput(_messageController.text),// Input Decoration
              )), // Flexible
              FloatingActionButton(
                  onPressed: () {
                    handleInput(_messageController.text);
                  }, child: Icon(Icons.send)), // Icon
// FloatingActionButton
            ], // <Widget>[]
          ), // Row
        ), // Container
      ), // Container
    );
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:notification_demo/login.dart';
import 'package:notification_demo/notification.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({Key key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<DocumentSnapshot> users;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    fetchUsers();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showMessage("Notification", "$message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        showMessage("Notification", "$message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        showMessage("Notification", "$message");
      },
    );
    if(Platform.isIOS){
_firebaseMessaging.requestNotificationPermissions(
const IosNotificationSettings(
sound: true, badge: true, alert: true, provisional: false));
}
    super.initState();
  }

  showMessage(title, description) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
              title: Text(title),
              content: Text(description),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                  child: Text("Dismiss"),
                )
              ]);
        });
  }

  fetchUsers() async {
    QuerySnapshot snapshot = await db.collection("users").get();
    setState(() {
      users = snapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              "Home",
              style: TextStyle(
                color: Colors.black,
              ), // Text Style
            ), // Text
            centerTitle: true,
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            elevation: 0,
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.exit_to_app,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    FirebaseAuth.instance.signOut().then((a) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Loginscrenn(),
                        ),
                      );
                    });
                  })
            ]),
        body: Container(
            child: users != null
                ? ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (ctx, index) {
                      return Container(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(users[index]
                                .data()["email"]
                                .toString()
                                .substring(0, 1)),
                          ),
                          title: Text(users[index].data()["email"]),
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Notify(
                                    to: users[index].data()["email"],
                                    dcid: users[index].id,
                                    toToken:users[index].data()["fcmToken"]),
                              ),
                            );
                          },
                        ),
                      );
                    })
                : CircularProgressIndicator()));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:notification_demo/homescreen.dart';

class Loginscrenn extends StatefulWidget {
  const Loginscrenn({Key key}) : super(key: key);

  @override
  State<Loginscrenn> createState() => _LoginscrennState();
}

class _LoginscrennState extends State<Loginscrenn> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  void initState() {
    checkUserAuth();
    super.initState();
  }

  checkUserAuth() async {
    try {
      User user = await auth.currentUser;
      if (user != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Homescreen()));
      }
    } catch (e) {}
  }

  signIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    if (email.isNotEmpty && password.isNotEmpty) {
      auth.signInWithEmailAndPassword(email: email, password: password)
.then((authResult)async{
  String fcmToken = await firebaseMessaging.getToken();
User user = authResult.user;
db.collection("users")
.doc(user.uid)
.set({
"email": user.email,
"fcmToken": fcmToken
});
   Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Homescreen()));
})
.catchError((error){
   showMessage("Alert" , "$error");
}
);
    } else {
// show alert
      print("Provide email & pass");
      showMessage("Alert" , "Provide detail");
    }
  }
showMessage(title , description){
  showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text(title),
              content: Text(description),
            actions: <Widget>[
FlatButton(
onPressed: (){
Navigator.pop(ctx);
},
child: Text("Dismiss"),)

]);
          });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Email",
              labelText: "Email",
            ), // Input Decoration
            keyboardType: TextInputType.emailAddress,
          ), // TextField
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Password",
              labelText: "Password",
            ), // InputDecoration
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
          ), // TextField
          SizedBox(
            height: 20,
          ),
          RaisedButton(child: Text("Login"), onPressed: () {signIn();})
        ],
      ),
    );
  }
}

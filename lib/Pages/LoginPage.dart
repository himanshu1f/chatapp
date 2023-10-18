import 'dart:async';

import 'package:chat/utility/asset_path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:chat/Pages/HomePage.dart';
import 'package:chat/Widgets/ProgressWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginScreen extends StatefulWidget
{
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences? preferences;
  bool isLoggedIn = false;
  bool isLoading = false;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    isSignedIn();
  }

  void isSignedIn() async {
    preferences = await SharedPreferences.getInstance();
    isLoggedIn = await googleSignIn.isSignedIn();
    if(isLoggedIn) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(currentUserId: preferences!.getString(""))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.lightBlueAccent, Colors.purpleAccent],
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Himo Chat",
              style: TextStyle(fontSize: 82.0, color: Colors.white, fontFamily: "Signatra"),
            ),
            GestureDetector(
              onTap: controlSignIn,
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 270.0,
                      height: 65.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(AssetPath().google),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: isLoading ? circularProgress() : Container(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  controlSignIn() async {
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuthentication = await googleUser!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuthentication.idToken,
      accessToken: googleAuthentication.accessToken,
    );
    User? firebaseUser = (await firebaseAuth.signInWithCredential(credential)).user;

    //SignIn Success
    if(firebaseUser != null) {
      //Check if already SignUp
      // final QuerySnapshot resultQuery = await Firestore.instance.collection("users")
      //     .where("id", isEqualTo: firebaseUser.uid).getDocuments();
      final QuerySnapshot resultQuery = await FirebaseFirestore.instance.collection("users")
          .where("id", isEqualTo: firebaseUser.uid).get();

      final List<DocumentSnapshot> documentSnapshots = resultQuery.docs;

      //Save Data to firestore - if new user
      if(documentSnapshots.isEmpty) {
        FirebaseFirestore.instance.collection("users").doc(firebaseUser.uid).set({
          "nickname" : firebaseUser.displayName,
          "photoUrl" : firebaseUser.photoURL,
          "id" : firebaseUser.uid,
          "aboutMe" : "I am using Himo Chat app.",
          "createAt" : DateFormat("MMMM dd, yyyy HH:MM a").format(DateTime.now()).toString(),
          "chattingWith" : null,
        });

        //Write data to Local
        currentUser = firebaseUser;
        await preferences!.setString("id", currentUser!.uid);
        await preferences!.setString("nickname", currentUser!.displayName!);
        // await preferences!.setString("photoUrl", currentUser!.photoURL!);
      } else {
        //Write data to Local
        currentUser = firebaseUser;
        await preferences!.setString("id", documentSnapshots[0]["id"]);
        await preferences!.setString("nickname", documentSnapshots[0]["nickname"]);
        // await preferences!.setString("photoUrl", documentSnapshots[0]["photoUrl"]);
        await preferences!.setString("aboutMe", documentSnapshots[0]["aboutMe"]);
      }
      Fluttertoast.showToast(msg: "Congratulation, Sign in Successful");

      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(currentUserId: firebaseUser.uid)));
    } else {
      //SignIn Not Success - SignIn Failed
      Fluttertoast.showToast(msg: "Try Again, Sign in Failed");
    }
  }
}

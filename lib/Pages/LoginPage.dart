import 'dart:async';
import 'dart:io';

import 'package:chat/util/colors.dart';
import 'package:chat/utility/asset_path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:intl/intl.dart';
import 'package:chat/Pages/HomePage.dart';
import 'package:chat/Widgets/ProgressWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';


class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {

  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: ['profile', 'email'],
  );
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBg,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: isLoading ? circularProgress() : Container(),
          ),
          const SizedBox(height: 20),
          Platform.isIOS ? GestureDetector(
            onTap: signInWithApple,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(AssetPath().google, fit: BoxFit.fill, width: double.infinity, height: 80),
            ),
          ) : const SizedBox(),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: signInWithGoogle,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(AssetPath().google, fit: BoxFit.fill, width: double.infinity, height: 80),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }


  signInWithGoogle() async {
    setState(() {
      isLoading = true;
    });

    googleSignIn.signOut();
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    print(googleUser!.id);
    print(googleUser.displayName);
    print(googleUser.email);
    print(googleUser.photoUrl);
    print(googleUser.serverAuthCode);
    // GoogleSignInAuthentication googleAuthentication = await googleUser!.authentication;

    // final AuthCredential credential = GoogleAuthProvider.credential(
    //   idToken: googleAuthentication.idToken,
    //   accessToken: googleAuthentication.accessToken,
    // );
    // User? firebaseUser = (await firebaseAuth.signInWithCredential(credential)).user;

    // //SignIn Success
    // if(firebaseUser != null) {
    //   //Check if already SignUp
    //   // final QuerySnapshot resultQuery = await Firestore.instance.collection("users")
    //   //     .where("id", isEqualTo: firebaseUser.uid).getDocuments();
    //   final QuerySnapshot resultQuery = await FirebaseFirestore.instance.collection("users")
    //       .where("id", isEqualTo: firebaseUser.uid).get();
    //
    //   final List<DocumentSnapshot> documentSnapshots = resultQuery.docs;
    //
    //   //Save Data to firestore - if new user
    //   if(documentSnapshots.isEmpty) {
    //     FirebaseFirestore.instance.collection("users").doc(firebaseUser.uid).set({
    //       "nickname" : firebaseUser.displayName,
    //       "photoUrl" : firebaseUser.photoURL,
    //       "id" : firebaseUser.uid,
    //       "aboutMe" : "I am using Himo Chat app.",
    //       "createAt" : DateFormat("MMMM dd, yyyy HH:MM a").format(DateTime.now()).toString(),
    //       "chattingWith" : null,
    //     });
    //
    //     //Write data to Local
    //     currentUser = firebaseUser;
    //     await preferences!.setString("id", currentUser!.uid);
    //     await preferences!.setString("nickname", currentUser!.displayName!);
    //     // await preferences!.setString("photoUrl", currentUser!.photoURL!);
    //   } else {
    //     //Write data to Local
    //     currentUser = firebaseUser;
    //     await preferences!.setString("id", documentSnapshots[0]["id"]);
    //     await preferences!.setString("nickname", documentSnapshots[0]["nickname"]);
    //     // await preferences!.setString("photoUrl", documentSnapshots[0]["photoUrl"]);
    //     await preferences!.setString("aboutMe", documentSnapshots[0]["aboutMe"]);
    //   }
    //   Fluttertoast.showToast(msg: "Congratulation, Sign in Successful");
    //
    //   Navigator.of(context).pushNamed('/home');
    // } else {
    //   //SignIn Not Success - SignIn Failed
    //   Fluttertoast.showToast(msg: "Try Again, Sign in Failed");
    // }
    setState(() {
      isLoading = false;
    });
  }


  signInWithApple() async {
    AuthorizationCredentialAppleID credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    String? lastName, firstName, email, authorizationCode, identityToken, userIdentifier;
    if(credential.email == null){
      email = await FlutterKeychain.get(key: "email");
      firstName = await FlutterKeychain.get(key: "firstname");
      lastName = await FlutterKeychain.get(key: "lastname");
      authorizationCode = await FlutterKeychain.get(key: "authorizationcode");
      identityToken = await FlutterKeychain.get(key: "identitytoken");
      userIdentifier = await FlutterKeychain.get(key: "useridentifier");
      print("Email => $email");
      print("firstName => $firstName");
      print("lastName => $lastName");
      print("authorizationCode => $authorizationCode");
      print("identityToken => $identityToken");
      print("userIdentifier => $userIdentifier");
    } else {
      await FlutterKeychain.put(key: "email", value: credential.email!);
      await FlutterKeychain.put(key: "firstname", value: credential.givenName!);
      await FlutterKeychain.put(key: "lastname", value: credential.familyName!);
      await FlutterKeychain.put(key: "authorizationcode", value: credential.authorizationCode);
      await FlutterKeychain.put(key: "identitytoken", value: credential.identityToken!);
      await FlutterKeychain.put(key: "useridentifier", value: credential.userIdentifier!);
      email = await FlutterKeychain.get(key: "email");
      firstName = await FlutterKeychain.get(key: "firstname");
      lastName = await FlutterKeychain.get(key: "lastname");
      authorizationCode = await FlutterKeychain.get(key: "authorizationcode");
      identityToken = await FlutterKeychain.get(key: "identitytoken");
      userIdentifier = await FlutterKeychain.get(key: "useridentifier");
      print("Email => $email");
      print("firstName => $firstName");
      print("lastName => $lastName");
      print("authorizationCode => $authorizationCode");
      print("identityToken => $identityToken");
      print("userIdentifier => $userIdentifier");
    }
  }
}

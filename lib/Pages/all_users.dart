import 'package:chat/Models/user.dart';
import 'package:chat/Pages/HomePage.dart';
import 'package:chat/Widgets/ProgressWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllUsers extends StatefulWidget {
  String currentUserId;
  AllUsers(this.currentUserId);

  @override
  State<AllUsers> createState() => _AllUserState();
}

class _AllUserState extends State<AllUsers> {

  Future<QuerySnapshot>? futureSearchResults;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: displayTheUserFoundScreen(),
    );
  }


  @override
  void initState() {
    super.initState();
    controlSearching();
  }

  displayTheUserFoundScreen() {
    return FutureBuilder(
      future: futureSearchResults,
      builder: (context, dataSnapshot) {
        if(!dataSnapshot.hasData) {
          return circularProgress();
        }
        List<UserResult> searchUserResult = [];
        for (var document in dataSnapshot.data!.docs) {
          UserModel eachUser = UserModel.fromDocument(document);
          UserResult userResult = UserResult(eachUser);
          if(widget.currentUserId.toLowerCase() != document["googleId"].toString().toLowerCase()) {
            searchUserResult.add(userResult);
          }
        }
        return ListView(children: searchUserResult);
      },
    );
  }

  controlSearching() {
    Future<QuerySnapshot> allFoundUsers = FirebaseFirestore.instance.collection("users")
        .where("googleId", isNotEqualTo: widget.currentUserId).get();
    setState(() {
      futureSearchResults = allFoundUsers;
    });
  }
}

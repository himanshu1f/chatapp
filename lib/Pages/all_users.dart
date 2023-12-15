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
  bool isSearchEnable = false;
  TextEditingController searchTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
        title: isSearchEnable ? Container(
          margin: const EdgeInsets.only(bottom: 4.0),
          color: Colors.transparent,
          child: TextFormField(
            style: const TextStyle(fontSize: 18.0, color: Colors.white),
            controller: searchTextEditingController,
            cursorColor: Colors.white,
            decoration: const InputDecoration(
              hintText: "Search here...",
              hintStyle: TextStyle(color: Colors.white24),
            ),
            onChanged: performSearch,
          ),
        ) : const Text(
          "All User",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(isSearchEnable ? Icons.clear : Icons.search , size: 30.0, color: Colors.white),
            onPressed: (){
              setState(() {
                isSearchEnable = !isSearchEnable;
                if(isSearchEnable){
                  searchTextEditingController.clear();
                  performSearch("");
                }
              });
            },
          ),
        ],
      ),
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

  performSearch(String value) {
    Future<QuerySnapshot> allFoundUsers = FirebaseFirestore.instance.collection("users")
        .where("fullName", isGreaterThanOrEqualTo: value.toLowerCase()).get();
    setState(() {
      futureSearchResults = allFoundUsers;
    });
  }
}

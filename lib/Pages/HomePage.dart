import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/Models/user.dart';
import 'package:chat/Pages/AccountSettingsPage.dart';
import 'package:chat/Pages/all_users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat/Pages/ChattingPage.dart';
import 'package:chat/Widgets/ProgressWidget.dart';


class HomeScreen extends StatefulWidget {

  final String? currentUserId;

  HomeScreen({@required this.currentUserId});

  @override
  State createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {

  TextEditingController searchTextEditingController = TextEditingController();
  Future<QuerySnapshot>? futureSearchResults;

  homePageHeader() {
    return AppBar(
      automaticallyImplyLeading: false,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.settings, size: 30.0, color: Colors.black),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountSettings()));
          },
        ),
      ],
      elevation: 0,
      backgroundColor: Colors.white,
      title: Container(
        margin: const EdgeInsets.only(bottom: 4.0),
        color: Colors.white,
        child: TextFormField(
          style: const TextStyle(fontSize: 18.0, color: Colors.black),
          controller: searchTextEditingController,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            hintText: "Search here...",
            hintStyle: const TextStyle(color: Colors.black26),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            prefixIcon: const Icon(Icons.person_pin, color: Colors.black, size: 30.0,),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear, color: Colors.black),
              onPressed: emptyTextFormField,
            ),
          ),
          onFieldSubmitted: controlSearching,
        ),
      ),
    );
  }


  controlSearching(String userName) {
    Future<QuerySnapshot> allFoundUsers = FirebaseFirestore.instance.collection("users")
        .where("fullName", isGreaterThanOrEqualTo: userName).get();
    setState(() {
      futureSearchResults = allFoundUsers;
    });
  }

  emptyTextFormField() {
    searchTextEditingController.clear();
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: homePageHeader(),
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AllUsers(widget.currentUserId!)));
          },
          child: const Icon(Icons.chat),
        ),
        body: futureSearchResults == null ? displayNoSearchResultScreen() : displayTheUserFoundScreen(),
      ),
    );
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
          if(widget.currentUserId!.toLowerCase() != document["googleId"].toString().toLowerCase()) {
           searchUserResult.add(userResult);
          }
        }
        return ListView(children: searchUserResult);
      },
    );
  }


  displayNoSearchResultScreen() {
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: const <Widget>[
          Icon(Icons.group, color: Colors.black26, size: 50),
          Text("Search Users",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black26, fontSize: 20.0, fontWeight: FontWeight.w500,),
          ),
        ],
      ),
    );
  }
}



class UserResult extends StatelessWidget {

  final UserModel eachUser;
  UserResult(this.eachUser);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: ()=> sendUserToChatPage(context),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.black,
                  backgroundImage: CachedNetworkImageProvider(eachUser.photoUrl ?? "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png"),
                ),
                title: Text(
                  eachUser.fullName!,
                  style: const TextStyle(
                    color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "About Me : ${eachUser.aboutMe}",
//                      + DateFormat("dd MMMM, yyyy - hh:mm aa")
//                  .format(DateTime.fromMillisecondsSinceEpoch(int.parse(eachUser.createdAt))),
                  style: const TextStyle(color: Colors.grey, fontSize: 14.0, fontStyle: FontStyle.italic,),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  sendUserToChatPage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => Chat(
            receiverId: eachUser.id,
            receiverAvatar: eachUser.photoUrl,
            receiverName: eachUser.fullName)));
  }

}

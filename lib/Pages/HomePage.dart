import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/Models/user.dart';
import 'package:chat/Pages/AccountSettingsPage.dart';
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

  homePageHeader()
  {
    return AppBar(
      automaticallyImplyLeading: false,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.settings, size: 30.0, color: Colors.white,),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AccountSettings()));
          },
        ),
      ],
      backgroundColor: Colors.lightBlue,
      title: Container(
        margin: const EdgeInsets.only(bottom: 4.0),
        child: TextFormField(
          style: const TextStyle(fontSize: 18.0, color: Colors.white),
          controller: searchTextEditingController,
          decoration: InputDecoration(
            hintText: "Search here...",
            hintStyle: const TextStyle(color: Colors.white),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            filled: true,
            prefixIcon: const Icon(Icons.person_pin, color: Colors.white, size: 30.0,),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear, color: Colors.white,),
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
        .where("nickname", isGreaterThanOrEqualTo: userName).get();
    setState(() {
      futureSearchResults = allFoundUsers;
    });
  }

  emptyTextFormField()
  {
    searchTextEditingController.clear();
  }


  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
    appBar: homePageHeader(),
      body: futureSearchResults == null ? displayNoSearchResultScreen() : displayTheUserFoundScreen(),
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
          if(widget.currentUserId != document["id"]) {
           searchUserResult.add(userResult);
          }
        }
        return ListView(children: searchUserResult);
      },
    );
  }


  displayNoSearchResultScreen()
  {
    final Orientation orientation = MediaQuery.of(context).orientation;

    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: const <Widget>[
            Icon(Icons.group, color: Colors.lightBlueAccent, size: 200.0,),
            Text(
              "Search Users",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.lightBlueAccent, fontSize: 50.0, fontWeight: FontWeight.w500,),
            ),
          ],
        ),
      ),
    );
  }
}



class UserResult extends StatelessWidget
{

  final UserModel eachUser;
  UserResult(this.eachUser);


  @override
  Widget build(BuildContext context)
  {
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
                  backgroundImage: CachedNetworkImageProvider(eachUser.photoUrl!),
                ),
                title: Text(
                  eachUser.nickname!,
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
            receiverName: eachUser.nickname)));
  }

}

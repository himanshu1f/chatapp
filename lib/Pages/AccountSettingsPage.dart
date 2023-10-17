import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/Widgets/ProgressWidget.dart';
import 'package:chat/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';



class AccountSettings extends StatelessWidget {
  const AccountSettings({super.key});

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.lightBlue,
        title: const Text(
          "Account Settings",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: const SettingsScreen(),
    );
  }
}


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State createState() => SettingsScreenState();
}



class SettingsScreenState extends State<SettingsScreen>
{

  TextEditingController? nicknameTextEditingController;
  TextEditingController? aboutMeTextEditingController;

  SharedPreferences? preferences;
  String id = "";
  String nickname = "";
  String aboutMe = "";
  String photoUrl = "";

  XFile? imageFileAvatar;
  bool isLoading = false;
  final FocusNode nickNameFocusNode = FocusNode();
  final FocusNode aboutMeFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    readDataFromLocal();
  }

  void readDataFromLocal() async
  {
    preferences = await SharedPreferences.getInstance();

    id = preferences!.getString("id")!;
    nickname = preferences!.getString("nickname")!;
    aboutMe = preferences!.getString("aboutMe")!;
    photoUrl = preferences!.getString("photoUrl")!;

    nicknameTextEditingController = TextEditingController(text: nickname);
    aboutMeTextEditingController = TextEditingController(text: aboutMe);

    setState(() {

    });
  }


  Future getImage() async
  {
    XFile? newImageFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if(newImageFile != null)
    {
      setState(() {
        imageFileAvatar = newImageFile;
        isLoading = true;
      });
    }

    uploadImageToFirestoreAndStorage();
  }

  Future uploadImageToFirestoreAndStorage() async
  {
    String nFileName = id;
    StorageReference storageReference = FirebaseStorage.instance.ref().child(nFileName);
    StorageUploadTask storageUploadTask = storageReference.putFile(imageFileAvatar);
    StorageTaskSnapshot storageTaskSnapshot;
    storageUploadTask.onComplete.then((value)
    {
      if(value.error == null)
        {
          storageTaskSnapshot = value;
          storageTaskSnapshot.ref.getDownloadURL().then((newImageDownloadUrl)
          {
            photoUrl = newImageDownloadUrl;

            Firestore.instance.collection("users").document(id).updateData({
              "photoUrl" : photoUrl,
              "aboutMe" : aboutMe,
              "nickname" : nickname,
            }).then((data) async
            {
              await preferences!.setString("photoUrl", photoUrl);
              setState(() {
                isLoading = false;
              });
              Fluttertoast.showToast(msg: "Updated Successfully.");
            });
          }, onError: (errorMsg)
          {
            setState(() {
              isLoading = false;
            });

            Fluttertoast.showToast(msg: "Error occurred in getting photo URL.");
          });

        }
    }, onError: (errorMsg)
    {
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: errorMsg.toString());
    });
  }

 void updateData() {
   nickNameFocusNode.unfocus();
   aboutMeFocusNode.unfocus();

   setState(() {
     isLoading = false;
   });

   Firestore.instance.collection("users").document(id).updateData({
     "photoUrl": photoUrl,
     "aboutMe": aboutMe,
     "nickname": nickname,
   }).then((data) async
   {
     await preferences!.setString("photoUrl", photoUrl);
     await preferences!.setString("nickname", nickname);
     await preferences!.setString("aboutMe", aboutMe);

     setState(() {
       isLoading = false;
     });
     Fluttertoast.showToast(msg: "Updated Successfully.");
   });
 }

  @override
  Widget build(BuildContext context)
  {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Column(
            children: <Widget>[
              //Profile Image - Avatar
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(20.0),
                child: Center(
                  child: Stack(
                    children: <Widget>[
                      (imageFileAvatar == null)
                          ? (photoUrl != "")
                          ? Material(
                             //Display already existing - old image file
                              borderRadius: const BorderRadius.all(Radius.circular(125.0)),
                        clipBehavior: Clip.hardEdge,
                             //Display already existing - old image file
                              child: CachedNetworkImage(
                                placeholder: (context, url) => Container(
                                  width: 200.0,
                                  height: 200.0,
                                  padding: const EdgeInsets.all(20.0),
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
                                  ),
                                ),
                                imageUrl: photoUrl,
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(Icons.account_circle, size: 90.0, color: Colors.grey,)
                          : Material(
                            //Display the new updated image here
                        borderRadius: const BorderRadius.all(Radius.circular(125.0)),
                            clipBehavior: Clip.hardEdge,
                            //Display the new updated image here
                        child: Image.file(
                          File(imageFileAvatar!.path),
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.cover,
                        ),
                          ),
                      IconButton(
                        icon: Icon(
                          Icons.camera_alt, size: 100.0, color: Colors.white54.withOpacity(0.3),
                        ),
                        onPressed: getImage,
                        padding: const EdgeInsets.all(0.0),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.grey,
                        iconSize: 200.0,
                      ),
                    ],
                  ),
                ),
              ),

              //Input Fields
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(padding: const EdgeInsets.all(1.0), child: isLoading ? circularProgress() : Container(),),

                  //UserName
                  Container(
                    margin: const EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
                    child: const Text(
                      "Profile Name : ",
                      style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.lightBlueAccent),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                    child: Theme(
                      data: Theme.of(context).copyWith(primaryColor: Colors.lightBlueAccent),
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: "e.g Himanshu Kumawat",
                          contentPadding: EdgeInsets.all(5.0),
                          hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                        controller: nicknameTextEditingController,
                        onChanged: (value){
                          nickname = value;
                        },
                        focusNode: nickNameFocusNode,
                      ),
                    ),
                  ),

                  //AboutMe - User Bio
                  Container(
                    margin: const EdgeInsets.only(left: 10.0, bottom: 5.0, top: 30.0),
                    child: const Text(
                      "About Me : ",
                      style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.lightBlueAccent),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                    child: Theme(
                      data: Theme.of(context).copyWith(primaryColor: Colors.lightBlueAccent),
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: "Bio here...",
                          contentPadding: EdgeInsets.all(5.0),
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        controller: aboutMeTextEditingController,
                        onChanged: (value){
                          aboutMe = value;
                        },
                        focusNode: aboutMeFocusNode,
                      ),
                    ),
                  ),
                ],
              ),

              //Update Button
              Container(
                margin: const EdgeInsets.only(top: 50.0, bottom: 1.0),
                child: MaterialButton(
                  onPressed: updateData,
                  color: Colors.lightBlueAccent,
                  highlightColor: Colors.grey,
                  splashColor: Colors.transparent,
                  textColor: Colors.white,
                  padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                  child: const Text(
                    "Update", style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),

              //LogOut Button
              Padding(
                padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                child: MaterialButton(
                  color: Colors.red,
                  onPressed: logoutUser,
                  child: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.white, fontSize: 14.0),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  //LogOut Action
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> logoutUser() async
  {
    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();

    setState(() {
      isLoading = false;
    });

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MyApp()), (
        Route<dynamic> route) => false);
  }
}

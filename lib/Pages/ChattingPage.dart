import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:chat/Widgets/FullImageWidget.dart';
import 'package:chat/Widgets/ProgressWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chat extends StatelessWidget {

  final String? receiverId;
  final String? receiverAvatar;
  final String? receiverName;

  const Chat({super.key, @required this.receiverId,
    @required this.receiverAvatar,
    @required this.receiverName,
  });

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.black,
              backgroundImage: CachedNetworkImageProvider(receiverAvatar!),
            ),
          ),
        ],
        iconTheme: const IconThemeData(
          color: Colors.white
        ),
        title: Text(
          receiverName!,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ChatScreen(receiverId: receiverId!, receiverAvatar: receiverAvatar!),
    );
  }
}

class ChatScreen extends StatefulWidget {

  final String? receiverId;
  final String? receiverAvatar;

  const ChatScreen({super.key,
    @required this.receiverId,
    @required this.receiverAvatar,
  });

  @override
  State createState() => ChatScreenState();
}


class ChatScreenState extends State<ChatScreen>
{

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  bool? isDisplaySticker;
  bool? isLoading;

  XFile? imageFile;
  String? imageUrl;

  String? chatId;
  SharedPreferences? preferences;
  String? id;
  var listMessage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNode.addListener(onFocusChange);

    isDisplaySticker = false;
    isLoading = false;

    chatId = "";

    readLocal();
  }

  readLocal() async
  {
    preferences = await SharedPreferences.getInstance();
    id = preferences!.getString("id") ?? "";

    if(id.hashCode <= widget.receiverId.hashCode)
    {
      chatId = '$id-${widget.receiverId}';
    }
    else
    {
      chatId = '${widget.receiverId}-$id';
    }
    Firestore.instance.collection("users").document(id).updateData({'chattingWith' : widget.receiverId});

    setState(() {

    });
  }


  onFocusChange()
  {
    if(focusNode.hasFocus)
      {
        //hide sticker whenever keypad appears
        setState(() {
          isDisplaySticker = false;
        });
      }
  }

  @override
  Widget build(BuildContext context)
  {
    return WillPopScope(
      onWillPop: onBackPress,
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              //Create List of Messages
              createListMessages(),

              //Show Emojis
              (isDisplaySticker! ? createStickers() : Container()),

              //Input Controllers
              createInput(),
            ],
          ),
          createLoading(),
        ],
      ),
    );
  }

  createLoading()
  {
    return Positioned(
      child: isLoading! ? circularProgress() : Container(),
    );
  }

  Future<bool> onBackPress()
  {
    if(isDisplaySticker!)
    {
      setState(() {
        isDisplaySticker = false;
      });
    } else
     {
       Navigator.pop(context);
     }

    return Future.value(false);
  }


  createStickers()
  {
    return Container(
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.grey, width: 0.5)), color: Colors.white),
      padding: const EdgeInsets.all(5.0),
      height: 180.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[

          //first Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              MaterialButton(
                onPressed: () => onSendMessage("mimi1", 2),
                child: Image.asset(
                  "images/mimi1.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              MaterialButton(
                onPressed: () => onSendMessage("mimi2", 2),
                child: Image.asset(
                  "images/mimi2.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              MaterialButton(
                onPressed: () => onSendMessage("mimi3", 2),
                child: Image.asset(
                  "images/mimi3.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),

          //2nd Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              MaterialButton(
                onPressed: () => onSendMessage("mimi4", 2),
                child: Image.asset(
                  "images/mimi4.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),

              MaterialButton(
                onPressed: () => onSendMessage("mimi5", 2),
                child: Image.asset(
                  "images/mimi5.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),

              MaterialButton(
                onPressed: () => onSendMessage("mimi6", 2),
                child: Image.asset(
                  "images/mimi6.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),

          //3rd Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              MaterialButton(
                onPressed: () => onSendMessage("mimi7", 2),
                child: Image.asset(
                  "images/mimi7.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),

              MaterialButton(
                onPressed: () => onSendMessage("mimi8", 2),
                child: Image.asset(
                  "images/mimi8.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),

              MaterialButton(
                onPressed: () => onSendMessage("mimi9", 2),
                child: Image.asset(
                  "images/mimi9.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }

  void getSticker()
  {
    focusNode.unfocus();
    setState(() {
      isDisplaySticker = !isDisplaySticker!;
    });
  }

  createListMessages()
  {
    return Flexible
    (
      child: chatId == ""
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
              ),
          )
          : StreamBuilder(
              stream: Firestore.instance.collection("messages")
                  .document(chatId).collection(chatId)
                  .orderBy("timestamp", descending: true)
                  .limit(20).snapshots(),

        builder: (context, snapshot){
                if(!snapshot.hasData)
                {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
                    ),
                  );
                }
                else
                {
                  listMessage = snapshot.data!.documents;
                  return ListView.builder(
                    padding: const EdgeInsets.all(10.0),
                    itemBuilder: (context, index) => createItem(index, snapshot.data!.documents[index]),
                    itemCount: snapshot.data!.documents.length,
                    reverse: true,
                    controller: listScrollController,
                  );
                }
        },
      ),
    );
  }

  bool isLastMsgLeft(int index)
  {
    if((index>0 && listMessage != null && listMessage[index-1]["idFrom"]==id) || index == 0)
    {
      return true;
    }
    else
    {
      return false;
    }
  }

  bool isLastMsgRight(int index)
  {
    if((index>0 && listMessage != null && listMessage[index-1]["idFrom"]!=id) || index == 0)
    {
      return true;
    }
    else
    {
      return false;
    }
  }

  Widget createItem(int index, DocumentSnapshot document)
  {
    //My message - Right Side
    if(document["idFrom"] == id)
    {
      return Row(
        mainAxisAlignment:  MainAxisAlignment.end,
        children: <Widget>[
          document["type"] == 0

              //Text Msg
              ? Container(
                  padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                width: 200.0,
                decoration: BoxDecoration(color: Colors.lightBlueAccent, borderRadius: BorderRadius.circular(8.0)),
                margin: EdgeInsets.only(bottom: isLastMsgRight(index) ? 20.0 : 10.0, right: 10.0),
                  child: Text(
                    document["content"],
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                  ),
              )

              //Image Msg
              : document["type"] == 1
              ? Container(
                  margin: EdgeInsets.only(bottom: isLastMsgRight(index) ? 20.0 : 10.0, right: 10.0),
                  child: MaterialButton(
                    child: Material(
                      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                      clipBehavior: Clip.hardEdge,
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          width: 200.0,
                          height: 200.0,
                          padding: const EdgeInsets.all(70.0),
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          ),
                          child: const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
                          ),
                        ),
                        errorWidget: (context, url, error) => Material(
                          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                          clipBehavior: Clip.hardEdge,
                          child: Image.asset("images/img_not_available.jpeg", width: 200.0, height: 200.0, fit: BoxFit.cover,),
                        ),
                        imageUrl: document["content"],
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    onPressed: ()
                    {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => FullPhoto(url: document["content"])
                      ));
                    },
                  ),
              )

              //Sticker-emoji Msg
              : Container(
                  margin: EdgeInsets.only(bottom: isLastMsgRight(index) ? 20.0 : 10.0, right: 10.0),
                  child: Image.asset(
                    "images/${document['content']}.gif",
                    width: 100.0,
                    height: 100.0,
                    fit: BoxFit.cover,
                  ),
              ),
        ],
      );
    }
    //Receiver messages - Left Side
    else
    {
      return Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                isLastMsgLeft(index)
                    ? Material(
                    //display receiver profile image
                      borderRadius: const BorderRadius.all(Radius.circular(18.0),
                  ),
                  clipBehavior: Clip.hardEdge,
                    //display receiver profile image
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          width: 35.0,
                          height: 35.0,
                          padding: const EdgeInsets.all(10.0),
                          child: const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
                          ),
                        ),
                        imageUrl: widget.receiverAvatar!,
                        width: 35.0,
                        height: 35.0,
                        fit: BoxFit.cover,
                      ),
                )
                    : Container(width: 35.0,),

                //display Messages
                document["type"] == 0

                //Text Msg
                    ? Container(
                  padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8.0)),
                  margin: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    document["content"],
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
                  ),
                )

                //Image Msg
                    : document["type"] == 1
                    ? Container(
                  margin: const EdgeInsets.only(left: 10.0),
                  child: MaterialButton(
                    child: Material(
                      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                      clipBehavior: Clip.hardEdge,
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          width: 200.0,
                          height: 200.0,
                          padding: const EdgeInsets.all(70.0),
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          ),
                          child: const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
                          ),
                        ),
                        errorWidget: (context, url, error) => Material(
                          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                          clipBehavior: Clip.hardEdge,
                          child: Image.asset("images/img_not_available.jpeg", width: 200.0, height: 200.0, fit: BoxFit.cover,),
                        ),
                        imageUrl: document["content"],
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    onPressed: ()
                    {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => FullPhoto(url: document["content"])
                      ));
                    },
                  ),
                )

                //Sticker-emoji Msg
                    : Container(
                  margin: const EdgeInsets.only(left: 10.0),
                  child: Image.asset(
                    "images/${document['content']}.gif",
                    width: 100.0,
                    height: 100.0,
                    fit: BoxFit.cover,
                  ),
                ),

              ],
            ),

            //Msg time
            isLastMsgLeft(index)
                ? Container(
                    margin: const EdgeInsets.only(left: 50.0, top: 50.0, bottom: 5.0),
                    child: Text(
                      DateFormat("dd MMMM, yyyy - hh:mm:aa")
                          .format(DateTime.fromMillisecondsSinceEpoch(int.parse(document["timestamp"]))),
                      style: const TextStyle(color: Colors.grey, fontSize: 12.0, fontStyle: FontStyle.italic),
                    ),
                )
                : Container()
          ],
        ),
      );
    }
  }

  createInput()
  {
    return Container(
      width: double.infinity,
      height: 50.0,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey,
            width: 0.5,
          )
        ),
        color: Colors.white,
      ),
      child: Row(
        children: <Widget>[
          //Pick Image Icon Button
          Material(
            color: Colors.white,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: const Icon(Icons.image),
                color: Colors.lightBlueAccent,
                onPressed: getImage,
              ),
            ),
          ),

          //Emoji Icon Button
          Material(
            color: Colors.white,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: const Icon(Icons.face),
                color: Colors.lightBlueAccent,
                onPressed: getSticker,
              ),
            ),
          ),

          //Text Field
          Flexible(
            child: TextField(
              style: const TextStyle(
                color: Colors.black, fontSize: 15.0,
              ),
              controller: textEditingController,
              decoration: const InputDecoration.collapsed(
                  hintText: "write here...",
                hintStyle: TextStyle(color: Colors.grey),
              ),
              focusNode: focusNode,
            ),
          ),

          //Send Message Icon Button
          Material(
            color: Colors.white,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: const Icon(Icons.send),
                color: Colors.lightBlueAccent,
                onPressed: () => onSendMessage(textEditingController.text, 0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onSendMessage(String contentMsg, int type)
  {
    //type = 0 its text msg
    //type = 1 its imageFile
    //type = 2 sticker-emoji-gifs

    if(contentMsg != "")
    {
        textEditingController.clear();

        var docRef = Firestore.instance.collection("messages").document(chatId)
            .collection(chatId).document(DateTime.now().millisecondsSinceEpoch.toString());

        Firestore.instance.runTransaction((transaction) async
        {
          await transaction.set(docRef, {
            "idFrom" : id,
            "idTo" : widget.receiverId,
            "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
            "content" : contentMsg,
            "type" : type,
          },);
        });
        listScrollController.animateTo(0.0, duration: const Duration(microseconds: 300), curve: Curves.easeOut);
    }
    else
    {
      Fluttertoast.showToast(msg: "Empty Message. can not be send.");
    }

  }

  Future getImage() async
  {
    imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(imageFile != null)
    {
      isLoading = true;
    }
    uploadImageFile();
  }

  Future uploadImageFile() async
  {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference storageReference = FirebaseStorage.instance.ref().child("Chat Images").child(fileName);

    StorageUploadTask storageUploadTask = storageReference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await storageUploadTask.onComplete;

    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl){
      imageUrl = downloadUrl;
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl!, 1);
      });
    }, onError: (error){
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "Error : $error");
    });
  }
}

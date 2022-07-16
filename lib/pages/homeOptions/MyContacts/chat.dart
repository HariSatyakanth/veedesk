import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/Utiles/database.dart';
import 'package:newproject/Utiles/message_tile.dart';


class Chat extends StatefulWidget {
  final String chatRoomId;

  Chat({this.chatRoomId});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  Stream<QuerySnapshot> chats;
  TextEditingController messageEditingController = new TextEditingController();
  ScrollController _controller = ScrollController();

  Widget chatMessages(){
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot){
        return snapshot.hasData ?  ListView.builder(
          controller: _controller,
          itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
              // return MessageTile(
              //   message: snapshot.data.documents[index].data["message"],
              //   sendByMe: Constants.userName == snapshot.data.documents[index].data["sendBy"],
              // );
          return MessageTile(
                message: snapshot.data.documents[index].data["message"],
                sender: snapshot.data.documents[index].data["sender"],
                profilePic: snapshot.data.documents[index].data["profile"],
                timestamp: snapshot.data.documents[index].data["time"],
                sentByMe: Constants.userId == snapshot.data.documents[index].data["userId"],
              );
            }) : Container();
      },
    );
  }

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "type": 1,
        "message": messageEditingController.text,
        "sender": Constants.userName,
        'time': DateTime.now().millisecondsSinceEpoch,
        'userId': Constants.userId,
        'profile':
        "http://conferenceoeh.com/wp-content/uploads/profile-pic-dummy.png",
      };

      DatabaseMethods().addMessage(widget.chatRoomId, chatMessageMap);
      setState(() {
        messageEditingController.text = "";
      });
      Timer(Duration(milliseconds: 300),
              () => _controller.jumpTo(_controller.position.maxScrollExtent));
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(
        Duration(milliseconds: 500),
            () => _controller
            .jumpTo(_controller.position.maxScrollExtent));
    DatabaseMethods().getChats(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Column(
           children: <Widget>[
            Expanded(
              child: Container(
                child: chatMessages()),
            ),
              Container(alignment: Alignment.bottomCenter,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                color: Color(0xFF212121),
                color: Colors.brown[50],
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: messageEditingController,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          decoration: InputDecoration(
                              hintText: "Message ...",
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                              border: InputBorder.none
                          ),
                        )),
                    SizedBox(width: 16,),
                    GestureDetector(
                      onTap: () {
                        addMessage();
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF546E7A),
                                    const Color(0xFF546E7A)
                                  ],
                                  begin: FractionalOffset.topLeft,
                                  end: FractionalOffset.bottomRight
                              ),
                              borderRadius: BorderRadius.circular(40)
                          ),
                          padding: EdgeInsets.all(12),
                          child: Image.asset("Images/Send (1).png",
                            height: 25, width: 25,)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
    );
  }

 Widget appBarMain(BuildContext context) {
    return AppBar(
      title: Image.asset(
        "images/launcher.png",
        height: 40,
      ),
      elevation: 0.0,
      centerTitle: false,
    );
  }

}


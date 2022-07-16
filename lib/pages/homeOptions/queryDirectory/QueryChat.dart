import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/Utiles/database.dart';
import 'package:newproject/Utiles/message_tile.dart';
import 'package:newproject/Utiles/strings.dart';

class QueryChatPage extends StatefulWidget {
  QueryChatPage(this.documentID, this.status, this.message, this.time);

  String documentID;
  String status;
  String message;
  int time;

  @override
  _QueryChatPageState createState() => _QueryChatPageState();
}

class _QueryChatPageState extends State<QueryChatPage> {
  Stream<QuerySnapshot> _chats;
  TextEditingController messageEditingController = new TextEditingController();
  ScrollController _controller = ScrollController();
  bool _isOn = false;

  Widget _chatMessages() {
    return StreamBuilder(
      stream: _chats,
      builder: (context, snapshot) {
        //   print(snapshot.data.documents[0].data["message"]);
        return snapshot.hasData
            ? ListView.builder(
                controller: _controller,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                    message: snapshot.data.documents[index].data["message"],
                    sender: snapshot.data.documents[index].data["sender"],
                    profilePic : "http://conferenceoeh.com/wp-content/uploads/profile-pic-dummy.png",
                    timestamp: snapshot.data.documents[index].data["time"],
                    sentByMe: Constants.userId ==
                        snapshot.data.documents[index].data["userId"],
                  );
                })
            : Container();
      },
    );
  }

  _sendMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageEditingController.text,
        "sender": Constants.userName,
        'time': DateTime.now().millisecondsSinceEpoch,
        'userId': Constants.userId,
      };

      DatabaseMethods().addMessageQuery(widget.documentID, chatMessageMap);

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
    Timer(Duration(milliseconds: 500),
        () => _controller.jumpTo(_controller.position.maxScrollExtent));
    print(widget.documentID);
    DatabaseMethods().getQueryChats(widget.documentID).then((val) {
      // print(val);
      setState(() {
        if(widget.status == 'open'){
          _isOn=false;
        }else{
          _isOn=true;
        }
        _chats = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize:
          Size.fromHeight(Constants().containerHeight(context) * 0.08),
          child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
              ),
              child: AppBar(
                backgroundColor: ColorsUsed.baseColor,
                  centerTitle: true, title: Text("My Query"), actions: [
                Switch(
                    value: _isOn,
                    onChanged: (val) {
                      if (_isOn) {
                        Constants.showToast(
                            "Query is closed by you.Please connect admin to resume");
                      } else {
                        openSignOutDialog();
                      }
                    }),
              ])
          )
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 100,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              color: Colors.blueGrey[100],
              child: Center(
                  child: Text(

                widget.message+"\n"+_ConvertTime(widget.time),textAlign: TextAlign.center,

                style: Constants().txtStyleFont16(ColorsUsed.baseColor, 15.0),
              )),
            ),
          ),
          Expanded(
            child: Container(child: _chatMessages()),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              color: Colors.grey[700],
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageEditingController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: "Send a message ...",
                          hintStyle: TextStyle(
                            color: Colors.white38,
                            fontSize: 16,
                          ),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  GestureDetector(
                    onTap: () {
                      if(_isOn){
                        setState(() {
                          messageEditingController.text="";
                        });
                        Constants.popUpForAlertDialogs(context,
                            "Query is closed by you.Please connect admin to resume","Message");
                      }else {
                        _sendMessage();
                      }
                    },
                    child: Container(
                      height: 40.0,
                      width: 40.0,
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(40)),
                      child:
                          Center(child: Icon(Icons.send, color: Colors.white)),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void toggle() {
    Firestore.instance
        .collection('queryAll')
        .document(Constants.userId)
        .collection('MyQuery')
        .document(widget.documentID)
        .updateData({
      'status': 'close',
    }).then((value) => {
              setState(() => _isOn = !_isOn),
              Constants.showToast("Query Closed")
            });
  }

  openSignOutDialog() async {
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Container(
              child: Text("Are You Sure to close this Query ?"),
            ),
            actions: <Widget>[
              new FlatButton(
                  child: const Text('Dismiss'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new FlatButton(
                  child: const Text('Close Query'),
                  onPressed: () {
                    Navigator.pop(context);
                    toggle();
                  })
            ],
          );
        });
  }

  String _ConvertTime(int timestamp) {
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
    var startTime = DateTime(date.year, date.month, date.day,date.hour,date.minute);
    var currentTime = DateTime.now();
    var diff = currentTime.difference(startTime).inDays;
    var diff1 = currentTime.difference(startTime).inHours;
    var diff2 = currentTime.difference(startTime).inMinutes;
    if(diff1==0){
      return diff2.toString()+ " min ago";
    }else if(diff == 0){
      return diff1.toString()+ " hours ago";
    }else{
      return diff.toString()+ " days ago";
    }
  }

}

import 'package:flutter/material.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/constants.dart';

class MessageTile extends StatelessWidget {
  final String message;
  final String sender;
  final String profilePic;
  final int timestamp;
  final bool sentByMe;

  MessageTile(
      {this.message,
      this.sender,
      this.profilePic,
      this.timestamp,
      this.sentByMe});

  @override
  Widget build(BuildContext context) {
    var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp);

    return Container(padding: EdgeInsets.fromLTRB(5.0, 0, 0, 0),
      child: Column(
        crossAxisAlignment: sentByMe ?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
           /*!sentByMe? CircleAvatar(radius: 15.0,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.network(profilePic,
                    fit: BoxFit.cover,)),) : SizedBox(height: 0,)*/
            Container(
              padding: EdgeInsets.only(
                  top: 4,
                  bottom: 4,
                  left: sentByMe ? 0 : 24,
                  right: sentByMe ? 24 : 0),
              alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Column(crossAxisAlignment: sentByMe ?CrossAxisAlignment.end:CrossAxisAlignment.start,
                children: [
                  !sentByMe ?Row(
                    children: [
                      CircleAvatar(radius: 15.0,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.network(profilePic,
                              fit: BoxFit.cover,)),),
                      Text(sender.toUpperCase()+", "+Constants.convertTimeStamp(timestamp),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 11.0,
                              fontWeight: FontWeight.w500,
                              color: ColorsUsed.baseColor,
                              letterSpacing: -0.5)),
                    ],
                  ):Text(Constants.convertTimeStamp(timestamp),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w500,
                          color: ColorsUsed.baseColor,
                          letterSpacing: -0.5)),
                  SizedBox(height: 7.0),
                  Container(
                    margin: sentByMe
                        ? EdgeInsets.only(left: 30)
                        : EdgeInsets.only(right: 30),
                    padding:
                        EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
                    decoration: BoxDecoration(
                      borderRadius: sentByMe
                          ? BorderRadius.only(
                              topLeft: Radius.circular(23),
                              topRight: Radius.circular(23),
                              bottomLeft: Radius.circular(23))
                          : BorderRadius.only(
                              bottomLeft: Radius.circular(23),
                              topRight: Radius.circular(23),
                              bottomRight: Radius.circular(23)),
                      color: sentByMe ? Colors.blue[50] : Colors.white,
                    ),
                    child: Text(message,
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 13.0, color: Colors.black54)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

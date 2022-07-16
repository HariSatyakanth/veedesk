import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:newproject/Utiles/constants.dart';

class DatabaseMethods {
  Future<void> addUserInfo(userData) async {
    Firestore.instance.collection("users").add(userData).catchError((e) {
      print(e.toString());
    });
  }

  getChats(String chatRoomId) async {
    return Firestore.instance
        .collection("chatRoom")
        .document(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }
  Future<void> addMessage(String chatRoomId, chatMessageData){
    Firestore.instance.collection("chatRoom")
        .document(chatRoomId)
        .collection("chats")
        .add(chatMessageData).catchError((e){
      print(e.toString());
    });
  }

  // send message
  sendMessage(String groupId, chatMessageData) {
    Firestore.instance
        .collection('groupChat')
        .document(groupId)
        .collection('messages')
        .add(chatMessageData);

    // Firestore.instance.collection('groupChat').document(groupId).updateData({
    //   'recentMessage': chatMessageData['message'],
    //   'recentMessageSender': chatMessageData['sender'],
    //   'recentMessageTime': chatMessageData['time'].toString(),
    // });
  }

  addQuery(queryData) {
    Firestore.instance
        .collection('queryAll')
        .document(Constants.userId)
        .collection('MyQuery')
        .add(queryData);
  }
  Future<bool> addChatRoom(chatRoom, chatRoomId) {
    Firestore.instance
        .collection("chatRoom")
        .document(chatRoomId)
        .setData(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  addMessageQuery(String groupId,chatMessageData) {
    Firestore.instance
        .collection('queryAll')
        .document(Constants.userId)
        .collection('MyQuery')
        .document(groupId)
        .collection('message')
        .add(chatMessageData);
  }

  getGroupChats(String groupId) async {
    return Firestore.instance
        .collection('groupChat')
        .document(groupId)
        .collection('messages')
        .orderBy('time')
        .snapshots();
  }
  getQueryChats(String groupId) async {
    return Firestore.instance
        .collection('queryAll')
        .document(Constants.userId)
        .collection('MyQuery')
        .document(groupId)
        .collection('message')
        .orderBy('time')
        .snapshots();
  }

  getUserChats(String itIsMyName) async {
    return await Firestore.instance
        .collection("chatRoom")
        .where('users', arrayContains: itIsMyName)
        .snapshots();
  }

}

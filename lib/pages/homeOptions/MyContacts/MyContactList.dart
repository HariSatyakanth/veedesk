import 'package:flutter/material.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/Images_path.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/Utiles/database.dart';
import 'package:newproject/Utiles/strings.dart';
import 'package:newproject/Utiles/util.dart';
import 'package:newproject/models/MyContactModal.dart';
import 'package:newproject/pages/homeOptions/MyContacts/AddContacts.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:newproject/pages/homeOptions/MyContacts/chat.dart';
import 'package:newproject/pages/homeOptions/MyContacts/chatDialog.dart';

class MyContact extends StatefulWidget {
  @override
  _MyContactState createState() => _MyContactState();
}

class _MyContactState extends State<MyContact> {
  List<MyContactModal> myContactList;
  var responseList;
  var _response;
  bool _loading = false;
  int _activeElevationId = -1;
  DatabaseMethods databaseMethods = new DatabaseMethods();
  @override
  void initState() {
    _loading = true;
    myContactList = new List<MyContactModal>();
    getContactAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: _appBarOptions(),
        /*floatingActionButton: FloatingActionButton(
          tooltip: "Add New Contact",
          onPressed: () {
            Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChatRoom()))
                .then((value) {
              if (value) {
                setState(() {
                  _loading = true;
                  myContactList.clear();
                });
                getContactAPI();
              }
            });
          },
          child: Icon(Icons.add),
        ),*/
        body:  _loading?Center(child: Constants().spinKit):Container(
            padding: EdgeInsets.fromLTRB(25.0, 20.0, 20.0, 25.0),
            child: _cardOfContacts()));
  }

  //AppBAr
  _appBarOptions() {
    return PreferredSize(
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(30.0),
          bottomLeft: Radius.circular(30.0),
        ),
        child: AppBar(
          backgroundColor: ColorsUsed.baseColor,
          leading: Constants().backButton(context),
          centerTitle: true,
          title: Row(
            children: [SizedBox(width: 35.0),
              Image.asset(Img.myOfficeImage,width: 20.0,),
              SizedBox(width: 10.0),
              Text(
                "My Contacts",
                style: Constants().txtStyleFont16(ColorsUsed.whiteColor, 20.0),
              ),
            ],
          ),
      /*    actions: [
            IconButton(
                icon: Image.asset(
                  "Images/home/Group 1.png",
                  width: 25.0,
                ),
                onPressed: () {
                  print('search');
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => SearchPage(1)));
                }),
            SizedBox(
              width: 20.0,
            )
          ]*/
        ),
      ),
      preferredSize:
          Size.fromHeight(Constants().containerHeight(context) * 0.08),
    );
  }


  _cardOfContacts() {
    if (myContactList.length > 0) {
      //    List<NetworkImage> propertyPic = new List<NetworkImage>();
      return ListView.builder(
          itemCount: myContactList.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    if(_activeElevationId == index) {
                      setState(() {
                        _activeElevationId = -1;
                      });
                    }else{
                      setState(() {
                        _activeElevationId = index;
                      });
                    }
                  },
                  child: Card(
                    elevation:
                    _activeElevationId == index ? 20.0 : 0.0,
                    shadowColor: ColorsUsed.baseColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0)),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.0),
                        Row(
                          children: [SizedBox(width: 15),
                            new Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                        fit: BoxFit.fill,
                                        image: new NetworkImage(myContactList[index].imageUrl)
                                    )
                                )),SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    children: [SizedBox(width: 10),
                                      Text(myContactList[index].userName, style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          color: ColorsUsed.baseColor)),
                                    ],
                                  ),
                                  Row(
                                    children: [SizedBox(width: 10),
                                      Text(
                                        myContactList[index].description,
                                        style: Constants().txtStyleFont16(
                                            Colors.grey[500], 12.0),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),SizedBox(width: 10),
                            Icon(_activeElevationId == index?Icons.arrow_drop_up:Icons.arrow_drop_down)
                            ,SizedBox(width: 15),],
                        ),
                        _activeElevationId == index?
                        _contactDetails(index):Container(),
                        SizedBox(height: 20.0), ],
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
              ],
            );
          });
    } else {
      return Center(
        child: Text(
          "No data found",
          style: Constants().txtStyleFont16(Colors.black54, 25.0),
        ),
      );
    }
  }
  _contactDetails(int index) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(width: 5),
            myContactList[index].isWhatsApp?InkWell(
              onTap: () {
                //whatsApp
               // Util.whatsAppOpen();
                List<String> users = [myContactList[index].userName,Constants.userName];

                String chatRoomId =
                getChatRoomId(myContactList[index].userName,Constants.userName);

                Map<String, dynamic> chatRoom = {
                  "users": users,
                  "chatRoomId": chatRoomId,
                };

                databaseMethods.addChatRoom(chatRoom, chatRoomId);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Chat(
                          chatRoomId: chatRoomId,
                        )));



              },
              child: CircleAvatar(radius: 30.0,
                backgroundColor: Colors.white,
                child: Image.asset(Img.contactChatImage),
              ),
            ):Container(),
            SizedBox(width: 5),
            myContactList[index].whatsAppNumber==null?
            InkWell(
              onTap: () {
                //message
                Util.launchCaller("sms:",myContactList[index].contactNum);
              },
              child: CircleAvatar(radius: 30.0,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.message_sharp,
                ),
              ),
            ):InkWell(
              onTap: () {print(myContactList[index].whatsAppNumber);
                //call
                Util.whatsAppOpen(myContactList[index].whatsAppNumber);
              },
              child: CircleAvatar(radius: 30.0,
                backgroundColor: Colors.white,
                child: Image.asset(Img.whatsAppImage),
              ),
            ),
            SizedBox(width: 5),
            InkWell(
              onTap: () {
                //call
                Util.launchCaller("tel:",myContactList[index].contactNum);
              },
              child: CircleAvatar(radius: 30.0,
                backgroundColor: Colors.white,
                child: Icon(
                   Icons.call_rounded,
                ),
              ),
            ),
            /*SizedBox(width: 5),
            InkWell(
              onTap: () {
                //message
                Util.launchCaller("sms:",myContactList[index].contactNum);
              },
              child: CircleAvatar(radius: 30.0,
                backgroundColor: Colors.white,
                child: Icon(
                   Icons.message_sharp,
                ),
              ),
            ),*/
            SizedBox(width: 5),
            InkWell(
              onTap: () {
                //email
                Util.launchCaller("mailto:",myContactList[index].email);

              },
              child: CircleAvatar(radius: 30.0,
                backgroundColor: Colors.white,
                child: Icon(
                   Icons.email,
                ),
              ),
            )

          ],
        ),
        SizedBox(height: 20.0),
      ],
    );
  }

  Future<void> getContactAPI() async {
    try {
      await http
          .get(
              "${Constants.BaseUrl}action=contactList")
          .then((res) {
        print(res.body);
        print("status${res.body}");
        setState(() {
          _loading = false;

          _response = json.decode(res.body);
          responseList = _response["contactList"];
        });
        final int statusCode = res.statusCode;

        print(_response);
        if (statusCode == 200) {
          print("check 200${_response["success"]}");
          if (_response["success"] == "1") {
            for (int i = 0; i < responseList.length; i++) {
              //   imgStr.split(",").map((String text) => propertyPic.add(NetworkImage(text))).toList();
              setState(() {
                if(responseList[i]["userId"] != Constants.userId) {
                  myContactList.add(MyContactModal(
                      id: responseList[i]["userId"],
                      contactNum: responseList[i]["Contact_Number"],
                      whatsAppNumber: responseList[i]["Whatsapp_Number"],
                      description: responseList[i]["description"],
                      email: responseList[i]["Email_address"],
                      imageUrl: Constants.USER_IMAGE,
                      isVisible: false,
                      isWhatsApp: true,
                      userName: responseList[i]["Full_Name"]));
                }
              });
            }
          } else {
            setState(() {
              _loading = false;
            });
            Constants.showToast(S.SOME_WRONG);
          }
        }
      });
    } on SocketException catch (_) {
      print('not connected');
      Constants().noInternet(context);
    } catch (e) {
      setState(() {
        _loading = false;
      });
    }
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }
}

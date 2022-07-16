import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/Images_path.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/pages/homeOptions/queryDirectory/Add_query.dart';
import 'package:newproject/pages/homeOptions/queryDirectory/QueryChat.dart';
import 'package:newproject/pages/homeOptions/queryDirectory/QuerySearch.dart';

class MyQueries extends StatefulWidget {
  @override
  _MyQueriesState createState() => _MyQueriesState();
}

class _MyQueriesState extends State<MyQueries> with WidgetsBindingObserver {
  int _colorId = 0, _activeElevationId = -1;
  String dummy =
      "Lorem Ipsum is simply dummy text of the printing and typesetting";
  Stream<QuerySnapshot> _queries;
  ScrollController _controller = ScrollController();
  List<DocumentSnapshot> documentList;
  String userName="";
  bool _loading=false;

  @override
  void initState() {
    documentList = new List();
    setState(() {
      _loading=true;
    });
    if(Constants.userName.length > 10){
      userName=Constants.userName.substring(0,9)+"..";
    }else{
      userName=Constants.userName;
    }

    getChatData(0);

  }

  @override
  Future<void> didChangeAppLifeCycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        getChatData(0);
        break;
      case AppLifecycleState.inactive:
        getChatData(0);
        break;
      case AppLifecycleState.paused:
        getChatData(0);
        break;
      case AppLifecycleState.detached:
        getChatData(0);
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Widget _chatMessages() {
    if (documentList.length > 0) {
      return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: documentList.length,
          itemBuilder: (BuildContext context, int index) {
            String subject = documentList[index].data["subject"];
            String message = documentList[index].data["message"];
            String status = documentList[index].data["status"];
            int time = documentList[index].data["time"];
            return GestureDetector(
              onTap: ()  {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => QueryChatPage(
                            documentList[index].documentID,
                            status,
                            message,
                            time))).then((value) {
                    getChatData(_colorId);
                    _loading=true;
                });
              },

              child: Column(
                children: [
                  Card(elevation: 10.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    color: Color(0xffF0EFFF),
                    child: Column(
                      children: [
                        SizedBox(height: 10.0),
                        Row(
                          children: [
                            SizedBox(width: 20.0),
                            CircleAvatar(
                              backgroundColor: ColorsUsed.baseColor,
                              child: Text(
                                "${subject.substring(0, 1).toUpperCase()}",
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                            ),
                            SizedBox(width: 20.0),
                            Expanded(
                                child: Text(
                              subject,
                              style: Constants()
                                  .txtStyleFont16(ColorsUsed.baseColor, 15.0),
                            )),
                            SizedBox(width: 20.0),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          children: [
                            Expanded(
                              child: _details(userName, Icons.person),
                            ),
                            Expanded(
                              child: _details(Constants.convertTimeStamp(time), Icons.alarm),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                ],
              ),
            );
          });
    } else {
        return Center(
            child: Text(
              "No query found",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30.0),
            ));
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF9F9F9),
        appBar: _appBarOptions(),
        body: _loading?Center(child: Constants().spinKit):SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 20.0),
          physics: ScrollPhysics(),
          child: Column(
            children: <Widget>[
              _cardWithButton(),
              SizedBox(height: 20.0),
              _chatMessages(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddQuery()));
          },
          tooltip: 'Add Query',
          child: Icon(
            Icons.add,
            size: 35.0,
          ),
        ));
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
                "My Queries",
                style: Constants().txtStyleFont16(ColorsUsed.whiteColor, 20.0),
              ),
            ],
          ),
          actions: [
            IconButton(
                icon: Image.asset(
                  "Images/home/Group 1.png",
                  width: 25.0,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => QuerySreach()));
                }),
            SizedBox(
              width: 20.0,
            )
          ],
        ),
      ),
      preferredSize:
          Size.fromHeight(Constants().containerHeight(context) * 0.08),
    );
  }

  //Buttons Ui
  _cardWithButton() {
    return Card(
      elevation: 5.0,
      margin: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      child: Row(
        children: [
          Expanded(child: _button("Active", 0)),
          Expanded(child: _button("Closed", 1))
        ],
      ),
    );
  }

  //button
  _button(String title, int id) {
    return SizedBox(
      height: Constants().containerHeight(context) / 16,
      child: RaisedButton(
        onPressed: () {
          _clickOperation(title);
        },
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        elevation: 0.0,
        color: _colorId == id ? ColorsUsed.baseColor : ColorsUsed.whiteColor,
        child: Text(title,
            style: TextStyle(
                fontSize: 16.0,
                color: _colorId == id ? ColorsUsed.whiteColor : Colors.black,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w500)),
      ),
    );
  }

  _clickOperation(String title) {
    switch (title) {
      case "Active":
        getChatData(0);
        setState(() {
          _colorId = 0;
        });
        break;
      case "Closed":
        getChatData(1);
        setState(() {
          _colorId = 1;
        });
    }
  }

  //details
  _details(String title, IconData _iconData) {
    return Row(
      children: [
        SizedBox(width: 20.0),
        Icon(
          _iconData,
          color: Colors.grey[500],
          size: 14.0,
        ),
        SizedBox(width: 5.0),
        Expanded(child: Text(title, style: Constants().txtStyleFont16(Colors.grey[500], 13.0))),
        SizedBox(width: 20.0),
      ],
    );
  }

  void getChatData(int i) {
    documentList.clear();
    if (i == 0) {
      Firestore.instance
          .collection("queryAll")
          .document(Constants.userId)
          .collection("MyQuery")
          .where("status", isEqualTo: 'open')
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        setState(() {
          documentList = snapshot.documents;
          _loading=false;
        });
      });
    } else {
      Firestore.instance
          .collection("queryAll")
          .document(Constants.userId)
          .collection("MyQuery")
          .where("status", isEqualTo: 'close')
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        setState(() {
          documentList = snapshot.documents;
          _loading=false;
        });
      });
    }
  }


}

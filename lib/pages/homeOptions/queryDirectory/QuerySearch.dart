import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:text_tools/text_tools.dart';

import 'QueryChat.dart';


class QuerySreach extends StatefulWidget {
  @override
  _QuerySreachState createState() => _QuerySreachState();
}

class _QuerySreachState extends State<QuerySreach> {

  TextEditingController searchController = TextEditingController();
  List<DocumentSnapshot> documentList;
  List<DocumentSnapshot> searchSnap;
  String searchStr="",userName="";
  String textNoData="Search List is empty";

  @override
  void initState() {
    if(Constants.userName.length > 10){
      userName=Constants.userName.substring(0,9)+"..";
    }else{
      userName=Constants.userName;
    }

    searchSnap = new List();
    documentList = new List();
    getData("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: ColorsUsed.baseColor,
        title: Text("Query Search"),),
      body: SingleChildScrollView(
        child: Container(padding: EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 20.0),
          child: Column(
            children: [
              _searchBar(),
              SizedBox(height: 50.0),
              showSearchList(),

            ],
          ),
        ),
      ),
    );
  }
  _searchBar() {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xFFCFD8DC),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          contentPadding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
          hintText: "Search...",
          prefixIcon: Icon(Icons.search)
      ),
      onChanged: (value){
       searchStr=searchController.text;
       searchStr=TextTools.toUppercaseFirstLetter(text: searchStr);
        print(searchStr);
        getData(searchStr);
      },
    );
  }
  // String capitalize() {
  //   return "${this[0].toUpperCase()}${this.substring(1)}";
  // }
  Widget showSearchList() {
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
              onTap: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => QueryChatPage(
                            documentList[index].documentID,
                            status,
                            message,
                            time)))
              },

              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                color: Colors.blueGrey[100],
                child: Column(
                  children: [
                    SizedBox(height: 20.0),
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
                    SizedBox(height: 20.0),
                  ],
                ),
              ),
            );
          });
    }
    else {
      return Center(
          child: Text(
            textNoData,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30.0),
          ));
    }
  }
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
        Text(title, style: Constants().txtStyleFont16(Colors.grey[500], 12.0)),
        SizedBox(width: 10.0),
      ],
    );
  }
  void getData(String searchName) {
    print(searchName);
    Firestore.instance
        .collection("queryAll")
        .document(Constants.userId)
        .collection("MyQuery")
      .where('subject', isGreaterThanOrEqualTo: searchName)
      .where('subject', isLessThan: searchName +'z')
        .getDocuments()
        .then((value) => addingData(value));
  }

  addingData(QuerySnapshot value) {
    setState(() {
      documentList.clear();
      documentList=value.documents;
      if(documentList.length == 0){
        textNoData="No Result found";
        Constants.showToast(textNoData);
      }
    });
  }

}

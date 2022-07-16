import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newproject/Interfaces/callBackWidget.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/Images_path.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/models/MyLeadModel.dart';
import 'package:newproject/pages/SearchPage.dart';
import 'package:newproject/pages/homeOptions/Leads/Lead_details.dart';
import 'package:newproject/pages/homeOptions/Leads/LeadsInsert.dart';


class MyLeads extends StatefulWidget {
  @override
  _MyLeadsState createState() => _MyLeadsState();
}

class _MyLeadsState extends State<MyLeads> {
  DateTime now;
  DateFormat formatter = DateFormat('EE,dd-MMM-yyyy');
  String dateToday;
  int _colorId = 0, _activeElevationId = -1;
  var responseList, activeData, closedData;
  bool _loader;
  String _fileName;
  List<AddLead> activeLead;
  List<AddLead> closeLead;

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    dateToday = formatter.format(now);
    activeLead = new List<AddLead>();
    closeLead = new List<AddLead>();
    getLeads();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => LeadsInsert())).then((value) => getLeads());
          },
          child: Icon(Icons.add),
        ),
        appBar: _appBarOptions(),
        body: _loader?Center(child: Constants().spinKit):Container(
                padding: EdgeInsets.fromLTRB(25.0, 20.0, 20.0, 25.0),
                child: Column(
                  children: [
                    _cardWithButton(),
                    SizedBox(height: 30.0),
                    _cardOfLeads()
                  ],
                )));
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
                "My Leads",
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
                  print('search');
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SearchPage(1)));
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
        _loader = true;
        Timer(Duration(seconds: 1), () {
          setState(() {
            _loader = false;
          });
        });
        setState(() {
          _colorId = 0;
        });
        break;
      case "Closed":
        _loader = true;
        Timer(Duration(seconds: 1), () {
          setState(() {
            _loader = false;
          });
        });
        setState(() {
          _colorId = 1;
        });
    }
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

  //cards leads
  _cardOfLeads() {
    print(_colorId);
    if (_colorId == 0) {
      if (activeLead.length > 0) {
      return  _loader?Center(
        child: Constants().spinKit) : Expanded(
         child: ListView.builder(
            itemCount: activeLead.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  SizedBox(
                    height: 180.0,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _activeElevationId = index;
                        });
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>
                            LeadDetails(activeLead[index].id))).then((value) {

                                setState(() {
                                  _loader = true;
                                });getLeads();


                        });
                      },
                      child: Card(
                        elevation: _activeElevationId == index ? 20.0 : 0.0,
                        shadowColor: ColorsUsed.baseColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0)),
                        child: Row(
                          children: [
                            Container(
                              height: 150.0,
                              width: 10.0,
                              decoration: BoxDecoration(
                                  color: ColorsUsed.baseColor,
                                  borderRadius: BorderRadius.circular(5.0)),
                            ),
                            SizedBox(width: 20.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 20.0),
                                  Text(
                                      activeLead[index].name.length>40?activeLead[index].name.substring(0,40):activeLead[index].name,
                                    style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: ColorsUsed.baseColor)
                                  ),
                                  SizedBox(height: 10.0),
                                activeLead[index].discription !=null?
                                Text(
                                  activeLead[index].discription.length >80 ?
                                  activeLead[index].discription.substring(0,80)+"..":activeLead[index].discription,
                                  style: Constants()
                                      .txtStyleFont16(Colors.grey[500], 12.0),
                                ):Text("No description added yet"),
                                  SizedBox(height: 10.0),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.alarm,size: 15,
                                        color: Colors.grey[500],
                                      ),
                                      SizedBox(width: 3.0),
                                      Text("Estimate Timeline : "+activeLead[index].Estimate_Timeline.substring(0,10),
                                        style:TextStyle(fontSize: 12.0,fontWeight: FontWeight.bold,color: Colors.grey[500])
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 20.0),
                                ],
                              ),
                            ),
                            SizedBox(width: 20.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                ],
              );
            }),
      );
    }else{
     return  Center(
       child: Text("No data found",style: Constants().txtStyleFont16(Colors.black54, 25.0),),
     );
      }
    } else {
      return  _loader?Center(
          child: Constants().spinKit) : Expanded(
        child: ListView.builder(
            itemCount: closeLead.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  SizedBox(
                    height: 180.0,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _activeElevationId = index;
                        });
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>
                            LeadDetails(closeLead[index].id))).then((value) {
                          if(value == true){
                           setState(() {
                             _loader = true;
                           });getLeads();
                          }

                        });
                      },
                      child: Card(
                        elevation: _activeElevationId == index ? 20.0 : 0.0,
                        shadowColor: ColorsUsed.baseColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0)),
                        child: Row(
                          children: [
                            Container(
                              height: 150.0,
                              width: 10.0,
                              decoration: BoxDecoration(
                                  color: ColorsUsed.baseColor,
                                  borderRadius: BorderRadius.circular(5.0)),
                            ),
                            SizedBox(width: 20.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 20.0),
                                  Text(
                                      closeLead[index].name.length>40?closeLead[index].name.substring(0,40):closeLead[index].name,
                                      style:TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: ColorsUsed.baseColor)
                                  ),
                                  SizedBox(height: 10.0),
                                  closeLead[index].discription !=null?
                                  Text(
                                    closeLead[index].discription.length >80 ?
                                    closeLead[index].discription.substring(0,80)+"..":closeLead[index].discription,
                                    style: Constants()
                                        .txtStyleFont16(Colors.grey[500], 12.0),
                                  ):Text("No description added yet"),
                                  SizedBox(height: 10.0),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.alarm,size: 15,
                                        color: Colors.red[500],
                                      ),
                                      SizedBox(width: 3.0),
                                      Text(
                                       "Closed On : "+activeLead[index].Estimate_Timeline.substring(0,10),
                                        style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.bold,color: Colors.red[500])
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 20.0),
                                ],
                              ),
                            ),
                            SizedBox(width: 20.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                ],
              );
            }),
      );
    }
  }

  //getLeadsLiss
  Future<dynamic> getLeads() async {
    print("${Constants.BaseUrl}action=leads&userId=${Constants.userId}");
    activeLead.clear();
    closeLead.clear();
    _loader = true;
    try {
      await http
          .get("${Constants.BaseUrl}action=leads&userId=${Constants.userId}")
          .then((res) {
        print(res.body);
        var response = json.decode(res.body);
        final int statusCode = res.statusCode;
        print(statusCode);
        if (statusCode == 200) {
          setState(() {
            _loader = false;
            responseList = response["task"];
          });

          if (response["success"] == "1") {
            print(responseList.length);
            for (int i = 0; i < responseList.length; i++) {
              var status = responseList[i]["project_status"];
              print(status);
              print(status == "Closed");

              if (status == "Closed") {
                setState(() {
                  closeLead.add(AddLead(
                      id: responseList[i]["id"],
                      name: responseList[i]["Project_Name"],
                      discription: responseList[i]["description"],
                      status: responseList[i]["project_status"],
                      Estimate_Timeline: responseList[i]["Estimate_Timeline"]
                  ));
                });
              } else {
                  setState(() {
                    activeLead.add(AddLead(
                        id: responseList[i]["id"],
                        name: responseList[i]["Project_Name"],
                        discription: responseList[i]["description"],
                        status: responseList[i]["project_status"],
                        Estimate_Timeline: responseList[i]["Estimate_Timeline"]
                    ));
                  });
              }
            }
          } else {
//            Scaffold.of(context).showSnackBar(Constants().showSnackMessage(response["message"]));
          }
        } else {
//          Scaffold.of(context).showSnackBar(Constants().showSnackMessage(response["Something went wrong !"]));
        }
      });
    } on SocketException catch (_) {
      print('not connected');
      Constants().noInternet(context);
    } catch (e) {}
  }
}

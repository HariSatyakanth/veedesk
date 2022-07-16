import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/Utiles/util.dart';
import 'package:newproject/models/LeavesModel.dart';
import 'package:newproject/pages/homeOptions/MyLeaves/AddLeave.dart';

class LeaveList extends StatefulWidget {
  @override
  _LeaveListState createState() => _LeaveListState();
}

class _LeaveListState extends State<LeaveList> {
bool _loader = true;
int _colorId = 0, _activeElevationId = -1;
List<LeavesModel> approvedLeavesList,disApprovedLeavesList,pendingLeavesList;

  @override
  void initState() {
    super.initState();
    approvedLeavesList = List<LeavesModel>();
    disApprovedLeavesList = List<LeavesModel>();
    pendingLeavesList = List<LeavesModel>();
    getLeaveList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarOptions(),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add New Contact",
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddLeave()))
              .then((value) {
            if (value) {
              setState(() {
                _loader = true;
              });
              getLeaveList();
            }
          });
        },
        child: Icon(Icons.add),
      ),
      body:  _loader?Center(child: Constants().spinKit):Container(
          padding: EdgeInsets.fromLTRB(25.0, 20.0, 20.0, 25.0),
          child: Column(
            children: [
              _cardWithButton(),
              SizedBox(height: 30.0),
              _cardOfLeads()
            ],
          )),
    );
  }

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
          title: Text(
            "My Leaves",
            style: Constants().txtStyleFont16(ColorsUsed.whiteColor, 20.0),
          ),
        ),
      ),
      preferredSize:
      Size.fromHeight(Constants().containerHeight(context) * 0.08),
    );
  }

   //Buttons Ui
   _cardWithButton() {
  return Container(
//    elevation: 0.0,
//    margin: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
//    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
    child: Row(
      children: [
        _button("Pending", 0),
        Expanded(child: _button("Approved", 1)),
        _button("Disapproved", 2),

      ],
    ),
  );
}

  _pendingLeaves() {
  if(pendingLeavesList.length>0){
    return Expanded(
      child: ListView.builder(
          itemCount: pendingLeavesList.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context,i){
            return Column(
              children: [
                SizedBox(
                  //height:  /*_CompletedElevationId == i?270.0:*/250.0,
                  width: Constants().containerWidth(context),
                  child: InkWell(
                    onTap: (){
                      /* setState(() {
                      _CompletedElevationId = i;
                    });*/
                      /*Navigator.of(context).push(MaterialPageRoute(
                        builder: (context)=>TaskDetails(completedTaskList[i].id))).then((value) {
                      if(value == true){
                        setState(() {
                          _loading = true;
                        });_getActiveTaskLists();
                      }

                    });*/
                    },
                    child: Card(elevation: /*_CompletedElevationId==i?30.0:*/0.0,shadowColor: Colors.blue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                      child: Row(
                        children: [
                          Container(height: 100.0,width:10.0,
                            decoration: BoxDecoration(color: Colors.green,
                                borderRadius: BorderRadius.circular(5.0)),),
                          SizedBox(width: 15.0),
                          Expanded(
                            child: Column(crossAxisAlignment:  CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [SizedBox(width: 13.0),
                                    Expanded(
                                      child: Text(Util.convertMonth(DateTime.parse(pendingLeavesList[i].startDate).month.toString()),
                                        style: TextStyle(fontSize: 15.0,fontFamily: "Montserrat",
                                            fontWeight: FontWeight.bold,color: ColorsUsed.textBlueColor),),
                                    ),
                                    Text(Util.convertMonth(DateTime.parse(pendingLeavesList[i].endDate).month.toString()),
                                      style: TextStyle(fontSize: 15.0,fontFamily: "Montserrat",
                                          fontWeight: FontWeight.bold,color: ColorsUsed.textBlueColor),),
                                    SizedBox(width: 15.0),  ],
                                ),
                                SizedBox(height: 10.0),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),
                                          color: Color(0xffEEEDF6),),
                                        padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                                        child: Column(
                                          children: [
                                            Text(DateTime.parse(pendingLeavesList[i].startDate).day.toString(),
                                              style: TextStyle(fontSize: 15.0,fontFamily: "Montserrat",
                                                  fontWeight: FontWeight.bold,color: ColorsUsed.textBlueColor),),
                                            SizedBox(height: 10.0),
                                            Text(Util.convertWeekDay(DateTime.parse(pendingLeavesList[i].startDate).weekday.toString()),
                                              style: TextStyle(fontSize: 15.0,fontFamily: "Montserrat",
                                                  fontWeight: FontWeight.bold,color: ColorsUsed.textBlueColor),),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5.0),
                                    Column(
                                      children: [
                                        Text("----",
                                          style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,
                                              fontFamily: "Montserrat",color: ColorsUsed.textBlueColor),),
                                        Text(pendingLeavesList[i].days+" days",
                                            style:Constants().txtStyleFont16(Colors.indigo[900], 12.0)),
                                      ],
                                    ),
                                    SizedBox(width: 5.0),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),
                                          color: Color(0xffEEEDF6),),
                                        padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                                        child: Column(
                                          children: [
                                            Text(DateTime.parse(pendingLeavesList[i].endDate).day.toString(),
                                              style: TextStyle(fontSize: 15.0,fontFamily: "Montserrat",
                                                  fontWeight: FontWeight.bold,color: ColorsUsed.textBlueColor),),
                                            SizedBox(height: 10.0),
                                            Text(Util.convertWeekDay(DateTime.parse(pendingLeavesList[i].endDate).weekday.toString()),
                                              style: TextStyle(fontSize: 15.0,fontFamily: "Montserrat",
                                                  fontWeight: FontWeight.bold,color: ColorsUsed.textBlueColor),),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 25.0),
                          Container(
                            height: 70.0,
                            width: 2.0, color: Colors.indigo,
                          ),SizedBox(width: 15.0),
                          Column(
                            children: [
                              Icon(Icons.alarm,color: Colors.red),
                              SizedBox(height: 20.0),
                              Text(" Full day",
                                  style:Constants().txtStyleFont16(Colors.red, 12.0)),
                            ],
                          ),SizedBox(width: 15.0),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
              ],
            );
          }),
    );
  }else{
    return Center(child: Text("No Leaves to show"),);
  }
}

  _approveLeaves() {
  if(approvedLeavesList.length>0){
    return Expanded(
      child: ListView.builder(
          itemCount: approvedLeavesList.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context,i){
//                  _taskAssignTime = activeTaskList[i]["Assigned_Time"];
//                  _timeDifference = now.difference(_taskAssignTime).toString();
            return Column(
              children: [
                SizedBox(
                  //height:  /*_CompletedElevationId == i?270.0:*/250.0,
                  width: Constants().containerWidth(context),
                  child: InkWell(
                    onTap: (){
                      /* setState(() {
                      _CompletedElevationId = i;
                    });*/
                      /*Navigator.of(context).push(MaterialPageRoute(
                        builder: (context)=>TaskDetails(completedTaskList[i].id))).then((value) {
                      if(value == true){
                        setState(() {
                          _loading = true;
                        });_getActiveTaskLists();
                      }

                    });*/
                    },
                    child: Card(elevation: /*_CompletedElevationId==i?30.0:*/0.0,shadowColor: Colors.blue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                      child: Row(
                        children: [
                          Container(height: 100.0,width:10.0,
                            decoration: BoxDecoration(color: Colors.green,
                                borderRadius: BorderRadius.circular(5.0)),),
                          SizedBox(width: 15.0),
                          Expanded(
                            child: Column(crossAxisAlignment:  CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [SizedBox(width: 13.0),
                                    Expanded(
                                      child: Text(Util.convertMonth(DateTime.parse(approvedLeavesList[i].startDate).month.toString()),
                                        style: TextStyle(fontSize: 15.0,fontFamily: "Montserrat",
                                            fontWeight: FontWeight.bold,color: ColorsUsed.textBlueColor),),
                                    ),
                                    Text(Util.convertMonth(DateTime.parse(approvedLeavesList[i].endDate).month.toString()),
                                      style: TextStyle(fontSize: 15.0,fontFamily: "Montserrat",
                                          fontWeight: FontWeight.bold,color: ColorsUsed.textBlueColor),),
                                    SizedBox(width: 15.0),  ],
                                ),
                                SizedBox(height: 10.0),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),
                                          color: Color(0xffEEEDF6),),
                                        padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                                        child: Column(
                                          children: [
                                            Text(DateTime.parse(approvedLeavesList[i].startDate).day.toString(),
                                              style: TextStyle(fontSize: 15.0,fontFamily: "Montserrat",
                                                  fontWeight: FontWeight.bold,color: ColorsUsed.textBlueColor),),
                                            SizedBox(height: 10.0),
                                            Text(Util.convertWeekDay(DateTime.parse(approvedLeavesList[i].startDate).weekday.toString()),
                                              style: TextStyle(fontSize: 15.0,fontFamily: "Montserrat",
                                                  fontWeight: FontWeight.bold,color: ColorsUsed.textBlueColor),),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5.0),
                                    Column(
                                      children: [
                                        Text("----",
                                          style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,
                                              fontFamily: "Montserrat",color: ColorsUsed.textBlueColor),),
                                        Text(approvedLeavesList[i].days+" days",
                                            style:Constants().txtStyleFont16(Colors.indigo[900], 12.0)),
                                      ],
                                    ),
                                    SizedBox(width: 5.0),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),
                                          color: Color(0xffEEEDF6),),
                                        padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                                        child: Column(
                                          children: [
                                            Text(DateTime.parse(approvedLeavesList[i].endDate).day.toString(),
                                              style: TextStyle(fontSize: 15.0,fontFamily: "Montserrat",
                                                  fontWeight: FontWeight.bold,color: ColorsUsed.textBlueColor),),
                                            SizedBox(height: 10.0),
                                            Text(Util.convertWeekDay(DateTime.parse(approvedLeavesList[i].endDate).weekday.toString()),
                                              style: TextStyle(fontSize: 15.0,fontFamily: "Montserrat",
                                                  fontWeight: FontWeight.bold,color: ColorsUsed.textBlueColor),),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 25.0),
                          Container(
                            height: 70.0,
                            width: 2.0, color: Colors.indigo,
                          ),SizedBox(width: 15.0),
                          Column(
                            children: [
                              Icon(Icons.alarm,color: Colors.red),
                              SizedBox(height: 20.0),
                              Text(" Full day",
                                  style:Constants().txtStyleFont16(Colors.red, 12.0)),
                            ],
                          ),SizedBox(width: 15.0),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
              ],
            );
          }),
    );
  }else{
    return Center(child: Text("No Leaves to show"),);
  }
}

  _disapproveLeaves() {
  if(disApprovedLeavesList.length>0){
    return Expanded(
      child: ListView.builder(
          itemCount: disApprovedLeavesList.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context,i){
//                  _taskAssignTime = activeTaskList[i]["Assigned_Time"];
//                  _timeDifference = now.difference(_taskAssignTime).toString();
            return Column(
              children: [
                SizedBox(
                  //height:  /*_CompletedElevationId == i?270.0:*/250.0,
                  width: Constants().containerWidth(context),
                  child: InkWell(
                    onTap: (){
                      /* setState(() {
                      _CompletedElevationId = i;
                    });*/
                      /*Navigator.of(context).push(MaterialPageRoute(
                        builder: (context)=>TaskDetails(completedTaskList[i].id))).then((value) {
                      if(value == true){
                        setState(() {
                          _loading = true;
                        });_getActiveTaskLists();
                      }

                    });*/
                    },
                    child: Card(elevation: /*_CompletedElevationId==i?30.0:*/0.0,shadowColor: Colors.blue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                      child: Row(
                        children: [
                          Container(height: 100.0,width:10.0,
                            decoration: BoxDecoration(color: Colors.green,
                                borderRadius: BorderRadius.circular(5.0)),),
                          SizedBox(width: 15.0),
                          Expanded(
                            child: Column(crossAxisAlignment:  CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [SizedBox(width: 13.0),
                                    Expanded(
                                      child: Text(Util.convertMonth(DateTime.parse(disApprovedLeavesList[i].startDate).month.toString()),
                                        style: TextStyle(fontSize: 15.0,fontFamily: "Montserrat",
                                            fontWeight: FontWeight.bold,color: ColorsUsed.textBlueColor),),
                                    ),
                                    Text(Util.convertMonth(DateTime.parse(disApprovedLeavesList[i].endDate).month.toString()),
                                      style: TextStyle(fontSize: 15.0,fontFamily: "Montserrat",
                                          fontWeight: FontWeight.bold,color: ColorsUsed.textBlueColor),),
                                    SizedBox(width: 15.0),  ],
                                ),
                                SizedBox(height: 10.0),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),
                                          color: Color(0xffEEEDF6),),
                                        padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                                        child: Column(
                                          children: [
                                            Text(DateTime.parse(disApprovedLeavesList[i].startDate).day.toString(),
                                              style: TextStyle(fontSize: 15.0,fontFamily: "Montserrat",
                                                  fontWeight: FontWeight.bold,color: ColorsUsed.textBlueColor),),
                                            SizedBox(height: 10.0),
                                            Text(Util.convertWeekDay(DateTime.parse(disApprovedLeavesList[i].startDate).weekday.toString()),
                                              style: TextStyle(fontSize: 15.0,fontFamily: "Montserrat",
                                                  fontWeight: FontWeight.bold,color: ColorsUsed.textBlueColor),),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5.0),
                                    Column(
                                      children: [
                                        Text("----",
                                          style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,
                                              fontFamily: "Montserrat",color: ColorsUsed.textBlueColor),),
                                        Text(disApprovedLeavesList[i].days+" days",
                                            style:Constants().txtStyleFont16(Colors.indigo[900], 12.0)),
                                      ],
                                    ),
                                    SizedBox(width: 5.0),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),
                                          color: Color(0xffEEEDF6),),
                                        padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                                        child: Column(
                                          children: [
                                            Text(DateTime.parse(pendingLeavesList[i].endDate).day.toString(),
                                              style: TextStyle(fontSize: 15.0,fontFamily: "Montserrat",
                                                  fontWeight: FontWeight.bold,color: ColorsUsed.textBlueColor),),
                                            SizedBox(height: 10.0),
                                            Text(Util.convertWeekDay(DateTime.parse(pendingLeavesList[i].endDate).weekday.toString()),
                                              style: TextStyle(fontSize: 15.0,fontFamily: "Montserrat",
                                                  fontWeight: FontWeight.bold,color: ColorsUsed.textBlueColor),),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 25.0),
                          Container(
                            height: 70.0,
                            width: 2.0, color: Colors.indigo,
                          ),SizedBox(width: 15.0),
                          Column(
                            children: [
                              Icon(Icons.alarm,color: Colors.red),
                              SizedBox(height: 20.0),
                              Text(" Full day",
                                  style:Constants().txtStyleFont16(Colors.red, 12.0)),
                            ],
                          ),SizedBox(width: 15.0),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
              ],
            );
          }),
    );
  }else{
    return Center(child: Text("No Leaves to show"),);
  }
}

  //button
  _button(String title, int id) {
  return RaisedButton(
    onPressed: () {
      _clickOperation(id);
    },
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular( 25.0)),
    elevation: 0.0,
    color: _colorId == id ? Colors.green : Colors.transparent,
    child: Text(title,
        style: TextStyle(
            fontSize: 12.0,
            color: _colorId == id ? ColorsUsed.whiteColor : Colors.black,
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w500)),
  );
}

_clickOperation(int id) {
  switch (id) {
    case 0:
      _loader = true;
      Timer(Duration(seconds: 2), () {
        setState(() {
          _loader = false;
        });
      });
      setState(() {
        _colorId = 0;
      });
      break;
    case 1:
      _loader = true;
      Timer(Duration(seconds: 2), () {
        setState(() {
          _loader = false;
        });
      });
      setState(() {
        _colorId = 1;
      });
      break;
    case 2:
      _loader = true;
      Timer(Duration(seconds: 2), () {
        setState(() {
          _loader = false;
        });
      });
      setState(() {
        _colorId = 2;
      });
  }
}


  Future<dynamic> getLeaveList() async{
    pendingLeavesList.clear();
    try{
      await http.get("${Constants.BaseUrl}action=leaveList&userId=${Constants.userId}"
      ).then(( res) {
        print("hello");
        print(res.body);
        var response = json.decode(res.body);
        final int statusCode = res.statusCode;
        print(statusCode);
        print(response.length);
        if (statusCode == 200) {
          print("its working 200");
          setState(() {
            _loader= false;
          });
          if(response["success"] == "1"){
            for(int i=0;i<response["list"].length;i++){
              var leaveStatus = response["list"][i]["status"];
              //1 is for pending,2 is approve , 3 is disapprove
              if(leaveStatus == "1"){
                setState(() {
                  pendingLeavesList.add(LeavesModel(
                      id: response["list"][i]["id"],
                      days: response["list"][i]["day"],
                      startDate: response["list"][i]["startDate"],
                      endDate: response["list"][i]["endDate"],
                      reason: response["list"][i]["reason"]
                  ));
                });
                print(pendingLeavesList.length);
              }else if(leaveStatus == "2"){
                setState(() {
                  approvedLeavesList.add(LeavesModel(
                      id: response["list"][i]["id"],
                      days: response["list"][i]["day"],
                      startDate: response["list"][i]["startDate"],
                      endDate: response["list"][i]["endDate"],
                      reason: response["list"][i]["reason"]
                  ));
                });
                print(approvedLeavesList.length);
              }else if(leaveStatus == "3"){
                setState(() {
                  disApprovedLeavesList.add(LeavesModel(
                      id: response["list"][i]["id"],
                      days: response["list"][i]["day"],
                      startDate: response["list"][i]["startDate"],
                      endDate: response["list"][i]["endDate"],
                      reason: response["list"][i]["reason"]
                  ));
                });
                print(pendingLeavesList.length);
              }
            }
            print("in success");
            setState(() {
              _loader= false;
            });
          }else{
            setState(() {
              _loader= false;
            });
          }
        }else{
          Scaffold.of(context).showSnackBar(Constants().showSnackMessage(response["Something went wrong !"]));

        }
      });}on SocketException catch (_) {
      print('not connected');
      Constants().noInternet(context);
    }catch (e) {
    }
  }

  _cardOfLeads() {
    if(_colorId==0){
      return _pendingLeaves();
    }else if(_colorId==1){
      return _approveLeaves();
    }else if(_colorId == 2){
      return _disapproveLeaves();
    }
  }

}

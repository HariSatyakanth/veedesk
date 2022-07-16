import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart'as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/Images_path.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/Utiles/util.dart';
import 'package:newproject/models/myTaskModel.dart';
import 'package:newproject/pages/SearchPage.dart';
import 'package:newproject/pages/homeOptions/Add_Notes/Add_Notes.dart';
import 'package:newproject/pages/homeOptions/Queries/AddNewQuery.dart';
import 'package:newproject/pages/homeOptions/Queries/QueriesPojo.dart';
import 'package:newproject/pages/homeOptions/Queries/query_Details.dart';
import 'package:newproject/pages/homeOptions/Tasks/AddNewTask.dart';
import 'package:newproject/pages/homeOptions/Tasks/assigned_task.dart';
import 'package:newproject/pages/homeOptions/Tasks/task_Details.dart';

class MineQuery extends StatefulWidget {
//  final int id;
//  MyTasks(this.id);
  @override
  _MyQueryState createState() => _MyQueryState();
}

class _MyQueryState extends State<MineQuery> {
  int _colorId = 0;
  DateTime now;
  DateFormat formatter = DateFormat('EE, dd-MMM-yyyy');
  String dateToday;
  bool _loading = true;
  var _response,_timeDifference,_taskAssignTime;
  TextEditingController searchController = TextEditingController();
  List<GetQueriesByList> activeTaskList,completedTaskList;

  @override
  void initState(){
    super.initState();
    activeTaskList = new List<GetQueriesByList>();
    completedTaskList = new List<GetQueriesByList>();
    now = DateTime.now();
    dateToday = formatter.format(now);
    _getActiveTaskLists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.grey[200],
      appBar: _appBarOptions(),

      body: _loading?Center(child: Constants().spinKit,):_response["success"] == "1"?SingleChildScrollView(
        child: Container(padding: EdgeInsets.fromLTRB(25.0, 20.0, 20.0, 20.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0,),
              _cardWithButton(),
              SizedBox(height: 25.0,),
              _colorId==0?_activeTasks():Container(),
              SizedBox(height: 25.0,),
              _colorId==1?_completedTasks():Container(),
              SizedBox(height: 25.0,),
            ],
          ),
        ),

      ):Center(
        child: Text("No Query found",style: Constants().txtStyleFont16(Colors.black54, 25.0),),
      ),
    );
  }





  //AppBAr
  _appBarOptions() {
    return PreferredSize(
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(30.0),
          bottomLeft: Radius.circular(30.0),
        ),
        child: AppBar(backgroundColor: ColorsUsed.baseColor,
          leading: Constants().backButton(context),
          centerTitle: true,
          title: Row(
            children: [SizedBox(width: 35.0),
              Image.asset(Img.myOfficeImage,width: 20.0,),
              SizedBox(width: 10.0),
              Text("Sent Query",
                style: Constants().txtStyleFont16(ColorsUsed.whiteColor,20.0),),
            ],
          ),
          actions: [
            InkWell(
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=> AssignedTasks()));
              },
              child:  Image.asset(
                Img.worklogfadeImage,
                width: 25.0,
              ),
              /*child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.network(Constants.imageUrl == "null"?Constants.USER_IMAGE:Constants.imageUrl,
                  fit: BoxFit.cover,)
          ),*/

            )
            ,SizedBox(width: 20.0,)
          ],
        ),
      ),
      preferredSize: Size.fromHeight(Constants().containerHeight(context)*0.08),
    );
  }
  _activeTasks() {
    if(activeTaskList.length>0){
      return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: activeTaskList.length,
          itemBuilder: (BuildContext context, int index) {
            String subject = activeTaskList[index].title!=null?activeTaskList[index].title:"-";
            String date = activeTaskList[index].queryDateTime!=null?activeTaskList[index].queryDateTime:"-";
            String time = activeTaskList[index].agging!=null?activeTaskList[index].agging:"-";
            String followUp = activeTaskList[index].totalFollowup!=null?activeTaskList[index].totalFollowup:"-";
            return GestureDetector(
              onTap: ()  {
//                Navigator.push(context, MaterialPageRoute(builder: (context) => QueryDetail(),));
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
                              child: _details(followUp, Icons.message),
                            ),
                            Expanded(
                              child: _details(Util.changeDateToFormetted(date), Icons.calendar_today),
                            ),
                            Expanded(
                              child: _details(time, Icons.alarm),
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
    }else{
      return Center(child:Text("No record found"),);
    }
  }
  _completedTasks() {
    if(completedTaskList.length>0){
      return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: completedTaskList.length,
          itemBuilder: (BuildContext context, int index) {
            String subject = completedTaskList[index].title!=null?completedTaskList[index].title:"-";
            String date = completedTaskList[index].queryDateTime!=null?completedTaskList[index].queryDateTime:"-";
            String time = completedTaskList[index].agging!=null?completedTaskList[index].agging:"-";
            String followUp = completedTaskList[index].totalFollowup!=null?completedTaskList[index].totalFollowup:"-";
            return GestureDetector(
              onTap: ()  {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context)=>QueryDetails(activeTaskList[index].id,0))).then((value) {
                  if(value == true){
                    setState(() {
                      _loading = true;
                    });_getActiveTaskLists();
                  }

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
                              child: _details(followUp, Icons.message),
                            ),
                            Expanded(
                              child: _details(Util.changeDateToFormetted(date), Icons.calendar_today),
                            ),
                            Expanded(
                              child: _details(time, Icons.alarm),
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
    }else{
      return Center(child:Text("No record found"),);
    }
  }

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
//        getChatData(0);
        setState(() {
          _colorId = 0;
        });
        break;
      case "Closed":
//        getChatData(1);
        setState(() {
          _colorId = 1;
        });
    }
  }

  _details(String title, IconData _iconData) {
    return Row(
      children: [
        SizedBox(width: 10.0),
        Icon(
          _iconData,
          color: Colors.grey[500],
          size: 14.0,
        ),
        SizedBox(width: 5.0),
        Expanded(child: Text(title, style: Constants().txtStyleFont16(Colors.grey[500], 13.0))),
        SizedBox(width: 10.0),
      ],
    );
  }
//get Task lists
  var responseList;
  Future<dynamic> _getActiveTaskLists() async{
    activeTaskList.clear();
    completedTaskList.clear();
    print("${Constants.BaseUrl}action=getQueriesByList&query_by=${Constants.userId}");
    try{
      await http.get("${Constants.BaseUrl}action=getQueriesByList&query_by=${Constants.userId}").then((res){
        print(res.body);
        print("status${res.body}");
        setState(() {
          _loading = false;
          _response = json.decode(res.body);
          responseList = _response["getQueriesByList"];

        });
        final int statusCode = res.statusCode;
        print(statusCode);
        if (statusCode == 200) {
          print("check 200${_response["success"]}");
          if(_response["success"] == "1"){
            print("success = ${responseList[0]["getQueriesToList"]}");
            for(int i=0;i<responseList.length;i++){
              var status = responseList[i]["status"];
              print(status);
              print("Simi");
              if( status == "1"){
                print("Tanu");
                setState(() {
                  activeTaskList.add(GetQueriesByList(
                    id: responseList[i]["id"],
                    title: responseList[i]["title"],
                    queryDateTime: responseList[i]["queryDateTime"],
                    totalFollowup: responseList[i]["totalFollowup"],
                    agging: responseList[i]["agging"],
                    status: responseList[i]["status"],
                  ));
                });
              }else{
                print(responseList[i]);
                setState(() {
                  completedTaskList.add(GetQueriesByList(
                    id: responseList[i]["id"],
                    title: responseList[i]["title"],
                    queryDateTime: responseList[i]["queryDateTime"],
                    totalFollowup: responseList[i]["totalFollowup"],
                    agging: responseList[i]["agging"],
                    status: responseList[i]["status"],
                  ));
                });
              }

            }



          }else{
//            Scaffold.of(context).showSnackBar(Constants().showSnackMessage(response["message"]));
          }
        }else{
//          Scaffold.of(context).showSnackBar(Constants().showSnackMessage(response["Something went wrong !"]));
        }
      });}on SocketException catch (_) {
      print('not connected');
      Constants().noInternet(context);
    }catch (e) {
    }
  }


}

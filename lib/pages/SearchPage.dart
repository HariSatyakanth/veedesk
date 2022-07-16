import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:http/http.dart'as http;

import 'homeOptions/Tasks/task_Details.dart';

class SearchPage extends StatefulWidget {
   final int id;
  SearchPage(this.id);
  @override
  _SearchPageState createState() => _SearchPageState(id);
}

class _SearchPageState extends State<SearchPage> {
  final int id;
  _SearchPageState(this.id);
  TextEditingController searchController = TextEditingController();
  bool _loader = true;
  var _response, activeTaskList,_timeDifference,progressTaskList,holdTaskList,_taskAssignTime;

  void initState(){
    super.initState();
    getId();
  }

  getId(){
    if(id==0){
     return _searchactiveTaskLists();
    }else if(id ==1){
      return _searchLeadsLists();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: ColorsUsed.baseColor,
        title: Text("Search"),),
      body: SingleChildScrollView(
        child: Container(padding: EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 20.0),
          child: Column(
            children: [
              _searchBar(),
              SizedBox(height: 50.0),
            _loader?Center(child: CircularProgressIndicator(),):activeTaskList ==null?
            Center(child: Text("No data found"),):SingleChildScrollView(
              child: Container(height: 270.0,
                  child: Column(
                    children: [
                      Expanded(child: _activeTasks(),)
                    ],
                  ),
                ),
            ),
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
        print(searchController.text);
        _searchactiveTaskLists();
      },
    );
  }

  _activeTasks() {
    return Row(
      children: [
        Expanded(
          child: ListView.builder(
              itemCount:  activeTaskList.length == null?0:activeTaskList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context,i){
//                  _taskAssignTime = activeTaskList[i]["Assigned_Time"];
//                  _timeDifference = now.difference(_taskAssignTime).toString();
                return Row(
                  children: [
                    SizedBox(
                      height: 180.0,
                      width: Constants().containerWidth(context)*0.65,
                      child: InkWell(
                        onTap: (){print(_timeDifference);
                        setState(() {
                          /*_activeElevationId = i;*/
                        });
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context)=>TaskDetails(activeTaskList[i]["Id"],1)));
                        },
                        child: Card(elevation: /*_activeElevationId==i?30.0:*/0.0,shadowColor: Colors.blue,
                          color: Colors.grey[100],
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                          child: Row(
                            children: [
                              Container(height: 140.0,width:10.0,
                                decoration: BoxDecoration(color: ColorsUsed.baseColor,
                                    borderRadius: BorderRadius.circular(5.0)),),
                              SizedBox(width: 20.0),
                              Expanded(
                                child: Column(crossAxisAlignment:  CrossAxisAlignment.start,
                                  children: [SizedBox(height: 20.0),
                                    Text(id==0?activeTaskList[i]["Task"].length>30?activeTaskList[i]["Task"].substring(0,30)+"...":activeTaskList[i]["Task"]
                                        :activeTaskList[i]["Project_Name"].length>40?
                                    activeTaskList[i]["Project_Name"].substring(0,40)+"...":activeTaskList[i]["Project_Name"],
                                      style: Constants().txtStyleFont16(Colors.black, 15.0),),
                                    SizedBox(height: 10.0),
                                    Text(id==0?activeTaskList[i]["Sevirity"]:"",style: Constants().txtStyleFont16(Colors.grey[500], 12.0),),
                                    SizedBox(height: 10.0),
                                    Row(mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text("",style:Constants().txtStyleFont16(Colors.grey[500], 12.0)),
                                      ],
                                    ),
                                    SizedBox(height: 10.0),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text("Progress",style:Constants().txtStyleFont16(Colors.black54, 12.0)),
                                        ),
                                        Text("60%",style:Constants().txtStyleFont16(Colors.black54, 12.0)),
                                      ],
                                    ),
                                    SizedBox(height: 10.0),
                                    Row(
                                      children: [
                                        Stack(
                                          children: [
                                            CircleAvatar(radius: 10.0,
                                              child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(20.0),
                                                  child: Image.network(Constants.imageUrl == "null"?Constants.USER_IMAGE:Constants.imageUrl,
                                                    fit: BoxFit.cover,)
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment(1.5,0.0),
                                              widthFactor: 0.5,
                                              child: CircleAvatar(radius: 10.0,
                                                backgroundColor: Colors.grey,
                                                child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(20.0),
                                                    child: Image.network(Constants.imageUrl == "null"?Constants.USER_IMAGE:Constants.imageUrl,
                                                      fit: BoxFit.cover,)
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(width: 5.0),
                                        Expanded(
                                          child: LinearProgressIndicator(value: 0.6,),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),SizedBox(width: 10.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 15.0),
                  ],
                );
              }),
        ),
      ],
    );
  }

  //get Task lists
  Future<dynamic> _searchactiveTaskLists() async{
    _loader = true;
    print("${Constants.BaseUrl}action=taskSearch&userId=${Constants.userId}&taskSearch=${searchController.text}");
    try{
      await http.get("${Constants.BaseUrl}action=taskSearch&userId=${Constants.userId}&taskSearch=${searchController.text}").then((res){
        print(res.body);
        print("status${res.body}");
        setState(() {
          _response = json.decode(res.body);
        });
        final int statusCode = res.statusCode;
        print(statusCode);
        if (statusCode == 200) {
          setState(() {
            _loader = false;
          });
          print("check 200${_response["success"]}");
          if(_response["success"] == "1"){
            print("success = ${_response["task"]}");
            setState(() {
              activeTaskList = _response["task"];
            });print("${activeTaskList.length}");
          }else{
            setState(() {
              activeTaskList = null;
            });
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


  //get Task lists
  Future<dynamic> _searchLeadsLists() async{
    _loader = true;
    print("${Constants.BaseUrl}action=taskSearch&userId=${Constants.userId}&taskSearch=${searchController.text}");
    try{
      await http.get("${Constants.BaseUrl}action=leadSearch&Client=${Constants.userId}&leadSearch=${searchController.text}").then((res){
        print(res.body);
        print("status${res.body}");
        setState(() {
          _response = json.decode(res.body);
        });
        final int statusCode = res.statusCode;
        print(statusCode);
        if (statusCode == 200) {
          setState(() {
            _loader = false;
          });
          print("check 200${_response["success"]}");
          if(_response["success"] == "1"){
            print("success = ${_response["task"]}");
            setState(() {
              activeTaskList = _response["task"];
            });print("${activeTaskList.length}");
          }else{
            setState(() {
              activeTaskList = null;
            });
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

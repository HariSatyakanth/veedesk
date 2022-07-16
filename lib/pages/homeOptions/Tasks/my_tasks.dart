import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart'as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/Images_path.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/models/myTaskModel.dart';
import 'package:newproject/pages/SearchPage.dart';
import 'package:newproject/pages/homeOptions/Add_Notes/Add_Notes.dart';
import 'package:newproject/pages/homeOptions/Tasks/AddNewTask.dart';
import 'package:newproject/pages/homeOptions/Tasks/assigned_task.dart';
import 'package:newproject/pages/homeOptions/Tasks/task_Details.dart';

class MyTasks extends StatefulWidget {
//  final int id;
//  MyTasks(this.id);
  @override
  _MyTasksState createState() => _MyTasksState();
}

class _MyTasksState extends State<MyTasks> {
  int _activeElevationId = -1,_KIVElevationId = -1,_CompletedElevationId = -1,_progressElevationId = -1,_holdElevationId = -1;
   DateTime now;
   DateFormat formatter = DateFormat('EE, dd-MMM-yyyy');
   String dateToday;
   bool _loading = true;
   var _response,_timeDifference,_taskAssignTime;
   TextEditingController searchController = TextEditingController();
   List<AddTask> activeTaskList,progressTaskList,holdTaskList,KIVTaskList,completedTaskList;

  @override
  void initState(){
    super.initState();
    activeTaskList = new List<AddTask>();
    progressTaskList = new List<AddTask>();
    holdTaskList = new List<AddTask>();
    KIVTaskList = new List<AddTask>();
    completedTaskList = new List<AddTask>();
    now = DateTime.now();
    dateToday = formatter.format(now);
    _getActiveTaskLists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.grey[200],
      appBar: _appBarOptions(),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add New Task",
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewTask()));
        },
        child: Icon(Icons.add),
      ),
      body: _loading?Center(child: Constants().spinKit,):_response["success"] == "1"?SingleChildScrollView(
        child: Container(padding: EdgeInsets.fromLTRB(25.0, 20.0, 20.0, 20.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             Text(dateToday,style: Constants().txtStyleFont16(Colors.grey[600],14.0),),
             SizedBox(height: 15.0,),
             _searchBar(),
             SizedBox(height: 25.0,),
             _activeTasks(),
              SizedBox(height: 25.0,),
              _progressTasks(),
              SizedBox(height: 25.0,),
              _holdTasks(),
              SizedBox(height: 25.0,),
              _KIVTasks(),
              SizedBox(height: 25.0,),
              _completedTasks(),
              SizedBox(height: 25.0,),
            ],
          ),
        ),

      ):Center(
        child: Text("No tasks found",style: Constants().txtStyleFont16(Colors.black54, 25.0),),
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
              Text("My Tasks",
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

  _searchBar() {
    return TextField(
      controller: searchController,
      readOnly: true,
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchPage(0)));
      },
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
      },
    );
  }

  _activeTasks() {
    if(activeTaskList.length>0){
      return Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Active",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,color: ColorsUsed.baseColor),),
          SizedBox(height: 10.0,),
          Container(height: 270.0,
            child: Column(
              children: [
                Expanded(child: Row(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: activeTaskList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context,i){
//                  _taskAssignTime = activeTaskList[i]["Assigned_Time"];
//                  _timeDifference = now.difference(_taskAssignTime).toString();
                            return Row(
                              children: [
                                SizedBox(
                                  height:  _activeElevationId == i?270.0:250.0,
                                  width: Constants().containerWidth(context)*0.65,
                                  child: InkWell(
                                    onTap: (){print(_timeDifference);
                                    setState(() {
                                      _activeElevationId = i;
                                    });
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context)=>TaskDetails(activeTaskList[i].id,1))).then((value) {
                                      if(value == true){
                                        setState(() {
                                          _loading = true;
                                        });_getActiveTaskLists();
                                      }

                                    });
                                    },
                                    child: Card(elevation: _activeElevationId==i?30.0:0.0,shadowColor: Colors.blue,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                                      child: Row(
                                        children: [
                                          Container(height: 220.0,width:10.0,
                                            decoration: BoxDecoration(color: ColorsUsed.baseColor,
                                                borderRadius: BorderRadius.circular(5.0)),),
                                          SizedBox(width: 20.0),
                                          Expanded(
                                            child: Column(crossAxisAlignment:  CrossAxisAlignment.start,
                                              children: [SizedBox(height: 20.0),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(activeTaskList[i].name.length>40?activeTaskList[i].name.substring(0,40)+"...":activeTaskList[i].name,
                                                        style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: ColorsUsed.baseColor),),
                                                    ),SizedBox(width: 5.0),
                                                    Image.asset(
                                                        "Images/Group 15.png",
                                                        width: 5.0,
                                                      ),SizedBox(width: 5.0),
                                                  ],
                                                ),
                                                SizedBox(height: 10.0),
                                                Text(activeTaskList[i].discription.length>80?activeTaskList[i].discription.substring(0,80)+"...":activeTaskList[i].discription,style: Constants().txtStyleFont16(Colors.grey[500], 12.0),),
                                                SizedBox(height: 10.0),
                                                Row(mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text(activeTaskList[i].time==null?"-":activeTaskList[i].time.toLowerCase()+" ago",
                                                        style:Constants().txtStyleFont16(Colors.grey[500], 12.0)),
                                                  ],
                                                ),
                                                SizedBox(height: 10.0),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text("Progress",style:Constants().txtStyleFont16(Colors.black, 12.0)),
                                                    ),
                                                    Text(activeTaskList[i].progress+"%",style:Constants().txtStyleFont16(Colors.black, 12.0)),
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
                                                      child: LinearProgressIndicator(value: double.parse(activeTaskList[i].progress)/100,),
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
                ),)
              ],
            ),
          ),
        ],
      );
    }else{
      return Container();
    }
  }

  _progressTasks() {
    if(progressTaskList.length>0){
      return Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Progress",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,color: ColorsUsed.baseColor),),
          SizedBox(height: 10.0,),
          Container(height: 270.0,
            child: Column(
              children: [
                Expanded(child:Row(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: progressTaskList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context,i){
                            return Row(
                              children: [
                                SizedBox(
                                  height:  _progressElevationId == i?270.0:250.0,
                                  width: Constants().containerWidth(context)*0.65,
                                  child: InkWell(
                                    onTap: (){print(i);
                                    setState(() {
                                      _progressElevationId = i;
                                    });
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context)=>TaskDetails(progressTaskList[i].id,1))).then((value) {
                                      if(value == true){
                                        setState(() {
                                          _loading = true;
                                        });_getActiveTaskLists();
                                      }

                                    });
                                    },
                                    child: Card(elevation: _progressElevationId==i?30.0:0.0,shadowColor: Colors.green,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                                      child: Row(
                                        children: [
                                          Container(height: 220.0,width:10.0,
                                            decoration: BoxDecoration(color: Colors.green,
                                                borderRadius: BorderRadius.circular(5.0)),),
                                          SizedBox(width: 20.0),
                                          Expanded(
                                            child: Column(crossAxisAlignment:  CrossAxisAlignment.start,
                                              children: [SizedBox(height: 20.0),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(progressTaskList[i].name.length>40?progressTaskList[i].name.substring(0,40)+"...":progressTaskList[i].name,
                                                        style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,
                                                            color: ColorsUsed.baseColor),),
                                                    ),SizedBox(width: 5.0),
                                                    Image.asset(
                                                      "Images/Group 15.png",
                                                      width: 5.0,
                                                    ),SizedBox(width: 5.0),
                                                  ],
                                                ),
                                                SizedBox(height: 10.0),
                                                Text(progressTaskList[i].discription.length>80?progressTaskList[i].discription.substring(0,80)+"...":progressTaskList[i].discription,style: Constants().txtStyleFont16(Colors.grey[500], 12.0),),
                                                SizedBox(height: 10.0),
                                                Row(mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text(progressTaskList[i].time==null?"-":progressTaskList[i].time.toLowerCase()+" ago",
                                                        style:Constants().txtStyleFont16(Colors.grey[500], 12.0)),
                                                  ],
                                                ),
                                                SizedBox(height: 10.0),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text("Progress",style:Constants().txtStyleFont16(Colors.black, 12.0)),
                                                    ),
                                                    Text(progressTaskList[i].progress+"%",style:Constants().txtStyleFont16(Colors.black, 12.0)),
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
                                                    ),SizedBox(width: 5.0),
                                                    Expanded(
                                                      child: LinearProgressIndicator(value: double.parse(progressTaskList[i].progress)/100,),
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
                ),)
              ],
            ),
          ),
        ],
      );
    }else{
      return Container();
    }
  }

  _holdTasks() {
    if(holdTaskList.length>0){
      return Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("On Hold",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,color: ColorsUsed.baseColor),),
          SizedBox(height: 10.0,),
          Container(height: 270.0,
            child: Column(
              children: [
                Expanded(child:  Row(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: holdTaskList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context,i){
                            return Row(
                              children: [
                                SizedBox(
                                  height:  _holdElevationId == i?270.0:250.0,
                                  width: Constants().containerWidth(context)*0.65,
                                  child: InkWell(
                                    onTap: (){print(i);
                                    setState(() {
                                      _holdElevationId = i;
                                    });
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>

                                        TaskDetails(holdTaskList[i].id,1))).then((value) {
                                      if(value == true){
                                        setState(() {
                                          _loading = true;
                                        });_getActiveTaskLists();
                                      }

                                    });
                                    },
                                    child: Card(elevation: _holdElevationId==i?30.0:0.0,shadowColor: Color(0xFFFFD600),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                                      child: Row(
                                        children: [
                                          Container(height: 220.0,width:10.0,
                                            decoration: BoxDecoration(color: Color(0xFFFFD600),
                                                borderRadius: BorderRadius.circular(5.0)),),
                                          SizedBox(width: 20.0),
                                          Expanded(
                                            child: Column(crossAxisAlignment:  CrossAxisAlignment.start,
                                              children: [SizedBox(height: 20.0),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(holdTaskList[i].name.length>40?holdTaskList[i].name.substring(0,40)+"...":holdTaskList[i].name,
                                                        style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: ColorsUsed.baseColor),),
                                                    ),SizedBox(width: 5.0),
                                                    Image.asset(
                                                      "Images/Group 15.png",
                                                      width: 5.0,
                                                    ),SizedBox(width: 5.0),

                                                  ],
                                                ),
                                                SizedBox(height: 10.0),
                                                Text(holdTaskList[i].discription.length>80?holdTaskList[i].discription.substring(0,80)+"...":holdTaskList[i].discription,style: Constants().txtStyleFont16(Colors.grey[500], 12.0),),
                                                SizedBox(height: 10.0),
                                                Row(mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text(holdTaskList[i].time==null?"-":holdTaskList[i].time.toLowerCase()+" ago",
                                                        style:Constants().txtStyleFont16(Colors.grey[500], 12.0)),
                                                  ],
                                                ),
                                                SizedBox(height: 10.0),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text("Progress",style:Constants().txtStyleFont16(Colors.black, 12.0)),
                                                    ),
                                                    Text(holdTaskList[i].progress+"%",style:Constants().txtStyleFont16(Colors.black, 12.0)),
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
                                                    ),SizedBox(width: 5.0),
                                                    Expanded(
                                                      child: LinearProgressIndicator(value: double.parse(holdTaskList[i].progress)/100,),
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
                ),)
              ],
            ),
          ),
        ],
      );
    }else{
      return Container();
    }
  }

  _KIVTasks() {
    if(KIVTaskList.length>0){
      return Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("KIV",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,color: ColorsUsed.baseColor),),
          SizedBox(height: 10.0,),
          Container(height: 270.0,
            child: Column(
              children: [
                Expanded(child: Row(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: KIVTaskList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context,i){
//                  _taskAssignTime = activeTaskList[i]["Assigned_Time"];
//                  _timeDifference = now.difference(_taskAssignTime).toString();
                            return Row(
                              children: [
                                SizedBox(
                                  height:  _KIVElevationId == i?270.0:250.0,
                                  width: Constants().containerWidth(context)*0.65,
                                  child: InkWell(
                                    onTap: (){print(_timeDifference);
                                    setState(() {
                                      _KIVElevationId = i;
                                    });
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context)=>TaskDetails(KIVTaskList[i].id,1))).then((value) {
                                      if(value == true){
                                        setState(() {
                                          _loading = true;
                                        });_getActiveTaskLists();
                                      }

                                    });
                                    },
                                    child: Card(elevation: _KIVElevationId==i?30.0:0.0,shadowColor: Colors.blue,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                                      child: Row(
                                        children: [
                                          Container(height: 220.0,width:10.0,
                                            decoration: BoxDecoration(color: ColorsUsed.baseColor,
                                                borderRadius: BorderRadius.circular(5.0)),),
                                          SizedBox(width: 20.0),
                                          Expanded(
                                            child: Column(crossAxisAlignment:  CrossAxisAlignment.start,
                                              children: [SizedBox(height: 20.0),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(KIVTaskList[i].name.length>40?KIVTaskList[i].name.substring(0,40)+"...":KIVTaskList[i].name,
                                                        style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: ColorsUsed.baseColor),),
                                                    ),SizedBox(width: 5.0),
                                                    Image.asset(
                                                      "Images/Group 15.png",
                                                      width: 5.0,
                                                    ),SizedBox(width: 5.0),
                                                  ],
                                                ),
                                                SizedBox(height: 10.0),
                                                Text(KIVTaskList[i].discription.length>80?KIVTaskList[i].discription.substring(0,80)+"...":KIVTaskList[i].discription,style: Constants().txtStyleFont16(Colors.grey[500], 12.0),),
                                                SizedBox(height: 10.0),
                                                Row(mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text(KIVTaskList[i].time==null?"-":KIVTaskList[i].time.toLowerCase()+" ago",
                                                        style:Constants().txtStyleFont16(Colors.grey[500], 12.0)),
                                                  ],
                                                ),
                                                SizedBox(height: 10.0),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text("Progress",style:Constants().txtStyleFont16(Colors.black, 12.0)),
                                                    ),
                                                    Text(KIVTaskList[i].progress+"%",style:Constants().txtStyleFont16(Colors.black, 12.0)),
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
                                                      child: LinearProgressIndicator(value: double.parse(KIVTaskList[i].progress)/100),
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
                ),)
              ],
            ),
          ),
        ],
      );
    }else{
      return Container();
    }
  }

  _completedTasks() {
    if(completedTaskList.length>0){
      return Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Completed",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,color: ColorsUsed.baseColor),),
          SizedBox(height: 10.0,),
          Container(height: 270.0,
            child: Column(
              children: [
                Expanded(child: Row(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: completedTaskList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context,i){
//                  _taskAssignTime = activeTaskList[i]["Assigned_Time"];
//                  _timeDifference = now.difference(_taskAssignTime).toString();
                            return Row(
                              children: [
                                SizedBox(
                                  height:  _CompletedElevationId == i?270.0:250.0,
                                  width: Constants().containerWidth(context)*0.65,
                                  child: InkWell(
                                    onTap: (){print(_timeDifference);
                                    setState(() {
                                      _CompletedElevationId = i;
                                    });
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context)=>TaskDetails(completedTaskList[i].id,1))).then((value) {
                                      if(value == true){
                                        setState(() {
                                          _loading = true;
                                        });_getActiveTaskLists();
                                      }

                                    });
                                    },
                                    child: Card(elevation: _CompletedElevationId==i?30.0:0.0,shadowColor: Colors.blue,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                                      child: Row(
                                        children: [
                                          Container(height: 220.0,width:10.0,
                                            decoration: BoxDecoration(color: ColorsUsed.baseColor,
                                                borderRadius: BorderRadius.circular(5.0)),),
                                          SizedBox(width: 20.0),
                                          Expanded(
                                            child: Column(crossAxisAlignment:  CrossAxisAlignment.start,
                                              children: [SizedBox(height: 20.0),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(completedTaskList[i].name.length>40?completedTaskList[i].name.substring(0,40)+"...":completedTaskList[i].name,
                                                        style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: ColorsUsed.baseColor),),
                                                    ),SizedBox(width: 5.0),
                                                    Image.asset(
                                                      "Images/Group 15.png",
                                                      width: 5.0,
                                                    ),SizedBox(width: 5.0),
                                                  ],
                                                ),
                                                SizedBox(height: 10.0),
                                                Text(completedTaskList[i].discription.length>80?completedTaskList[i].discription.substring(0,80)+"...":completedTaskList[i].discription,style: Constants().txtStyleFont16(Colors.grey[500], 12.0),),
                                                SizedBox(height: 10.0),
                                                Row(mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text(completedTaskList[i].time==null?"-":completedTaskList[i].time.toLowerCase()+" ago",
                                                        style:Constants().txtStyleFont16(Colors.grey[500], 12.0)),
                                                  ],
                                                ),
                                                SizedBox(height: 10.0),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text("Progress",style:Constants().txtStyleFont16(Colors.black, 12.0)),
                                                    ),
                                                    Text(completedTaskList[i].progress+"%",style:Constants().txtStyleFont16(Colors.black, 12.0)),
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
                                                      child: LinearProgressIndicator(value: double.parse(completedTaskList[i].progress)/100,),
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
                ),)
              ],
            ),
          ),
        ],
      );
    }else{
      return Container();
    }
  }


//get Task lists
 var responseList;
  Future<dynamic> _getActiveTaskLists() async{
    activeTaskList.clear();
    progressTaskList.clear();
    holdTaskList.clear();
    KIVTaskList.clear();
    completedTaskList.clear();
    try{
      await http.get("${Constants.BaseUrl}action=task&userId=${Constants.userId}").then((res){
        print(res.body);
        print("status${res.body}");
        setState(() {
          _loading = false;
          _response = json.decode(res.body);
         responseList = _response["task"];

        });
        final int statusCode = res.statusCode;
        print(statusCode);
        if (statusCode == 200) {
          print("check 200${_response["success"]}");
          if(_response["success"] == "1"){
            print("success = ${responseList[0]["Task"]}");
            for(int i=0;i<responseList.length;i++){
              var status = responseList[i]["Current_Status"];
              print(status);
              if( status == "Assigned"){
                setState(() {
                  activeTaskList.add(AddTask(
                      id: responseList[i]["Id"],
                      name: responseList[i]["Task"],
                      discription: responseList[i]["description"],
                      status: responseList[i]["Current_Status"],
                      time: responseList[i]["timeDiff"],
                      progress: responseList[i]["progress"]
                  ));
                });
              }
              if(status =="KIV"){
                setState(() {
                  KIVTaskList.add(AddTask(
                      id: responseList[i]["Id"],
                      name: responseList[i]["Task"],
                      discription: responseList[i]["description"],
                      status: responseList[i]["Current_Status"],
                      time: responseList[i]["timeDiff"],
                      progress: responseList[i]["progress"]
                  ));
                });
              }
              if(status=="Ongoing"){
                setState(() {
                  progressTaskList.add(AddTask(
                      id: responseList[i]["Id"],
                      name: responseList[i]["Task"],
                      discription: responseList[i]["description"],
                      status: responseList[i]["Current_Status"],
                      time: responseList[i]["timeDiff"],
                      progress: responseList[i]["progress"]
                  ));
                });
              }
              if(status =="Completed"){
                setState(() {
                 completedTaskList.add(AddTask(
                      id: responseList[i]["Id"],
                      name: responseList[i]["Task"],
                      discription: responseList[i]["description"],
                      status: responseList[i]["Current_Status"],
                      time: responseList[i]["timeDiff"],
                      progress: responseList[i]["progress"]
                  ));
                });
              }
              if(status=="Pending"){
                print(responseList[i]);
                setState(() {
                  holdTaskList.add(AddTask(
                      id: responseList[i]["Id"],
                      name: responseList[i]["Task"],
                      discription: responseList[i]["description"],
                      status: responseList[i]["Current_Status"],
                      time: responseList[i]["timeDiff"],
                      progress: responseList[i]["progress"]
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

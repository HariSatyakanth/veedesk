import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/Images_path.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/pages/homeOptions/JitsiMeet/CreateMeeting.dart';
import 'package:newproject/pages/homeOptions/JitsiMeet/MeetingPOJO.dart';
import 'package:newproject/pages/homeOptions/JitsiMeet/ViewMeet.dart';
import 'package:newproject/pages/homeOptions/MyContacts/MyContactList.dart';
import 'package:newproject/pages/homeOptions/groupChat.dart';
import 'package:permission_handler/permission_handler.dart';

class MeetingList extends StatefulWidget {
  @override
  _MeetingListState createState() => _MeetingListState();
}

class _MeetingListState extends State<MeetingList> {
  bool _loader;
  MeetingPOJO meetingPOJO = MeetingPOJO();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPermissionHandler();
    meetingList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBarOptions(),
        //employeType =4 is admin user
        floatingActionButton: Constants.employeType == "4"
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateMeeting(),
                      )).then((value) => meetingList());
                },
                backgroundColor: ColorsUsed.baseColor,
                child: Icon(
                  Icons.add,
                  size: 35.0,
                ),
              )
            : Container(),
        body: _loader?Center(child: Constants().spinKit):Container(padding: EdgeInsets.all(15.0),
          child: meetingPOJO.getMeetingList==null?Text("No Meetings yet"):ListView.builder(
            itemCount: meetingPOJO.getMeetingList.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),),
                  child: Container(padding: EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Constants.selectedFontWidget(meetingPOJO.getMeetingList[index].meetingName, ColorsUsed.textBlueColor, 17.0, FontWeight.bold),
                            SizedBox(height: 10),
                            Constants.selectedFontWidget(meetingPOJO.getMeetingList[index].meetingDes, ColorsUsed.textBlueColor, 17.0, FontWeight.bold),
                            SizedBox(height: 10),
                            Constants.selectedFontWidget(meetingPOJO.getMeetingList[index].startDate, ColorsUsed.textBlueColor, 17.0, FontWeight.bold),

                          ],
                        ),Spacer(),
                        IconButton(icon: Icon(Icons.visibility),
                            onPressed: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewMeet(meetingPOJO.getMeetingList[index].meetingName),
                                  ));
                            })
                      ],
                    ),
                  ),
                );
              },),
        ));
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
            "My Office Meets",
            style: Constants().txtStyleFont16(ColorsUsed.whiteColor, 20.0),
          ),
        ),
      ),
      preferredSize:
          Size.fromHeight(Constants().containerHeight(context) * 0.08),
    );
  }

  Future<dynamic> meetingList() async{
    setState(() {
      _loader= true;
    });
    //https://tasla.app/MyOffice/index.php?action=getMeetingList&start_date=2021-01-17%2022:36:15
    try{
      await http.get("${Constants.BaseUrl}action=getMeetingList"
      ).then(( res) {
        print("hello");
        print(res.body);
        var response = json.decode(res.body);
        final int statusCode = res.statusCode;
        print(statusCode);
        if (statusCode == 200) {
          print("its working 200");
          if(response["success"] == "1"){
            print("in success");
            setState(() {
              _loader= false;
              meetingPOJO = MeetingPOJO.fromJson(response);
            });print("responseList${meetingPOJO.getMeetingList[0].meetingName}");
          }else{
            setState(() {
              _loader= false;
            });
            Constants.showToast(response["message"]);
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

  Future getPermissionHandler() async {
    await Permission.camera.request();
    await Permission.microphone.request();
  }
}

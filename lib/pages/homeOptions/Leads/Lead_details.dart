import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:newproject/Interfaces/callBackWidget.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/Utiles/util.dart';
import 'package:newproject/pages/homeOptions/Leads/AddLeadFollowUp.dart';
import 'package:newproject/pages/homeOptions/Leads/LeadDetailsPojo.dart';
import 'package:newproject/pages/homeOptions/Leads/LeadFuDetails.dart';
import 'package:newproject/pages/homeOptions/Tasks/AddFollowUp.dart';
import 'package:newproject/pages/homeOptions/Tasks/TaskFuDetails.dart';
import 'package:url_launcher/url_launcher.dart';

class LeadDetails extends StatefulWidget {
  final String leadId;

  /*var leadName;*/
  LeadDetails(this.leadId /*,this.leadName*/);

  @override
  _LeadDetailsState createState() => _LeadDetailsState(leadId /*,leadName*/);
}

class _LeadDetailsState extends State<LeadDetails>  implements WidgetCallBack {
  String leadId, status;
  var _response;
  bool _loader = true;

  LeadDetailsPojo leadDetailsPojo = new LeadDetailsPojo();

  _LeadDetailsState(this.leadId /*,this.leadName*/);

  bool _switchValue = false;
  int _radioGroup = 0;

  @override
  void initState() {
    super.initState();
    _getTaskDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: _appBarOptions(),
        body: _loader
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Text(
                            "Active/Closed",
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: ColorsUsed.baseColor),
                          )),
                          Switch(
                              value: _switchValue,
                              onChanged: (value) {
                                if (_switchValue) {
                                  Constants.showToast(
                                      "Lead is closed by you.Please contact admin to reset");
                                } else {

                                  changeLeadsStatus();
                                }
                              })
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        "Description",
                        style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            color: ColorsUsed.baseColor),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        leadDetailsPojo.description != null?leadDetailsPojo.description:"No description added!",
                        style:
                            Constants().txtStyleFont16(Colors.grey[500], 12.0),
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        children: [
                          Expanded(
                              child: Text("Created by",
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: ColorsUsed.baseColor))),
                          Text(
                            leadDetailsPojo.clientName == null
                                ? "No details added"
                                : leadDetailsPojo.clientName,
                            style: Constants()
                                .txtStyleFont16(Colors.black54, 15.0),
                          )
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        children: [
                          Expanded(
                              child: Text("Estimated Cost",
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: ColorsUsed.baseColor))),
                          Text(
                            leadDetailsPojo.estimateValue == null
                                ? "No details added"
                                : leadDetailsPojo.estimateValue+" INR",
                            style: Constants()
                                .txtStyleFont16(Colors.black54, 15.0),
                          )
                        ],
                      ),

                      leadDetailsPojo.quotation !=null? Row(
                        children: [
                          Expanded(
                              child: Text("Quotation",
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: ColorsUsed.baseColor))),
                          IconButton(
                              onPressed: () =>  launch(leadDetailsPojo.quotation),
                              icon: Icon(Icons.remove_red_eye_outlined))
                        ],
                      ): Text(
                        "No Quotation details added",
                        style: Constants()
                            .txtStyleFont16(Colors.black54, 15.0),
                      ),

                      leadDetailsPojo.proposal !=null? Row(
                        children: [
                          Expanded(
                              child: Text("Proposal",
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: ColorsUsed.baseColor))),
                          IconButton(
                              onPressed: () => launch(leadDetailsPojo.proposal),
                              icon: Icon(Icons.remove_red_eye_outlined))
                        ],
                      ): Text(
                        "No Proposal details added",
                        style: Constants()
                            .txtStyleFont16(Colors.black54, 15.0),
                      ),
                      SizedBox(height: 10.0),
                      leadDetailsPojo.followupLeads == null?
                      Text(
                        "No FollowUp added yet!",
                        style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            color: ColorsUsed.baseColor),
                      ):
                      Row(
                        children: [
                          Expanded(
                              child: Text("Follow Ups:",
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: ColorsUsed.baseColor))),
                          Constants().buttonRaised(context,
                              ColorsUsed.baseColor, "+ FollowUp", this)
                        ],
                      ),
                      SizedBox(height: 10.0),
                      leadDetailsPojo.followupLeads!=null?ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount:  leadDetailsPojo.followupLeads.length,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Column(
                                children: [
                                  Radio(
                                      value: _radioValuesFollowUP(index),
                                      groupValue: _radioGroup,
                                      onChanged: (value) {}),
                                  // if(_tasksDetailPOJO.followupTask[index].status == "1")
                                  leadDetailsPojo.followupLeads[index].status ==
                                      "1"
                                      ? Constants.completeLines()
                                      : Constants.dottedLines(),
                                ],
                              ),
                              SizedBox(width: 20.0),
                              Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      if( leadDetailsPojo.followupLeads!=null){
                                        Navigator.push(context, MaterialPageRoute(
                                            builder: (context) => LeadFuDetails( leadDetailsPojo.followupLeads[index],0))).then((value) => _getTaskDetails());
                                      }},
                                    child: Container(
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(20.0),
                                              ),
                                              color: ColorsUsed.baseColor,
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 20.0),
                                                  Row(
                                                    children: [
                                                      SizedBox(width: 15.0),
                                                      Expanded(
                                                          child: Text(
                                                            leadDetailsPojo.followupLeads[index].followupText,
                                                            style: Constants()
                                                                .txtStyleFont16(
                                                                Colors.white, 14.0),
                                                          )),
                                                      SizedBox(width: 15.0),
                                                    ],
                                                  ),
                                                  SizedBox(height: 20.0),
                                                  Row(
                                                    children: [
                                                      SizedBox(width: 15.0),
                                                      Expanded(
                                                          child: Text(
                                                            leadDetailsPojo.followupLeads[index]
                                                                .description,
//                                              _response["description"]==null?"Please wait...":_response["description"],
                                                            style: Constants()
                                                                .txtStyleFont16(
                                                                Colors.grey[500],
                                                                12.0),
                                                          )),
                                                      SizedBox(width: 15.0),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 20.0,
                                                    width: 10.0,
                                                  ),
                                                  Row(
                                                    children: [
                                                      SizedBox(width: 15.0),
                                                      Stack(
                                                        children: [
                                                          CircleAvatar(
                                                            radius: 10.0,
                                                            child: ClipRRect(
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    20.0),
                                                                child: Image.network(
                                                                  Constants.imageUrl ==
                                                                      "null"
                                                                      ? Constants
                                                                      .USER_IMAGE
                                                                      : Constants
                                                                      .imageUrl,
                                                                  fit: BoxFit.cover,
                                                                )),
                                                          ),
                                                          Align(
                                                            alignment:
                                                            Alignment(1.5, 0.0),
                                                            widthFactor: 0.5,
                                                            child: CircleAvatar(
                                                              radius: 10.0,
                                                              backgroundColor:
                                                              Colors.grey,
                                                              child: ClipRRect(
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                      20.0),
                                                                  child:
                                                                  Image.network(
                                                                    Constants
                                                                        .imageUrl ==
                                                                        "null"
                                                                        ? Constants
                                                                        .USER_IMAGE
                                                                        : Constants
                                                                        .imageUrl,
                                                                    fit: BoxFit.cover,
                                                                  )),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Spacer(),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          Text(
                                                           Util.changeDateToFormetted( leadDetailsPojo.followupLeads[index]
                                                                .followupDate),
//                                              _response["description"]==null?"Please wait...":_response["description"],
                                                            style: Constants()
                                                                .txtStyleFont16(
                                                                Colors.white,
                                                                12.0),
                                                          ),
                                                          SizedBox(width: 10,),
                                                        ],
                                                      ),

                                                    ],
                                                  ),
                                                  SizedBox(height: 20.0,width: 20,),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ))
                            ],
                          );
                        },
                      ):Container()
                    ],
                  ),
                ),
              ));
  }

  _radioValuesFollowUP(int i) {
    switch (int.parse(leadDetailsPojo.followupLeads[i].status)) {
      case 0:
      //return 1 means inactive radio
        return 1;
        break;
      case 1:
      //return 0 means active radio
        return 0;
        break;
    }
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
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context, false);
              }),
          centerTitle: true,
          title: _loader
              ? Center(
                  child: Text("Loading..."),
                )
              : Text(
                  _response["Project_Name"],
                  style:
                      Constants().txtStyleFont16(ColorsUsed.whiteColor, 15.0),
                ),
          actions: [
            CircleAvatar(
              radius: 15.0,
              backgroundImage: NetworkImage(
                Constants.imageUrl == null
                    ? Constants.USER_IMAGE
                    : Constants.imageUrl,
              ),
              /*child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.network(Constants.imageUrl == "null"?Constants.USER_IMAGE:Constants.imageUrl,
                    fit: BoxFit.cover,)
              ),*/
            ),
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

  //getLeadsLiss
  Future<dynamic> changeLeadsStatus() async {
    setState(() {
      _loader = false;
    });
    try {
      await http
          .get(
              "${Constants.BaseUrl}action=changeStatusLeads&id=$leadId&status=2")
          .then((res) {
        print(res.body);
        var response = json.decode(res.body);
        final int statusCode = res.statusCode;
        print(statusCode);
        if (statusCode == 200) {
          setState(() {
            _loader = false;
          });
          response["success"] == 1 ? _switchValue = true : _switchValue = false;
          Constants.showToast(response["message"]);
        } else {
//          Scaffold.of(context).showSnackBar(Constants().showSnackMessage(response["Something went wrong !"]));
        }
      });
    } on SocketException catch (_) {
      print('not connected');
      Constants().noInternet(context);
    } catch (e) {}
  }

  //get all details about leads
  Future<dynamic> _getTaskDetails() async {
    try {
      await http
          .get("${Constants.BaseUrl}action=leadsDetails&id=$leadId")
          .then((res) {
        print(res.body);
        print("status${res.body}");
        setState(() {
          _response = json.decode(res.body);
          _loader = false;
        });
        final int statusCode = res.statusCode;
        print(statusCode);
        if (statusCode == 200) {
          print("check 200${_response["success"]}");
          if (_response["success"] == 1) {
            setState(() {
              leadDetailsPojo = LeadDetailsPojo.fromJson(_response);
            });
            leadDetailsPojo.status == "Open"
                ? _switchValue = false
                : _switchValue = true;
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

  @override
  void callBackInterface(String title) {
    switch (title) {
      case "+ FollowUp":
        if(_switchValue){
          Constants.showToast("Can't add FollowUp for closed lead");
        }else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      LeadFollowUpAdd(
                        taskId: leadId,
                      ))).then((value) {
            if (value) {
              setState(() {
                _loader = true;
              });
              _getTaskDetails();
            }
          });
        }
        break;
    }  }
}

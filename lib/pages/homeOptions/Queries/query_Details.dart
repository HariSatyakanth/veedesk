import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:newproject/Interfaces/callBackWidget.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/Utiles/util.dart';
import 'package:newproject/common/ImagePreview.dart';
import 'package:newproject/pages/homeOptions/Queries/AddNewQuery.dart';
import 'package:newproject/pages/homeOptions/Queries/AddQueryFollowUp.dart';
import 'package:newproject/pages/homeOptions/Queries/QueryDetailsPOJO.dart';
import 'package:newproject/pages/homeOptions/Queries/QueryFuDetails.dart';
import 'package:newproject/pages/homeOptions/Tasks/TaskFuDetails.dart';

class QueryDetails extends StatefulWidget {
  final String queryId;
  final int screenCheck;

  QueryDetails(this.queryId, this.screenCheck);

  @override
  _TaskDetailsState createState() => _TaskDetailsState(queryId);
}

class _TaskDetailsState extends State<QueryDetails> implements WidgetCallBack {
  String queryId;

  _TaskDetailsState(this.queryId);

  QueryDetailsPojo _tasksDetailPOJO = QueryDetailsPojo();

  bool _loading = true, isPlaying = false;
  var _response, taskList;
  List<NetworkImage> listImage = List<NetworkImage>();
  int _radioGroup = 0;
  List<dynamic> _status = List();
  int statusID;
  String _selectedStatus;
  AudioPlayer _audioPlayer;
  int progessValue = 0;
  bool _switchValue ;
  var progressCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    listImage.add(NetworkImage(Constants.USER_IMAGE));
    _getTaskDetails();
    _audioPlayer = AudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: _appBarOptions(),
      body: _loading
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
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                              color: ColorsUsed.baseColor),
                        )),
                        Switch(
                            value: _switchValue,
                            onChanged: (value) {
                              if (_switchValue) {
                                Constants.showToast(
                                    "Query is closed by you.Please contact admin to reset");
                              } else {
                                setState(() {
                                  _selectedStatus = "2";
                                });
                                changeLeadsStatus();
                              }
                            })
                      ],
                    ),
                    SizedBox(height: 30.0),
                    Text(
                      "Description",
                      style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                          color: ColorsUsed.baseColor),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      _tasksDetailPOJO.description == null
                          ? "No description added yet"
                          : _tasksDetailPOJO.description,
                      style: Constants().txtStyleFont16(Colors.grey[500], 12.0),
                    ),
                    SizedBox(height: 20.0),
                    _tasksDetailPOJO.audioUrl != ""?Row(
                      children: [
                        Text(
                          "Audio",
                          style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                              color: ColorsUsed.baseColor),
                        ),
                        SizedBox(width: 20.0),
                        Container(
                          padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                          decoration: BoxDecoration(
                              color: ColorsUsed.baseColor,
                              borderRadius: BorderRadius.circular(10.0)),
                          height: 40,
                          width: Constants().containerWidth(context) * 0.5,
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  isPlaying
                                      ? pause()
                                      : play(_tasksDetailPOJO.audioUrl);
                                },
                                child: CircleAvatar(
                                  radius: 15.0,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    isPlaying ? Icons.pause : Icons.play_arrow,
                                    color: ColorsUsed.baseColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ):Container(child:Text("No audio attached") ,),
                    SizedBox(height: 20.0),
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          "Image",
                          style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                              color: ColorsUsed.baseColor),
                        )),
                        SizedBox(width: 20.0),
                        showImage(context, listImage, _tasksDetailPOJO.title),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    //  _images(),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Constants().buttonRaised(
                            context, ColorsUsed.baseColor, "+ FollowUp", this),
                      ],
                    ),
                    SizedBox(height: 10.0),

                    _tasksDetailPOJO.followupQuery == null
                        ? Text(
                            "No FollowUp added yet!",
                            style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                                color: ColorsUsed.baseColor),
                          )
                        : Text(
                            "FollowUps :",
                            style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                                color: ColorsUsed.baseColor),
                          ),
                    SizedBox(height: 10.0),
                    _tasksDetailPOJO.followupQuery != null
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _tasksDetailPOJO.followupQuery.length,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  Column(
                                    children: [
                                      Radio(
                                          value: _radioValuesFollowUP(index),
                                          groupValue: _radioGroup,
                                          onChanged: (value) {}),
                                      // if(_tasksDetailPOJO.followupQuery[index].status == "1")
                                      _tasksDetailPOJO.followupQuery[index]
                                                  .status ==
                                              "1"
                                          ? Constants.completeLines()
                                          : Constants.dottedLines(),
                                    ],
                                  ),
                                  SizedBox(width: 20.0),
                                  Expanded(
                                      child: InkWell(
                                    onTap: () {
                                      if (_tasksDetailPOJO.followupQuery !=
                                          null) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    QueryFUDetails(
                                                        _tasksDetailPOJO
                                                                .followupQuery[
                                                            index],
                                                        widget
                                                            .screenCheck))).then(
                                            (value) => _getTaskDetails());
                                      }
                                    },
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
                                                        _tasksDetailPOJO
                                                            .followupQuery[
                                                                index]
                                                            .followupTitle,
                                                        style: Constants()
                                                            .txtStyleFont16(
                                                                Colors.white,
                                                                14.0),
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
                                                        _tasksDetailPOJO
                                                            .followupQuery[
                                                                index]
                                                            .description,
//                                              _response["description"]==null?"Please wait...":_response["description"],
                                                        style: Constants()
                                                            .txtStyleFont16(
                                                                Colors
                                                                    .grey[500],
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
                                                                child: Image
                                                                    .network(
                                                                  Constants.imageUrl ==
                                                                          "null"
                                                                      ? Constants
                                                                          .USER_IMAGE
                                                                      : Constants
                                                                          .imageUrl,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )),
                                                          ),
                                                          Align(
                                                            alignment:
                                                                Alignment(
                                                                    1.5, 0.0),
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
                                                                  child: Image
                                                                      .network(
                                                                    Constants.imageUrl ==
                                                                            "null"
                                                                        ? Constants
                                                                            .USER_IMAGE
                                                                        : Constants
                                                                            .imageUrl,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  )),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(width: 5.0),
                                                      Spacer(),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            Util.changeDateToFormetted(
                                                                _tasksDetailPOJO
                                                                    .followupQuery[
                                                                        index]
                                                                    .followupDate),
//                                              _response["description"]==null?"Please wait...":_response["description"],
                                                            style: Constants()
                                                                .txtStyleFont16(
                                                                    Colors
                                                                        .white,
                                                                    12.0),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(height: 20.0),
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
                          )
                        : Container()
                  ],
                ),
              ),
            ),
    );
  }

  _radioValuesFollowUP(int i) {
    switch (int.parse(_tasksDetailPOJO.followupQuery[i].status)) {
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

  Widget showImage(
      BuildContext context, List<NetworkImage> images, String name) {
    return new SizedBox(
        height: 100.0,
        width: 70.0,
        child: Carousel(
          images: images,
          dotSize: 4.0,
          dotSpacing: 15.0,
          dotColor: Colors.lightGreenAccent,
          indicatorBgPadding: 5.0,
          dotBgColor: Colors.brown.withOpacity(0.3),
          borderRadius: true,
          autoplay: false,
          onImageTap: (index) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ImagePreview(images[index].url, name)));
          },
        ));
    // return  new Container(
    //     child: CarouselSlider(
    //       options: CarouselOptions(),
    //       items: images
    //           .map((item) => Container(
    //         child: Center(
    //           child: Image.network(item.url, fit: BoxFit.cover),
    //         ),
    //       ))
    //           .toList(),
    //     ),
    //     alignment: Alignment.center,
    //     height: 100.0,
    //   );
  }

  play(String audioUr) async {
    print(audioUr);
    int result = await _audioPlayer.play(Constants.getAudioUrl(audioUr));
    if (result == 1) {
      setState(() {
        isPlaying = true;
      });
      _audioPlayer.onPlayerCompletion.listen((event) {
        setState(() => isPlaying = false);
      });
    } else {
      Constants.showToast("No Audio Found");
    }
  }

  pause() async {
    await _audioPlayer.pause();
    setState(() {
      isPlaying = false;
    });
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
          title: _loading
              ? Center(
                  child: Text("Loading...."),
                )
              : Text(
                  _tasksDetailPOJO.title == null
                      ? "Please wait..."
                      : _tasksDetailPOJO.title,
                  style:
                      Constants().txtStyleFont16(ColorsUsed.whiteColor, 15.0),
                ),
          /* actions: [
            IconButton(icon: Image.asset("Images/home/Group 1.png",width: 25.0,),
                onPressed: (){
                  print('search');
                }
            ), SizedBox(width: 20.0,)
          ],*/
        ),
      ),
      preferredSize:
          Size.fromHeight(Constants().containerHeight(context) * 0.08),
    );
  }

  /* _calendarCard() {
    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
      height: 135.0,
      child: Card(elevation: 5.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: SfCalendar(
          view: CalendarView.week,
        ),
      ),
    );
  }*/

  _images() {
    return Row(
      children: [
        SizedBox(width: 15.0),
        Stack(
          children: [
            CircleAvatar(
              radius: 20.0,
              backgroundImage: NetworkImage(
                _tasksDetailPOJO.imagesUrl == null
                    ? Constants.USER_IMAGE
                    : _tasksDetailPOJO.imagesUrl,
              ),
            ),
            Align(
              alignment: Alignment(1.5, 0.0),
              widthFactor: 0.5,
              child: CircleAvatar(
                radius: 20.0,
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(
                  Constants.imageUrl == "null"
                      ? Constants.USER_IMAGE
                      : Constants.imageUrl,
                ),
              ),
            )
          ],
        ),
        SizedBox(width: 5.0),
        Expanded(
            child: Text(/*_tasksDetailPOJO.*/ "John",
                textAlign: TextAlign.end,
                style: Constants().txtStyleFont16(Colors.grey[500], 12.0)))
      ],
    );
  }

  _statusList() {}

  //get all details about task
  Future<dynamic> _getTaskDetails() async {
    print("${Constants.BaseUrl}action=getQueriesByToDetailsList&id=$queryId");
    try {
      await http
          .get(
              "${Constants.BaseUrl}action=getQueriesByToDetailsList&id=$queryId")
          .then((res) {
        setState(() {
          _response = json.decode(res.body);
          _loading = false;
        });
        final int statusCode = res.statusCode;
        print(_response);
        if (statusCode == 200) {
          print("check 200${_response["success"]}");
          if (_response["success"] == 1) {
            _tasksDetailPOJO = QueryDetailsPojo.fromJson(_response);
            setState(() {
              taskList = _tasksDetailPOJO.title;
              _selectedStatus = _tasksDetailPOJO.status;
              _selectedStatus=="1"?_switchValue=false:_switchValue=true;
              listImage.clear();
              listImage = Constants.getImageArray(_tasksDetailPOJO.imagesUrl);
            });
            print("${taskList.length}");
//            Scaffold.of(context).showSnackBar(Constants().showSnackMessage("Login successfully"));
//            Navigator.of(context).push(new MaterialPageRoute(builder: (context) => BottomNavigation()));
          } else {
            Navigator.pop(context);
            Constants.showToast("No data available,Try again Later");
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

  //change task Status
  Future<dynamic> changeLeadsStatus() async {
    print(
        "${Constants.BaseUrl}action=queriesStatusUpdate&id=$queryId&status=$_selectedStatus");
    _loading = true;

    try {
      await http
          .get(
              "${Constants.BaseUrl}action=queriesStatusUpdate&id=$queryId&status=$_selectedStatus")
          .then((res) {
        print(res.body);
        var response = json.decode(res.body);
        setState(() {
          _loading = false;
        });
        final int statusCode = res.statusCode;
        print(statusCode);
        if (statusCode == 200) {
          Constants.showToast(response["message"]);
          print(response["task"].length);
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
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => QueryFollowUpAdd(
                      queryId: queryId,
                    ))).then((value) {
          if (value) {
            setState(() {
              _loading = true;
            });
            _getTaskDetails();
          }
        });
        break;
    }
  }
}

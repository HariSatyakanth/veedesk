import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart'as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/Images_path.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/Utiles/strings.dart';
import 'package:newproject/common/ImagePreview.dart';
import 'package:newproject/models/MyWorkLogModal.dart';
import 'package:newproject/pages/homeOptions/WorkLog/AddWorkLog.dart';
import 'package:newproject/pages/homeOptions/WorkLog/WorkLogDetails.dart';

class WorkLogList extends StatefulWidget {
  @override
  _WorkLogListState createState() => _WorkLogListState();
}

class _WorkLogListState extends State<WorkLogList> {
  var responseList;
  var response;
  bool _loading = false, isPlaying = false;
  int _activeElevationId = -1;
  AudioPlayer _audioPlayer;
  List<WorkLogModel> workLogModel;

  @override
  void initState() {
    super.initState();
    _loading = true;
    _audioPlayer = AudioPlayer();
    workLogModel = new List<WorkLogModel>();
    getOnlineData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: _appBarOptions(),
        floatingActionButton: FloatingActionButton(
          tooltip: "Add New Note",
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => AddWorkLog())).then((value) {
              if(value){
                setState(() {
                  _loading = true;
                });getOnlineData();
              }
            });
          },
          child: Icon(Icons.add),
        ),
        body: _loading?Center(child: Constants().spinKit):Container(
            padding: EdgeInsets.fromLTRB(25.0, 20.0, 20.0, 25.0),
            child: _cardOfWorklog()));
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
                "My WorkLog",
                style: Constants().txtStyleFont16(ColorsUsed.whiteColor, 20.0),
              ),
            ],
          ),
          actions: [
            IconButton(
                icon: Image.asset(
                  Img.worklogfadeImage,
                  width: 25.0,
                ),
                onPressed: () {
                  print('search');
                  Navigator.push(context,
                      // 1 for online
                      MaterialPageRoute(builder: (context) => WorkLogDetails(1,"Today ")));
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

  _cardOfWorklog() {
    print(workLogModel.length);
    if (workLogModel.length > 0) {
      //    List<NetworkImage> propertyPic = new List<NetworkImage>();
      return _loading
          ? Center(child: Constants().spinKit)
          : ListView.builder(
          itemCount: workLogModel.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                            // 0 for online
                            MaterialPageRoute(builder: (context) => WorkLogDetails(0,workLogModel[index].logDate)));
                  },
                  child: Card(
                    elevation:
                    _activeElevationId == index ? 20.0 : 0.0,
                    shadowColor: ColorsUsed.baseColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0)),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.0),
                        Row(
                          children: [SizedBox(width: 15),
                            CircleAvatar(
                              child: Text(workLogModel[index].title.substring(0,1).toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 15.0,fontFamily: "Montserrat",
                                      fontWeight: FontWeight.bold,
                                      color: ColorsUsed.whiteColor)),
                            ),SizedBox(width: 10),
                            Expanded(
                              child: Text(workLogModel[index].title, style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,fontFamily: "Montserrat",
                                  color: ColorsUsed.baseColor)),
                            ),SizedBox(width: 10),
                            Icon(_activeElevationId == index?Icons.arrow_drop_up:Icons.arrow_drop_down)
                            ,SizedBox(width: 15),],
                        ),
                        _logDetails(index),
                        SizedBox(height: 20.0), ],
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
              ],
            );
          });
    } else {
      return Center(
        child: Text(
          "No data found",
          style: Constants().txtStyleFont16(Colors.black54, 25.0),
        ),
      );
    }
  }

  _logDetails(int index) {

    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Row(
          children: [SizedBox(width: 20),
            Icon(Icons.calendar_today,size: 11.0,color: Colors.grey[500],),
            SizedBox(width: 10),
            Text(workLogModel[index].logDate.substring(0,10),
                style: TextStyle(
                    fontSize: 10.0,fontFamily: "Montserrat",
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[500]))
          ],
        ),
        SizedBox(height: 20.0),
        Row(
          children: [SizedBox(width: 15),
            Text("Description",
                style: TextStyle(
                    fontSize: 16.0,fontFamily: "Montserrat",
                    fontWeight: FontWeight.bold,
                    color: ColorsUsed.baseColor)),
          ],
        ),
        Row(
          children: [SizedBox(width: 15),
            Text(
              workLogModel[index].description,
              style: Constants().txtStyleFont16(
                  Colors.grey[500], 12.0),
            ),
          ],
        ),
        SizedBox(height: 20.0),
        Row(
          children: [SizedBox(width: 15),
            Text("Attachment",
                style: TextStyle(
                    fontSize: 16.0,fontFamily: "Montserrat",
                    fontWeight: FontWeight.bold,
                    color: ColorsUsed.baseColor)),
          ],
        ),
        SizedBox(height : 15),
        Row(
          children: [
            SizedBox(width: 15),
            // MultipleImages()
            showImage(context, workLogModel[index].images, "Worklog Deatils"),
          ],
        ),
      ],
    );
  }

  Future<void> getOnlineData() async {
    try {
      await http
          .get(
          "${Constants.BaseUrl}action=worklogsList&userId=${Constants.userId}")
      //   "${Constants.BaseUrl}action=worklogsDetails&userId=${Constants.userId}&logDate=${widget.date}")
          .then((res) {
        setState(() {
          _loading = false;
          response = json.decode(res.body);
          responseList = response["logsList"];
          print(response);
        });
        final int statusCode = res.statusCode;
        if (statusCode == 200) {
          if (response["success"] == "1") {
            print(responseList.length);
            for (int i = 0; i < responseList.length; i++) {
              setState(() {
                workLogModel.add(WorkLogModel(
                    id: responseList[i]["id"],
                    userId: responseList[i]["userId"],
                    projectName: responseList[i]["project_name"],
                    initialTime: responseList[i]["initial_time"],
                    finishTime: responseList[i]["finish_time"],
                    title: responseList[i]["title"],
                    images: Constants.getImageString(responseList[i]["image"].toString()),
                    description: responseList[i]["description"],
                    logDate: responseList[i]["logDate"]));
              });
            }
          } else {
            setState(() {
              _loading = false;
            });
//            Constants.showToast(S.SOME_WRONG);
          }
        }
      });
    } on SocketException catch (_) {
      print('not connected');
      Constants().noInternet(context);
    } catch (e) {
      print(e);
      setState(() {
        _loading = false;
      });
    }
  }

  showImage(BuildContext context, List<NetworkImage> images, name) {
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
  }

  play(String audioUr) async {
    int result = await _audioPlayer.play(audioUr);
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
}

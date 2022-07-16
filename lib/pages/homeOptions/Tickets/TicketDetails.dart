import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:newproject/Interfaces/callBackWidget.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/Images_path.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:http/http.dart'as http;
import 'package:newproject/common/ImagePreview.dart';
import 'package:newproject/pages/homeOptions/Tickets/AddTicketFollowUp.dart';
import 'package:newproject/pages/homeOptions/Tickets/FollowUpDetails.dart';
import 'package:newproject/pages/homeOptions/Tickets/TicketDetailPOJO.dart';

class TicketDetails extends StatefulWidget {
  final ticketId;
  TicketDetails(this.ticketId);
  @override
  _TicketDetailsState createState() => _TicketDetailsState();
}

class _TicketDetailsState extends State<TicketDetails> implements WidgetCallBack  {
  TicketDetailsPOJO ticketDetailsPOJO = TicketDetailsPOJO();
  bool _loading = true, isPlaying = false;
  var _response, taskList;
  List<NetworkImage> listImage =  List<NetworkImage>();
  int _radioGroup = 0;
  List<dynamic> _status = List();
  int statusID;
  String _selectedStatus;
  AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    getTicketDetails();
    _audioPlayer = AudioPlayer();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(30.0),
            bottomLeft: Radius.circular(30.0),
          ),
          child: AppBar(backgroundColor: ColorsUsed.baseColor,
            leading: Constants().backButton(context),
            centerTitle: true,
            title: Row(
              children: [SizedBox(width: Constants().containerWidth(context)*0.13),
                Image.asset(Img.myOfficeImage,width: 20.0,),
                SizedBox(width: 10.0),
                Text("My Ticket",
                  style: Constants().txtStyleFont16(ColorsUsed.whiteColor,20.0),),
              ],
            ),
          ),
        ),
        preferredSize: Size.fromHeight(Constants().containerHeight(context)*0.08),
      ),
      body: _loading?Center(child: CircularProgressIndicator(),):
      SingleChildScrollView(
        child: Container(padding: EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 20.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text(ticketDetailsPOJO.myTicketascaleteDetails[0].ticketTitle,
                        style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold,color: ColorsUsed.textBlueColor),)
                  ),
                 /* Container(
                      decoration: BoxDecoration(color: ColorsUsed.baseColor,
                          borderRadius: BorderRadius.circular(30.0)),
                      padding: EdgeInsets.fromLTRB(25.0, 0.0, 10.0, 0.0),
                      child: _statusList()
                  )*/
                ],
              ),
              SizedBox(height: 30.0),
              Text("Description",style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold,color: ColorsUsed.textBlueColor),),
              SizedBox(height: 10.0),
              Text(ticketDetailsPOJO.myTicketascaleteDetails[0].description,
//                _response["description"]==null?"Please wait...":_response["description"],
                style: Constants().txtStyleFont16(Colors.grey[500], 12.0),),
              SizedBox(height: 20.0),
              Row(
                children: [
                  Text("Audio",style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold,color: ColorsUsed.textBlueColor),),
                  SizedBox(width: 20.0),
                  Container(
                    padding: EdgeInsets.fromLTRB(10.0,0,10.0,0),
                    decoration: BoxDecoration(color: ColorsUsed.baseColor,
                        borderRadius: BorderRadius.circular(10.0)),
                    height: 40,
                    width: Constants().containerWidth(context)*0.5,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            isPlaying
                                ? pause()
                                : play(Constants.ImageBaseUrl+ticketDetailsPOJO.myTicketascaleteDetails[0].audioUrl);
                          },
                          child: CircleAvatar(radius: 15.0,
                            backgroundColor: Colors.white,
                            child: Icon(
                              isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: ColorsUsed.baseColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(child: Text("Image",style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold,
                      color: ColorsUsed.textBlueColor),)),
                  SizedBox(width: 20.0),
                  showImage(context,listImage, ticketDetailsPOJO.myTicketascaleteDetails[0].ticketTitle),
                ],
              ),
              SizedBox(height: 20.0),
              _images(),
              SizedBox(height: 10.0),
              ticketDetailsPOJO.followuptickek== null?
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
              ticketDetailsPOJO.followuptickek != null?
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: ticketDetailsPOJO.followuptickek.length,
                itemBuilder: (context, index) {
                return Row(
                  children: [
                    Column(
                      children: [
                        Radio(value:_radioValuesFollowUP(index) ,
                            groupValue: _radioGroup,
                             onChanged: (value){}),
                       // if(ticketDetailsPOJO.followuptickek[index].status == "1")
                  ticketDetailsPOJO.followuptickek[index].status == "1"?Constants.completeLines():Constants.dottedLines(),
                      ],
                    ),
                    SizedBox(width: 20.0),
                    Expanded(
                        child: InkWell(
                          onTap:(){
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => FollowUpDetails(ticketDetailsPOJO.followuptickek[index],0))).then((value) => getTicketDetails());
                            },
                          child: Container(
                            child: Column(
                              children: [
                                SizedBox(
                                  child: Card(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),),
                                    color: ColorsUsed.baseColor,
                                    child: Column(
                                      children: [SizedBox(height: 20.0),
                                        Row(
                                          children: [SizedBox(width: 15.0),
                                            Expanded(
                                                child: Text(ticketDetailsPOJO.followuptickek[index].title,
                                                  style: Constants().txtStyleFont16(Colors.white,14.0),)
                                            ),
                                            SizedBox(width: 15.0),
                                          ],
                                        ),
                                        SizedBox(height: 20.0),
                                        Row(
                                          children: [SizedBox(width: 15.0),
                                            Expanded(
                                                child: Text(ticketDetailsPOJO.followuptickek[index].description,
//                                              _response["description"]==null?"Please wait...":_response["description"],
                                                  style: Constants().txtStyleFont16(Colors.grey[500], 12.0),)),
                                            SizedBox(width: 15.0),],
                                        ),
                                        SizedBox(height: 20.0,width: 10.0,),
                                        Row(
                                          children: [SizedBox(width: 15.0),
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
              },):Container()
            ],
          ),
        ),
      ),
    );
  }

   _radioValuesFollowUP(int i) {
    switch (int.parse(ticketDetailsPOJO.followuptickek[i].status)) {
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

  Widget showImage(BuildContext context, List<NetworkImage> images, String name) {
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
    print(audioUr);
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

  _images() {
    return Row(
      children: [SizedBox(width: 15.0),
        Stack(
          children: [
            CircleAvatar(radius: 20.0,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.network(Constants.imageUrl == "null"?Constants.USER_IMAGE:Constants.imageUrl,
                    fit: BoxFit.cover,)
              ),
            ),
            Align(
              alignment: Alignment(1.5,0.0),
              widthFactor: 0.5,
              child: CircleAvatar(radius: 20.0,
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
            child: Text("Working with",textAlign: TextAlign.end,
                style: Constants().txtStyleFont16(Colors.grey[500],12.0))
        )
      ],
    );
  }

  _statusList(){
    return DropdownButtonHideUnderline(
      child: DropdownButton(
          hint: Text("Status"),
          isExpanded: false,
          value: _selectedStatus,
          items: _status.map((listStatus) {
            return DropdownMenuItem(
              child: Text(listStatus),
              value: listStatus,);
          } ).toList(),
          iconEnabledColor: Colors.white,
          dropdownColor: ColorsUsed.baseColor,
          style: TextStyle(color: Colors.white),
          onChanged: (value) {
            setState(() {
              _selectedStatus = value;
              statusID =  int.parse("${_status.indexOf(value)+1}");
            });
//            changeLeadsStatus().then((value) => Navigator.pop(context,true));
          }),
    );
  }

  void getTicketDetails() async {
    var _response;
    print("${Constants.BaseUrl}action=myTicketascaleteDetails&"
        "userId=${Constants.userId}&ticketId=${widget.ticketId}");
    try{
      await http.get("${Constants.BaseUrl}action=myTicketascaleteDetails&"
          "userId=${Constants.userId}&ticketId=${widget.ticketId}").then((res){
        print(res.body);
        print("status${res.body}");
        setState(() {
          _loading = false;
          _response = json.decode(res.body);
        });
        final int statusCode = res.statusCode;
        print(statusCode);
        if (statusCode == 200) {
          print("check 200${_response["success"]}");
          if(_response["success"] == "1"){
            setState(() {
              _loading  = false;
              ticketDetailsPOJO = TicketDetailsPOJO.fromJson(_response);
              print(ticketDetailsPOJO.myTicketascaleteDetails[0].imagesUrl);
              listImage= Constants.getImageString(ticketDetailsPOJO.myTicketascaleteDetails[0].imagesUrl);
            });

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

  @override
  void callBackInterface(String title) {
    switch (title) {
      case "+ FollowUp":
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TicketFollowUpAdd(
                  taskId: ticketDetailsPOJO.myTicketascaleteDetails[0].id
                ))).then((value) {
          if (value) {
            setState(() {
              _loading = true;
            });
            getTicketDetails();
          }
        });
        break;
    }
  }

}

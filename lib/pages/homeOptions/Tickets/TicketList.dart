import 'package:flutter/material.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/Images_path.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/models/TicketPojo.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:newproject/pages/homeOptions/Tickets/TicketDetails.dart';

class TicketList extends StatefulWidget {
  @override
  _TicketListState createState() => _TicketListState();
}

class _TicketListState extends State<TicketList> {
  TicketPojo ticketPojo = TicketPojo();
  List<MyTicketsList> activeTicketList = List<MyTicketsList>();
  List<MyTicketsList> KIVTicketList = List<MyTicketsList>();
  List<MyTicketsList> closedTicketList = List<MyTicketsList>();
  var _loading = true;
  var searchController = TextEditingController();
  var _response;
  var responseList;

  @override
  void initState() {
    super.initState();
    getData();
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
          child: AppBar(
            backgroundColor: ColorsUsed.baseColor,
            leading: Constants().backButton(context),
            centerTitle: true,
            title: Row(
              children: [
                SizedBox(width: Constants().containerWidth(context) * 0.13),
                Image.asset(Img.myOfficeImage, width: 20.0,),
                SizedBox(width: 10.0),
                Text("My Tickets",
                  style: Constants().txtStyleFont16(
                      ColorsUsed.whiteColor, 20.0),),
              ],
            ),
          ),
        ),
        preferredSize: Size.fromHeight(
            Constants().containerHeight(context) * 0.08),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 10.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              _searchBar(),
          SizedBox(height: 20.0),
          _openTasks(),
          SizedBox(height: 25.0,),
          _closedTasks(),
          SizedBox(height: 25.0,),
          _KIVTasks(),
          SizedBox(height: 25.0,),
                nodata()
        ],
      ),
    ),)
    ,
    );
  }

  nodata() {
    if( activeTicketList.isEmpty && KIVTicketList.isEmpty && closedTicketList.isEmpty) {
      return Center(
        child: Text(
          "No data available",
          style: Constants().txtStyleFont16(Colors.black54, 30.0),),
      );
    }else{
      return Container();
    }
  }

  _searchBar() {
    return Card(elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: TextField(
        controller: searchController,
        readOnly: true,
        onTap: () {
//        Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchPage(0)));
        },
        decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFFF2F2F2
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide.none),
            contentPadding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide.none),
            hintText: "Search...",
            prefixIcon: IconButton(
              icon: Icon(Icons.search, color: Colors.grey,), onPressed: () {},)
        ),
        onChanged: (value) {
          print(searchController.text);
        },
      ),
    );
  }

  _openTasks() {
    if (activeTicketList.length > 0) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Active", style: TextStyle(fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: ColorsUsed.textBlueColor),),
          SizedBox(height: 10.0,),
          Container(height: 175.0,
            child: Column(
              children: [
                Expanded(child: Row(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: activeTicketList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, i) {
                            return Row(
                              children: [
                                SizedBox(
                                  height: 170.0,
                                  width: Constants().containerWidth(context) *
                                      0.65,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                          builder: (context) => TicketDetails(
                                              activeTicketList[i].id)))
                                          .then((value) {});
                                    },
                                    child: Stack(
                                      children: [
                                        Card(elevation: 30.0,
                                          shadowColor: Color(0xff3D73DD),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius
                                                  .circular(25.0)),
                                          child: Row(
                                            children: [
                                              SizedBox(width: 20.0),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    SizedBox(height: 20.0),
                                                    Stack(
                                                      children: [
                                                        Container(height: 70.0,
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                              10.0, 0.0, 0.0,
                                                              0.0),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      activeTicketList[i]
                                                                          .ticketTitle
                                                                          .length >
                                                                          20
                                                                          ?
                                                                      activeTicketList[i]
                                                                          .ticketTitle
                                                                          .substring(
                                                                          0,
                                                                          20) +
                                                                          "..."
                                                                          :
                                                                      activeTicketList[i]
                                                                          .ticketTitle
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          fontSize: 15.0,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color: ColorsUsed
                                                                              .textBlueColor),),
                                                                  ),
                                                                  SizedBox(
                                                                      width: 5.0),
                                                                  Image.asset(
                                                                    "Images/Group 15.png",
                                                                    width: 5.0,
                                                                  ),
                                                                  SizedBox(
                                                                      width: 5.0),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                  height: 10.0),
                                                              Text(
                                                                activeTicketList[i]
                                                                    .description
                                                                    .length > 20
                                                                    ?
                                                                activeTicketList[i]
                                                                    .description
                                                                    .substring(
                                                                    0, 20) +
                                                                    "..."
                                                                    : activeTicketList[i]
                                                                    .description,
                                                                style: Constants()
                                                                    .txtStyleFont16(
                                                                    Colors
                                                                        .grey[500],
                                                                    12.0),),
                                                            ],
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .center,
                                                          widthFactor: 0.2,
                                                          child: Container(
                                                            width: 2.0,
                                                            height: 50.0,
                                                            decoration: BoxDecoration(
                                                                color: Color(
                                                                    0xff3D73DD),
                                                                borderRadius: BorderRadius
                                                                    .circular(
                                                                    5.0)),),)
                                                      ],
                                                    ),
                                                    SizedBox(height: 10.0),
                                                    Row(
                                                      children: [
                                                        Image.asset(
                                                          Img.empImage,
                                                          width: 15.0,),
                                                        SizedBox(width: 5.0),
                                                        Expanded(
                                                            child: Constants
                                                                .selectedFontWidget(
                                                                activeTicketList[i]
                                                                    .fullName,
                                                                Color(
                                                                    0xff757474),
                                                                12.0, FontWeight
                                                                .bold))
                                                      ],
                                                    ),
                                                    SizedBox(height: 10.0),
                                                    Row(
                                                      children: [
                                                        Image.asset(
                                                          Img.notesTitleImage,
                                                          width: 15.0,),
                                                        SizedBox(width: 5.0),
                                                        Constants
                                                            .selectedFontWidget(
                                                            activeTicketList[i]
                                                                .ticketDate,
                                                            Color(0xff757474),
                                                            12.0,
                                                            FontWeight.bold),
                                                        SizedBox(width: 10.0),
                                                        Image.asset(Img.clock,
                                                          width: 15.0,),
                                                        SizedBox(width: 5.0),
                                                        Constants
                                                            .selectedFontWidget(
                                                            activeTicketList[i]
                                                                .ticketTime,
                                                            Color(0xff757474),
                                                            12.0,
                                                            FontWeight.bold),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ), SizedBox(width: 10.0),
                                            ],
                                          ),
                                        ),
                                        /*Align(alignment: Alignment.centerLeft,
                                          child: Container(width:2.0,
                                            decoration: BoxDecoration(color: ColorsUsed.textBlueColor,
                                                borderRadius: BorderRadius.circular(5.0)),),)*/
                                      ],
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
    } else {
      return Container();
    }
  }

  _closedTasks() {
    if (closedTicketList.length > 0) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Closed", style: TextStyle(fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: ColorsUsed.textBlueColor),),
          SizedBox(height: 10.0,),
          Container(height: 170.0,
            child: Column(
              children: [
                Expanded(child: Row(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: closedTicketList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, i) {
                            return Row(
                              children: [
                                SizedBox(
                                  height: 170.0,
                                  width: Constants().containerWidth(context) *
                                      0.65,
                                  child: InkWell(
                                    onTap: () {
                                      /*Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context)=>TicketDetails(closedTicketList[i].id))).then((value) {

                                    });*/
                                    },
                                    child: Card(elevation: 30.0,
                                      shadowColor: Color(0xffF44A4A),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              25.0)),
                                      child: Row(
                                        children: [
                                          SizedBox(width: 20.0),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [SizedBox(height: 20.0),
                                                Stack(
                                                  children: [
                                                    Container(height: 50.0,
                                                      padding: EdgeInsets
                                                          .fromLTRB(
                                                          10.0, 0.0, 0.0, 0.0),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  closedTicketList[i]
                                                                      .ticketTitle
                                                                      .length >
                                                                      20 ?
                                                                  closedTicketList[i]
                                                                      .ticketTitle
                                                                      .substring(
                                                                      0, 20) +
                                                                      "..." :
                                                                  closedTicketList[i]
                                                                      .ticketTitle
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize: 15.0,
                                                                      fontWeight: FontWeight
                                                                          .bold,
                                                                      color: ColorsUsed
                                                                          .textBlueColor),),
                                                              ),
                                                              SizedBox(
                                                                  width: 5.0),
                                                              Image.asset(
                                                                "Images/Group 15.png",
                                                                width: 5.0,
                                                              ),
                                                              SizedBox(
                                                                  width: 5.0),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                              height: 10.0),
                                                          Text(
                                                            closedTicketList[i]
                                                                .description
                                                                .length > 20
                                                                ?
                                                            closedTicketList[i]
                                                                .description
                                                                .substring(
                                                                0, 20) + "..."
                                                                : closedTicketList[i]
                                                                .description,
                                                            style: Constants()
                                                                .txtStyleFont16(
                                                                Colors
                                                                    .grey[500],
                                                                12.0),),
                                                        ],
                                                      ),
                                                    ),
                                                    Align(alignment: Alignment
                                                        .center,
                                                      widthFactor: 0.2,
                                                      child: Container(
                                                        width: 2.0,
                                                        height: 50.0,
                                                        decoration: BoxDecoration(
                                                            color: Color(
                                                                0xffF44A4A),
                                                            borderRadius: BorderRadius
                                                                .circular(
                                                                5.0)),),)
                                                  ],
                                                ),
                                                SizedBox(height: 10.0),
                                                Row(
                                                  children: [
                                                    Image.asset(Img.empImage,
                                                      width: 15.0,),
                                                    SizedBox(width: 5.0),
                                                    Expanded(child: Constants
                                                        .selectedFontWidget(
                                                        "name",
                                                        Color(0xff757474),
                                                        12.0, FontWeight.bold))
                                                  ],
                                                ),
                                                SizedBox(height: 10.0),
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                      Img.notesTitleImage,
                                                      width: 15.0,),
                                                    SizedBox(width: 5.0),
                                                    Constants
                                                        .selectedFontWidget(
                                                        closedTicketList[i]
                                                            .ticketDate,
                                                        Color(0xff757474),
                                                        12.0, FontWeight.bold),
                                                    SizedBox(width: 10.0),
                                                    Image.asset(
                                                      Img.clock, width: 15.0,),
                                                    SizedBox(width: 5.0),
                                                    Constants
                                                        .selectedFontWidget(
                                                        closedTicketList[i]
                                                            .ticketTime,
                                                        Color(0xff757474),
                                                        12.0, FontWeight.bold),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ), SizedBox(width: 10.0),
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
    } else {
      return Container();
    }
  }

  _KIVTasks() {
    if (KIVTicketList.length > 0) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("KIV", style: TextStyle(fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: ColorsUsed.textBlueColor),),
          SizedBox(height: 10.0,),
          Container(height: 170.0,
            child: Column(
              children: [
                Expanded(child: Row(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: KIVTicketList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, i) {
                            return Row(
                              children: [
                                SizedBox(
                                  height: 150.0,
                                  width: Constants().containerWidth(context) *
                                      0.65,
                                  child: InkWell(
                                    onTap: () {
                                      /* Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                                        TaskDetails(KIVTicketList[i].id))).then((value) {
                                      if(value == true){
                                        setState(() {
                                          _loading = true;
                                        });_getActiveTaskLists();
                                      }

                                    });*/
                                    },
                                    child: Card(elevation: 30.0,
                                      shadowColor: Color(0xFFE0CC12),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              25.0)),
                                      child: Row(
                                        children: [
                                          SizedBox(width: 20.0),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [SizedBox(height: 20.0),
                                                Stack(
                                                  children: [
                                                    Container(height: 50.0,
                                                      padding: EdgeInsets
                                                          .fromLTRB(
                                                          10.0, 0.0, 0.0, 0.0),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  KIVTicketList[i]
                                                                      .ticketTitle
                                                                      .length >
                                                                      20 ?
                                                                  KIVTicketList[i]
                                                                      .ticketTitle
                                                                      .substring(
                                                                      0, 17) +
                                                                      "..." :
                                                                  KIVTicketList[i]
                                                                      .ticketTitle
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize: 15.0,
                                                                      fontWeight: FontWeight
                                                                          .bold,
                                                                      color: ColorsUsed
                                                                          .textBlueColor),),
                                                              ),
                                                              SizedBox(
                                                                  width: 5.0),
                                                              Image.asset(
                                                                "Images/Group 15.png",
                                                                width: 5.0,
                                                              ),
                                                              SizedBox(
                                                                  width: 5.0),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                              height: 10.0),
                                                          Text(KIVTicketList[i]
                                                              .description
                                                              .length > 20
                                                              ?
                                                          KIVTicketList[i]
                                                              .description
                                                              .substring(
                                                              0, 20) + "..."
                                                              : KIVTicketList[i]
                                                              .description,
                                                            style: Constants()
                                                                .txtStyleFont16(
                                                                Colors
                                                                    .grey[500],
                                                                12.0),),
                                                        ],
                                                      ),
                                                    ),
                                                    Align(alignment: Alignment
                                                        .center,
                                                      widthFactor: 0.2,
                                                      child: Container(
                                                        width: 2.0,
                                                        height: 50.0,
                                                        decoration: BoxDecoration(
                                                            color: Color(
                                                                0xffE0CC12),
                                                            borderRadius: BorderRadius
                                                                .circular(
                                                                5.0)),),)
                                                  ],
                                                ),
                                                SizedBox(height: 10.0),
                                                Row(
                                                  children: [
                                                    Image.asset(Img.empImage,
                                                      width: 15.0,),
                                                    SizedBox(width: 5.0),
                                                    Expanded(child: Constants
                                                        .selectedFontWidget(
                                                        "name",
                                                        Color(0xff757474),
                                                        12.0, FontWeight.bold))
                                                  ],
                                                ),
                                                SizedBox(height: 10.0),
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                      Img.notesTitleImage,
                                                      width: 15.0,),
                                                    SizedBox(width: 5.0),
                                                    Constants
                                                        .selectedFontWidget(
                                                        KIVTicketList[i]
                                                            .ticketDate,
                                                        Color(0xff757474),
                                                        12.0, FontWeight.bold),
                                                    SizedBox(width: 10.0),
                                                    Image.asset(
                                                      Img.clock, width: 15.0,),
                                                    SizedBox(width: 5.0),
                                                    Constants
                                                        .selectedFontWidget(
                                                        KIVTicketList[i]
                                                            .ticketTime,
                                                        Color(0xff757474),
                                                        12.0, FontWeight.bold),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ), SizedBox(width: 10.0),
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
    } else {
      return Container();
    }
  }


  void getData() async {
    var loader=Constants.loader(context);
    await loader.show();
    print("${Constants.BaseUrl}action=myTicketsList&userId=${Constants.userId}");
    try {
      await http.get(
        //  "${Constants.BaseUrl}action=myTicketsList&userId=8")
          "${Constants.BaseUrl}action=myTicketsList&userId=${Constants.userId}")
          .then((res) {
        print(res.body);
        print("status${res.body}");
        loader.hide();
        setState(() {
          _loading = false;
          _response = json.decode(res.body);
        });
        final int statusCode = res.statusCode;
        print(statusCode);
        if (statusCode == 200) {
          print("check 200${_response["success"]}");
          if (_response["success"] == "1") {

            setState(() {
              ticketPojo = TicketPojo.fromJson(_response);
            });
            for (int i = 0; i < ticketPojo.myTicketsList.length; i++) {
              //ticketPojo.myTicketsList[i].status=="1"for open tickets,2 for closed nd 3 for kiv
              if (ticketPojo.myTicketsList[i].status == 1) {
                setState(() {
                  activeTicketList.add(ticketPojo.myTicketsList[i]);
                });
              } else if (ticketPojo.myTicketsList[i].status == 2) {
                setState(() {
                  closedTicketList.add(ticketPojo.myTicketsList[i]);
                });
              } else if (ticketPojo.myTicketsList[i].status == 3) {
                setState(() {
                  KIVTicketList.add(ticketPojo.myTicketsList[i]);
                });
              }
            }
            print(activeTicketList.length);
            print(KIVTicketList.length);
            print(closedTicketList.length);
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

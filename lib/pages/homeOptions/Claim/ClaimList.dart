import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/Images_path.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/Utiles/strings.dart';
import 'package:newproject/models/MyNotesModel.dart';
import 'package:newproject/models/myTaskModel.dart';
import 'package:newproject/pages/SearchPage.dart';
import 'package:newproject/common/ImagePreview.dart';
import 'package:newproject/pages/homeOptions/Add_Notes/Add_Notes.dart';
import 'package:newproject/pages/homeOptions/Claim/AddClaim.dart';
import 'package:newproject/pages/homeOptions/Claim/ClaimPojo.dart';

class ClaimList extends StatefulWidget {
  @override
  _ClaimListState createState() => _ClaimListState();
}

class _ClaimListState extends State<ClaimList> {
//  ClaimPOJO claimPOJO = ClaimPOJO();
  List<ClaimPojo> listClaim = List<ClaimPojo>();
  var responseList;
  var _response;
  bool _loading = true , isPlaying = false;
  int _activeElevationId = -1;
  AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
//    _loading = true;
    _audioPlayer = AudioPlayer();

    getClaimAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: _appBarOptions(),
        floatingActionButton: FloatingActionButton(
          tooltip: "Add Claim",
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => AddClaim())).then((value) {
              if(value){
                setState(() {
                  _loading = true;
                  listClaim = [];
                });getClaimAPI();
              }
            });
          },
          child: Icon(Icons.add),
        ),
        body: _loading?Center(child: Constants().spinKit):Container(
            padding: EdgeInsets.fromLTRB(25.0, 20.0, 20.0, 25.0),
            child: _cardOfNotes()));
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
              Image.asset(Img.myOfficeImage,width: 20.0),
              SizedBox(width: 10.0,),
              Text(
                "My Claims",
                style: Constants().txtStyleFont16(ColorsUsed.whiteColor, 20.0),
              ),
            ],
          ),
          actions: [
            IconButton(
                icon: Image.asset(
                  "Images/home/Group 1.png",
                  width: 25.0,
                ),
                onPressed: () {
                  print('search');
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SearchPage(1)));
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

  Future<void> getClaimAPI() async {
    print("${Constants.BaseUrl}action=claimList&userId=${Constants.userId}");
    try {
      await http
          .get(
          "${Constants.BaseUrl}action=claimList&userId=${Constants.userId}")
//          "${Constants.BaseUrl}action=claimList&userId=")
          .then((res) {
        print(res.body);
        setState(() {
          _loading = false;
          AudioPlayer _audioPlayer = AudioPlayer();

          _response = json.decode(res.body);
          responseList = _response["list"];
        });
        final int statusCode = res.statusCode;

        print(_response);
        if (statusCode == 200) {
          print("check 200${_response["success"]}");
          if (_response["success"] == "1") {
            print("enytet");

            for (int i = 0; i < responseList.length; i++) {
              //   imgStr.split(",").map((String text) => propertyPic.add(NetworkImage(text))).toList();
              setState(() {
                listClaim.add(ClaimPojo(
                  claimName: responseList[i]["claimName"],
                  description: responseList[i]["description"],
                  title: responseList[i]["title"],
                  imageUrl: responseList[i]["imageUrl"],
                ));
//              claimPOJO = ClaimPOJO.fromJson(json.decode(_response));
              });
            }
          } else {
            setState(() {
              listClaim = [];
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
      setState(() {
        _loading = false;
      });
    }
  }

  _cardOfNotes() {
    if (listClaim.length>0) {
      //    List<NetworkImage> propertyPic = new List<NetworkImage>();
      return _loading
          ? Center(child: Constants().spinKit)
          : ListView.builder(
          itemCount: listClaim.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    if(_activeElevationId == index) {
                      setState(() {
                        _activeElevationId = -1;
                      });
                    }else{
                      setState(() {
                        _activeElevationId = index;
                      });
                    }
                  },
                  child: Card(
                    elevation:
                    _activeElevationId == index ? 20.0 : 0.0,
                    shadowColor: ColorsUsed.textBlueColor,
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
                              child: Text(listClaim[index].title.substring(0,1).toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: ColorsUsed.whiteColor)),
                            ),SizedBox(width: 10),
                            Expanded(
                              child: Text(listClaim[index].title, style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: ColorsUsed.textBlueColor)),
                            ),SizedBox(width: 10),
                            Icon(_activeElevationId == index?Icons.arrow_drop_up:Icons.arrow_drop_down)
                            ,SizedBox(width: 15),],
                        ),
                        _activeElevationId == index?
                        _notesDetails(index):Container(),
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


  _notesDetails(int index) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
       /* Row(
          children: [SizedBox(width: 20),
            Icon(Icons.calendar_today,size: 11.0,color: Colors.grey[500],),
            SizedBox(width: 10),
            Text(listClaim[index].date.substring(0,10),
                style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[500]))
          ],
        ),*/
        SizedBox(height: 20.0),
        Row(
          children: [SizedBox(width: 15),
            Expanded(
              child: Text(listClaim[index].claimName,
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: ColorsUsed.textBlueColor))),
            SizedBox(width: 15),],
        ),
        SizedBox(height: 15),
        Row(
          children: [SizedBox(width: 15),
            Text("Description",
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: ColorsUsed.textBlueColor)),
          ],
        ),
        Row(
          children: [SizedBox(width: 15),
            Expanded(
              child: Text(
                listClaim[index].description,
                style: Constants().txtStyleFont16(
                    Colors.grey[500], 12.0),
              ),
            ),
            SizedBox(width: 15), ],
        ),
        SizedBox(height: 20.0),
        listClaim[index].imageUrl=="null"?Container():Row(
          children: [SizedBox(width: 15),
            Text("Attachment",
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: ColorsUsed.textBlueColor)),
          ],
        ),
        SizedBox(height : listClaim[index].imageUrl=="null"?0:15),
        listClaim[index].imageUrl=="null"?Container():Row(
          children: [
            SizedBox(width: 15),
             Image.network(Constants.ImageBaseUrl+listClaim[index].imageUrl,height: 70.0,width: 70.0,)
//            showImage(context, listClaim[index].imageUrl, listClaim[index].claimType),
          ],
        ),

//         listClaim[index].images!= null?ListView(
//           shrinkWrap: true,
//           children: listClaim[index].images
//               .map((imgUrl) => InkWell(
//             onTap: (){
//
//               print(imageUrl.substring(13,13));
//               Navigator.push(context, MaterialPageRoute(builder: (context) =>
//                           ImagePreview(imageUrl, listClaim[index].name)));
//             },
//                 child: Container(height: 70.0,width: 100.0,
//             decoration: BoxDecoration(image: DecorationImage(image: imgUrl,)),
//           ),
//               ))
//               .toList(),
//         ):Text("No attachment found "),
//        Row(
//          children: [
//            Icon(
//              Icons.alarm,
//              size: 15,
//              color: Colors.grey[500],
//            ),
//            SizedBox(width: 3.0),
//            Text(listClaim[index].time,
//                style: TextStyle(
//                    fontSize: 12.0,
//                    fontWeight: FontWeight.bold,
//                    color: Colors.grey[500]))
//          ],
//        ),
      ],
    );
  }
}

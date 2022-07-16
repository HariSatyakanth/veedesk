import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/Images_path.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/Utiles/strings.dart';
import 'package:newproject/common/MutlipleImages.dart';
import 'package:newproject/models/MyNotesModel.dart';
import 'package:newproject/models/myTaskModel.dart';
import 'package:newproject/pages/SearchPage.dart';
import 'package:newproject/common/ImagePreview.dart';
import 'package:newproject/pages/homeOptions/Add_Notes/Add_Notes.dart';

class MyNotes extends StatefulWidget {
  @override
  _MyNotesState createState() => _MyNotesState();
}

class _MyNotesState extends State<MyNotes> {
  List<AddNoteModel> myNotesList;
  List<AddNoteModel> mainList;
  var responseList;
  var _response;
  bool _loading , isPlaying = false;
  int _activeElevationId = -1;
  AudioPlayer _audioPlayer;
  var searchController=TextEditingController();
  @override
  void initState() {
    super.initState();
    _loading = true;

    myNotesList = new List<AddNoteModel>();
    mainList = new List<AddNoteModel>();
    _audioPlayer = AudioPlayer();

    getNotesAPI();
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
                builder: (context) => AddNotes())).then((value) {
                  if(value){
                    setState(() {
                      _loading = true;
                      myNotesList.clear();
                    });getNotesAPI();
                  }
            });
          },
          child: Icon(Icons.add),
        ),
        body: _loading?Center(child: Constants().spinKit):
        Container(padding: EdgeInsets.fromLTRB(25.0, 20.0, 20.0, 25.0),
           child: Column(
             children: [
               searchTab(),
               _cardOfNotes()
             ],
           ), ));
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
                "My Notes",
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

  Future<void> getNotesAPI() async {
    try {
      await http
          .get(
           //   "${Constants.BaseUrl}action=noteAllList&userId=100")
              "${Constants.BaseUrl}action=noteAllList&userId=${Constants.userId}")
          .then((res) {
        setState(() {
          _loading = false;
          _response = json.decode(res.body);
          responseList = _response["noteList"];
        });
        final int statusCode = res.statusCode;
        if (statusCode == 200) {
          print("check 200${_response["success"]}");
          if (_response["success"] == "1") {
            for (int i = 0; i < responseList.length; i++) {
              //   imgStr.split(",").map((String text) => propertyPic.add(NetworkImage(text))).toList();
              setState(() {
                myNotesList.add(AddNoteModel(
                  id: responseList[i]["id"],
                  name: responseList[i]["title"],
                  discription: responseList[i]["discription"],
                  audioUrl:
                      Constants.getAudioUrl(responseList[i]["audioUpload"]),
                  time: responseList[i]["agging"],
                  date: responseList[i]["dateTime"],
                  images:
                      Constants.getImageArray(responseList[i]["imageUpload"]),
                ));
                mainList.add(myNotesList[i]);
              });
            }
          } else {
            setState(() {
              _loading = false;
            });
            Constants.showToast("No notes found.");
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
    if (myNotesList.length > 0) {
      //    List<NetworkImage> propertyPic = new List<NetworkImage>();
      return _loading
          ? Center(child: Constants().spinKit)
          : Expanded(
            child: ListView.builder(
                itemCount: myNotesList.length,
//              shrinkWrap: true,
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
                                    child: Text(myNotesList[index].name.substring(0,1).toUpperCase(),
                                        style: TextStyle(
                                        fontSize: 15.0,fontFamily: "Montserrat",
                                        fontWeight: FontWeight.bold,
                                        color: ColorsUsed.whiteColor)),
                                  ),SizedBox(width: 10),
                                  Expanded(
                                    child: Text(myNotesList[index].name, style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,fontFamily: "Montserrat",
                                            color: ColorsUsed.baseColor)),
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
                }),
          );
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

  _notesDetails(int index) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Row(
          children: [SizedBox(width: 20),
            Icon(Icons.calendar_today,size: 11.0,color: Colors.grey[500],),
            SizedBox(width: 10),
            Text(myNotesList[index].date.substring(0,10),
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
              myNotesList[index].discription,
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
            showImage(context, myNotesList[index].images, myNotesList[index].name),
          ],
        ),

//         myNotesList[index].images!= null?ListView(
//           shrinkWrap: true,
//           children: myNotesList[index].images
//               .map((imgUrl) => InkWell(
//             onTap: (){
//
//               print(imageUrl.substring(13,13));
//               Navigator.push(context, MaterialPageRoute(builder: (context) =>
//                           ImagePreview(imageUrl, myNotesList[index].name)));
//             },
//                 child: Container(height: 70.0,width: 100.0,
//             decoration: BoxDecoration(image: DecorationImage(image: imgUrl,)),
//           ),
//               ))
//               .toList(),
//         ):Text("No attachment found "),

        SizedBox(height: 20.0),
        Row(
          children: [SizedBox(width: 20),
            Text("Audio",
              style: TextStyle(
                  fontSize: 16.0,fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                  color: ColorsUsed.baseColor)
            ),SizedBox(width: 20),
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
                          : play(myNotesList[index]
                          .audioUrl);
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

//        Row(
//          children: [
//            Icon(
//              Icons.alarm,
//              size: 15,
//              color: Colors.grey[500],
//            ),
//            SizedBox(width: 3.0),
//            Text(myNotesList[index].time,
//                style: TextStyle(
//                    fontSize: 12.0,
//                    fontWeight: FontWeight.bold,
//                    color: Colors.grey[500]))
//          ],
//        ),
      ],
    );
  }

    searchTab() {
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
          print(value);
          if(value.length>0) {
          setState(() {
            myNotesList.clear();
            _searchactiveTaskLists(value);
          });


          }else{
            print("empy");
            setState(() {
              myNotesList.clear();
              for(int i=0;i<mainList.length;i++){
                  print(mainList[i].name);
                  setState(() {
                    myNotesList.add(mainList[i]);
                  });

              }

            });

          }
        },
      );
    }

   void _searchactiveTaskLists(String value) {


    for(int i=0;i<mainList.length;i++){
      if(mainList[i].name.contains(new RegExp(r'' + value, caseSensitive: false))){
        print(mainList[i].name);
       setState(() {
         myNotesList.add(mainList[i]);
       });
      }
    }

   }
  }

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/Images_path.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/common/FilePageAPi.dart';
import 'package:newproject/models/LeaderBoardPOJO.dart';

class LeaderBoard extends StatefulWidget {
  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  LeaderBoardPOJO leaderBoard = LeaderBoardPOJO();
  List<LeaderBoardList> listOfNewData = List<LeaderBoardList>();
  bool _loading = true;

  @override
  void initState() {
    getLeaderBoardList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Constants().containerHeight(context)*0.4),
        child: _loading?Container():Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft:Radius.circular(30.0),bottomRight: Radius.circular(30.0),
              ),
              child: AppBar(elevation: 0.0,
                title: Row(
                  children: [SizedBox(width: 35.0),
                    CircleAvatar(child: Image.asset(Img.myOfficeImage,width: 20.0,),radius: 15.0,
                    backgroundColor: Colors.black,),
                    SizedBox(width: 5.0),
                    Text("LeaderBoard",
                      style: Constants().txtStyleFont16(Colors.black,20.0),),
                  ],
                ),
                centerTitle: true,
                flexibleSpace:  Container(
                  decoration:
                  BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("Images/LeaderBoard/Rectangle 2.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0.0, 0.7),
//              translation: Offset(0.75,0.8),
              child: Image.asset("Images/LeaderBoard/user 2 (1).png",width: Constants().containerWidth(context)*0.4,),
            ),
            //Center no 1 employee
            Align(
              alignment: Alignment(0.02, 0.25),
              child: CircleAvatar(radius: 42.0,backgroundColor: Color(0xffE3A327),
                child:  CircleAvatar(
                  backgroundImage: NetworkImage(
                    leaderBoard.leaderBoardList == null?Constants.USER_IMAGE:
                    leaderBoard.leaderBoardList[0].userImg,
                  ),
                  radius: 40.0,),
              ),
            ),
            Align(
              alignment: Alignment(-0.9, 0.88),
//              translation: Offset(0.1,1.5),
              child: Image.asset("Images/LeaderBoard/user 2 (1).png",width: Constants().containerWidth(context)*0.3,),
            ),
            //Center no 2 employee
            Align(
              alignment: Alignment(-0.75, 0.55),
              child: CircleAvatar(radius: 32.0,backgroundColor: Color(0xffE3A327),
                child:  CircleAvatar(
                  backgroundImage: NetworkImage(
                    leaderBoard.leaderBoardList == null?Constants.USER_IMAGE:
                    leaderBoard.leaderBoardList[1].userImg,
                  ),
                  radius: 30.0,),
              ),
            ),
            Align(
              alignment: Alignment(0.91, 0.9),
//              translation: Offset(2.5,1.8),
              child: Image.asset("Images/LeaderBoard/user 2 (1).png",width: Constants().containerWidth(context)*0.27,),
            ),
            //Center no 3 employee
            Align(
              alignment: Alignment(0.8, 0.60),
              child: CircleAvatar(radius: 27.0,backgroundColor: Color(0xffE3A327),
                child:  CircleAvatar(
                  backgroundImage: NetworkImage(
                    leaderBoard.leaderBoardList == null?Constants.USER_IMAGE:
                    leaderBoard.leaderBoardList[2].userImg,
                  ),
                  radius: 25.0,),
              ),
            ),
            Align(
                alignment: Alignment(0.8, 0.20),
              child: Container(
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                    children: [
                      Constants.selectedFontWidget(leaderBoard.leaderBoardList[1].name,
                          ColorsUsed.whiteColor, 12.0, FontWeight.w500)
                    ],
              ),
                  ],
                ),)
            )
          ],
        ),
      ),
      body: _loading?Center(child: Constants().spinKit,):Container(
        child: ListView.builder(
          itemCount: listOfNewData.length,
            itemBuilder: (context, i){
              return Card(margin: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
                elevation: 10.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                child: Container(padding: EdgeInsets.fromLTRB(15.0, 15.0, 15, 15),
                  child: Row(
                    children: [
                      CircleAvatar(backgroundImage: NetworkImage(listOfNewData[i].userImg),),
                      SizedBox(width: 15.0),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Constants.selectedFontWidget(listOfNewData[i].name,
                                ColorsUsed.textBlueColor, 14.0, FontWeight.bold),
                            SizedBox(height: 5.0),
                            Constants.selectedFontWidget(listOfNewData[i].designation,
                                Color(0xffb3b3b3), 12.0, FontWeight.bold),
                          ],
                        ),
                      ),
                      CircleAvatar(
                        //listOfNewData[i].upDown == 0 means employee score down,and 1 means employee up
                        child: Icon(listOfNewData[i].upDown=="0"?Icons.keyboard_arrow_down:
                        Icons.keyboard_arrow_up,color: ColorsUsed.whiteColor,),
                        backgroundColor: listOfNewData[i].upDown=="0"?Colors.red:Colors.green,)
                    ],
                  ),
                ),
              );
            },),
      ),
    );
  }

  // task Graphs
  getLeaderBoardList()async{

    try{
      var response = await FilePageApi().getRequest("leaderBoardList",context);
      var responseList = await json.decode(response.body);
      print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.body);
        if(responseList["success"]=="1"){
          setState((){
            _loading = false;
            leaderBoard = LeaderBoardPOJO.fromJson(json.decode(response.body));
            listOfNewData = leaderBoard.leaderBoardList.sublist(3);
          });print("leaderBoard${leaderBoard.leaderBoardList[0].name}");
          print("leaderBoard${listOfNewData[0].name}");
        }else{
          Constants.showToast("No data found");
          Navigator.pop(context);
        }

      }
      else{
        Constants.showToast(responseList["error"]);
      }
    }on SocketException {
      Constants().noInternet(context);
    }
  }

}

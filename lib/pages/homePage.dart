import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newproject/Interfaces/callBackWidget.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/Images_path.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/Utiles/strings.dart';
import 'package:newproject/Utiles/widgets.dart';
import 'package:newproject/pages/homeOptions/ExpenseTracker/ExpenseForm.dart';
import 'package:newproject/pages/homeOptions/JitsiMeet/MeetingList.dart';
import 'package:newproject/pages/homeOptions/KPICharts.dart';
import 'package:newproject/pages/homeOptions/Queries/recieved_query.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:newproject/pages/homeOptions/Add_Notes/MyNotes.dart';
import 'package:newproject/pages/DashboardSearch.dart';
import 'package:newproject/pages/homeOptions/Claim/ClaimList.dart';
import 'package:newproject/pages/homeOptions/Files/My_Files.dart';
import 'package:newproject/pages/homeOptions/Inventory/InventoryList.dart';
import 'package:newproject/pages/homeOptions/LeaderBoard/LeaderBoard.dart';
import 'package:newproject/pages/homeOptions/MyContacts/MyContactList.dart';
import 'package:newproject/pages/homeOptions/MyContacts/chatDialog.dart';
import 'package:newproject/pages/homeOptions/MyLeaves/LeaveList.dart';
import 'package:newproject/pages/homeOptions/PaySlip/MyPaySlip.dart';
import 'package:newproject/pages/homeOptions/Tasks/AddNewTask.dart';
import 'package:newproject/pages/homeOptions/Tasks/my_tasks.dart';
import 'package:newproject/pages/homeOptions/Tickets/TicketList.dart';
import 'package:newproject/pages/homeOptions/WorkLog/WorkLogList.dart';
import 'package:newproject/pages/homeOptions/groupChat.dart';
import 'package:newproject/pages/homeOptions/log_me_in.dart';
import 'package:newproject/pages/homeOptions/offer/MyOffers.dart';
import 'package:newproject/pages/homeOptions/queryDirectory/my_queries.dart';
import 'package:newproject/pages/homeOptions/attendanceModule/UseFriendAttendance.dart';
import 'package:newproject/pages/myProfile.dart';
import 'homeOptions/Events/MyEvent.dart';
import 'homeOptions/Graphs.dart';
import 'homeOptions/Leads/my_leads.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>with SingleTickerProviderStateMixin implements WidgetCallBack{
  int _clickId = 0;
  String mainOptionClick = S.DAILY_ID;
  TabController _controller;
  bool _login=false;
  PageController _mainOptionController = PageController();
  static int _selectedPage = 0;
 /* List<Widget> list = [
    Tab(child: CircleAvatar(backgroundColor:
    _selectedTab == 0?ColorsUsed.baseColor:Colors.white,radius: 2.0,),),
    Tab(child: CircleAvatar(backgroundColor:
    _selectedTab == 1?ColorsUsed.baseColor:Colors.white,radius: 2.0,)),
  ];*/

 final GlobalKey _scaffoldKey = new GlobalKey();

  @override
  void initState(){
    super.initState();
    checkCheckInStatus();
    //_controller = TabController(length: list.length, vsync: this);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Widgets().appDrawer(context,Constants.userName,Constants.imageUrl),
      backgroundColor: Color(0xffF9F9F9),
      appBar: _appBarOptions(),
      body: SingleChildScrollView(
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Container(//height: Constants().containerHeight(context),
              padding: EdgeInsets.only(top: 15.0,bottom: 20.0),
              child: Column(
                children: <Widget>[
                  Container(margin: EdgeInsets.all(0.2),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(25.0),
                        color: ColorsUsed.baseColor,),
                      padding: EdgeInsets.only(top: 20.0,left: 40.0),
                      height: Constants().containerHeight(context)*0.13,
                      width: Constants().containerWidth(context),
                      child: Text(S.welcome,
                        textAlign: TextAlign.start,
                        style: Constants().txtStyleFont16(ColorsUsed.whiteColor,18.0),
                      ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(00.0,Constants().containerHeight(context)*0.12, 00.0, 0.0),
                    child: Container(height: 130.0,
                      child: PageView(
                        controller: _mainOptionController,
                        scrollDirection: Axis.horizontal,
                        children: [
                          mainOptionCard1(),mainOptionCard2()
                        ],
                      ),
                    )
                  ),
                  Divider(thickness: 2.0,),
                  SizedBox(height: 10.0,),
                 Container(height: 290.0,
                   child: PageView(
                     onPageChanged: (selectedPage){
                       setState(() {
                         _selectedPage = selectedPage;
                       });
                     },
                     scrollDirection: Axis.horizontal,
                     children: [
                       _page1(),
                       _page2(),
                     ],
                   ),
                 ),
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(backgroundColor: _selectedPage==0?ColorsUsed.baseColor:Colors.grey,radius: 5.0,),
                      SizedBox(width:5.0),
                      CircleAvatar(backgroundColor: _selectedPage==1?ColorsUsed.baseColor:Colors.grey,radius: 5.0,),
                    ],
                  ),
                  SizedBox(height:10.0),
                  Container(height: 80.0,
                    child: PageView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        bottomOptionCard1(),bottomOptionCard2()
                      ],
                    ),
                  ),

                 /* _cardRow1(),
                 _cardRow2(),
                 _cardRow3(),*/

                ],
              ),
            ),
            Positioned(
              top: Constants().containerWidth(context)*0.2,
              left: 50.0,
              child: Card(elevation: 5.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),),
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile(0)));
                },
                child:Container(
                  padding: EdgeInsets.all(10.0),
                  width: Constants().containerWidth(context)/1.4,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0),
                    color: Color(0xffECECFD),),
                  child: Row(
                    children: <Widget>[


                      CircleAvatar(radius: 25.0,
                        backgroundImage: NetworkImage(
                          Constants.imageUrl == null?Constants.USER_IMAGE:Constants.imageUrl,
                        ),
                        /* child: ClipRRect(
                   borderRadius: BorderRadius.circular(20.0),
                     child: Constants.imageUrl == null?CircularProgressIndicator(
                       strokeWidth: 1.0,backgroundColor: Colors.white,):Image.network(
                       Constants.imageUrl == "null"?Constants.USER_IMAGE:Constants.imageUrl,
                       fit: BoxFit.fill,)),*/),
                      SizedBox(width: 10.0,),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Constants.userName == ""?CircularProgressIndicator(strokeWidth: 1.0 ,):Text(Constants.userName == ""?"-":Constants.userName,
                              style: Constants().txtStyleFont16(Colors.black,14.0),),
                            Row(
                              children: <Widget>[
                                Text("Developer",
                                    style: TextStyle(color: Colors.grey,)),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),)
//            _employeeDetails()
          ],
        ),
      ),
    );
  }

  _page1(){
    return Container(padding: EdgeInsets.fromLTRB(25.0,0.0, 25.0, 20.0),
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Expanded(
                child: _dashboardCard(S.TASK, _clickId == 2?Constants.taskImageFade:Constants.taskImage, 2),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: _dashboardCard(S.LEAD, _clickId == 3?Constants.leadImageFade:Constants.leadImage, 3),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            children: <Widget>[
              Expanded(
                child: _dashboardCard(S.WorkLog,  _clickId == 11?Img.worklogfadeImage:Img.worklogImage, 11),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: _dashboardCard(S.inventory,  _clickId == 18?Img.inventoryFadeHome:Img.inventoryHome, 18),
              ),
              /*Expanded(
                child: _dashboardCard(S.MyClaims, _clickId == 14?Constants.eventImageFade:Constants.eventImage, 14),
              ),*/
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            children: <Widget>[
              Expanded(
                child: _dashboardCard(S.queries,  _clickId == 5?Constants.queryImageFade:Constants.queryImage, 5),
              ),
              /*Expanded(
                child: _dashboardCard(S.discuss,  _clickId == 6?Constants.discussImageFade:Constants.discussImage, 6),
              ),*/
              SizedBox(width: 10.0),
              Expanded(
                child: _dashboardCard(S.expense,  _clickId == 19?Img.expenseFadeHome:Img.expenseHome, 19),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _page2(){
    return Container(padding: EdgeInsets.fromLTRB(25.0,0.0, 25.0, 20.0),
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Expanded(
                child: _dashboardCard(S.reminder,  _clickId == 20?Img.reminderFadeImage:Img.reminderImage, 20),
              ),
             /* Expanded(
                child: _dashboardCard(S.MyLeaves,  _clickId == 13?Constants.queryImageFade:Constants.queryImage, 13),
              ),*/
              SizedBox(width: 10.0),
              Expanded(
                child: _dashboardCard(S.ticket,  _clickId == 21?Img.ticketFadeImage:Img.ticketImage, 21),
              ),
              /*Expanded(
                child: _dashboardCard(S.LeaderBoard,  _clickId == 15?Constants.queryImageFade:Constants.queryImage, 15),
              ),*/
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            children: <Widget>[
              Expanded(
                child: _dashboardCard(S.workTag, _clickId == 9?Img.workFadeImage:Img.workTagImage, 9),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: _dashboardCard(S.paySlip,  _clickId == 16?Img.payFadeImage:Img.payImage, 16),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            children: <Widget>[
              Expanded(
                child:  _dashboardCard(S.myOffers,  _clickId == 17?Img.offersHomeImage:Img.offersHomeImage, 17),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child:  _dashboardCard(S.knowedgeBase,  _clickId == 22?Img.knowledgeFadeImage:Img.knowledgeImage, 22),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //Option for attedance module

  _attendanceOption(){
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Select Option"),
            content: Container(
              height: Constants().containerWidth(context)*0.5,
              decoration: BoxDecoration(),
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: _dashboardCard(S.logMe, _clickId == 1?Constants.logImageFade:Constants.logImage, 1),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: _dashboardCard(S.use_friend, _clickId == 10?Constants.logImageFade:Constants.logImage, 10),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
             FlatButton(
                //Click on yes to perform operation according to use
                onPressed: () {
                  Navigator.pop(context);
                },
                child: new Text('Go Back',style: TextStyle(color: ColorsUsed.textBlueColor,fontWeight: FontWeight.w500),),
              ),
            ],
          );
        });
  }


  _employeeDetails() {
    return GestureDetector(
      onTap: (){
        //0 is for when we want back button instead of menu button
        Constants.showToast("msg");
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile(0)));
      },
      child: Align(
        alignment: Alignment(0.0,-3.25),
        heightFactor: 0.1,
        child: Card(elevation: 5.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),),
          child: GestureDetector(
            onTap: (){
              Constants.showToast("ssss");
            },
            child:Container(
            padding: EdgeInsets.all(10.0),
            width: Constants().containerWidth(context)/1.4,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0),
              color: Color(0xffECECFD),),
            child: Row(
              children: <Widget>[


                CircleAvatar(radius: 25.0,
                  backgroundImage: NetworkImage(
                    Constants.imageUrl == null?Constants.USER_IMAGE:Constants.imageUrl,
                  ),
                /* child: ClipRRect(
                   borderRadius: BorderRadius.circular(20.0),
                     child: Constants.imageUrl == null?CircularProgressIndicator(
                       strokeWidth: 1.0,backgroundColor: Colors.white,):Image.network(
                       Constants.imageUrl == "null"?Constants.USER_IMAGE:Constants.imageUrl,
                       fit: BoxFit.fill,)),*/),
                SizedBox(width: 10.0,),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Constants.userName == ""?CircularProgressIndicator(strokeWidth: 1.0 ,):Text(Constants.userName == ""?"-":Constants.userName,
                        style: Constants().txtStyleFont16(Colors.black,14.0),),
                      Row(
                        children: <Widget>[
                          Text("Developer",
                              style: TextStyle(color: Colors.grey,)),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          ),
        ),
      ),
    );
  }

  _appBarOptions() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      leading: Builder(builder: (context)=>IconButton(
          icon: Image.asset("Images/home/menu.png",color: ColorsUsed.baseColor,width: 30.0,),
          onPressed: (){
            Scaffold.of(context).openDrawer();
            print(_scaffoldKey.currentState);
          })),
      title: Image.asset("Images/home/homelogo.png",width: 140.0,),
      centerTitle: true,
      actions: <Widget>[
        IconButton(icon: Image.asset("Images/home/Group 1.png",width: 25.0,),
            onPressed: (){
              print('search');
              Navigator.push(context, MaterialPageRoute(builder: (context)=>DashboardSreach()));

            }
        ),
        SizedBox(width: 10.0,)
      ],
    );
  }

  bottomOptionCard1(){
    return Container(
      child:  Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => MeetingList()));
              },
              child: Image.asset(Img.videoConferenceImage,width: Constants().containerWidth(context)*0.5,)),
          InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => LeaderBoard()));
              },
              child: Image.asset(Img.leaderBoardImage,width: Constants().containerWidth(context)*0.5,)),
//                     SizedBox(width: 20.0,),

        ],
      )
    );
  }

  bottomOptionCard2(){
    return Container(
        child:  Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Graphs()));
                },
                child: Image.asset(Img.analyticsImage,width: Constants().containerWidth(context)*0.5,)),
            InkWell(
                onTap: (){
//                  Constants.showToast("In progress");
                  Navigator.push(context, MaterialPageRoute(builder: (context) => KPICharts()));
                },
                child: Image.asset(Img.kpiImage,width: Constants().containerWidth(context)*0.5,)),
//                     SizedBox(width: 20.0,),

          ],
        )
    );
  }

  mainOptionCard1(){
    return Container(padding: EdgeInsets.fromLTRB(0.0,0.0, 0.0, 20.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: mainOptionCardStructure(_login?S.ATTENDANCE_OUT:S.ATTENDANCE,Img.newAttendanceImage, S.ATTENDANCE_ID,this),
          ),
          Expanded(
            child: mainOptionCardStructure(S.CALENDAR,Img.calendarImage, S.CALENDAR_ID,this),
          ),
          chatStructure(S.CHAT,Img.chatImage,S.CHAT_ID,this),
          Expanded(
            child: mainOptionCardStructure(S.MORE,Img.moreImage, "29",this),
          ),
        /*  IconButton(onPressed: (){

           },icon: Icon(Icons.chevron_right,size: 40.0,color: Colors.grey,),)*/
          /*Constants.selectedFontWidget("More", Colors.grey, 15.0, FontWeight.bold),*/
          SizedBox(width: 10.0),
        ],
      ),
    );
  }

  mainOptionCard2(){
    return Container(padding: EdgeInsets.fromLTRB(0.0,0.0, 0.0, 30.0),
      child: Row(
        children: <Widget>[
          Expanded(child: mainOptionCardStructure(S.File,Img.fileImage, S.ATTENDANCE_ID,this)),
          Expanded(
            child: mainOptionCardStructure(S.MyContact,Img.contactBookImage, S.DAILY_ID,this),
          ),

          Expanded(
            child: mainOptionCardStructure(S.MyClaims,Img.claimImage, S.CALENDAR_ID,this),
          ),

          Expanded(
            child: mainOptionCardStructure(S.MyLeaves,Img.leaveImage,S.CHAT_ID,this),
          ),
        ],
      ),
    );
  }

  _cardRow1() {
   if(mainOptionClick == S.ATTENDANCE_ID){
     return Container(padding: EdgeInsets.fromLTRB(25.0,0.0, 25.0, 20.0),
       child: Row(
         children: <Widget>[
           Expanded(
             child: _dashboardCard(S.logMe, _clickId == 1?Constants.logImageFade:Constants.logImage, 1),
           ),
           SizedBox(width: 10.0),
           Expanded(
             child: _dashboardCard(S.use_friend, _clickId == 10?Constants.logImageFade:Constants.logImage, 10),
           ),
         ],
       ),
     );
   }else if(mainOptionClick == S.DAILY_ID){
     return Container(padding: EdgeInsets.fromLTRB(25.0,0.0, 25.0, 20.0),
       child: Row(
         children: <Widget>[
           Expanded(
             child: _dashboardCard(S.TASK, _clickId == 2?Constants.taskImageFade:Constants.taskImage, 2),
           ),
           SizedBox(width: 10.0),
           Expanded(
             child: _dashboardCard(S.LEAD, _clickId == 3?Constants.leadImageFade:Constants.leadImage, 3),
           ),
         ],
       ),
     );
   }else if(mainOptionClick == S.CALENDAR_ID){
     return Container(padding: EdgeInsets.fromLTRB(25.0,0.0, 25.0, 20.0),
       child: Row(
         children: <Widget>[
           Expanded(
             child: _dashboardCard(S.event, _clickId == 7?Constants.eventImageFade:Constants.eventImage, 7),
           ),
           SizedBox(width: 10.0),
           Expanded(
             child: _dashboardCard(S.MyClaims, _clickId == 14?Constants.eventImageFade:Constants.eventImage, 14),
           ),
         ],
       ),
     );
   }else if(mainOptionClick == S.CHAT_ID){
     return Container(padding: EdgeInsets.fromLTRB(25.0,0.0, 25.0, 20.0),
       child: Row(
         children: <Widget>[
           Expanded(
             child: _dashboardCard(S.discuss,  _clickId == 6?Constants.discussImageFade:Constants.discussImage, 6),
           ),
           SizedBox(width: 10.0),
           Expanded(
             child: Container(),
           ),
         ],
       ),
     );
   }else{
     return Container();
   }
  }

  _cardRow2() {
    if(mainOptionClick == S.ATTENDANCE_ID){
      return Container(padding: EdgeInsets.fromLTRB(25.0,0.0, 25.0, 20.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: _dashboardCard(S.MyLeaves,  _clickId == 13?Constants.queryImageFade:Constants.queryImage, 13),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: _dashboardCard(S.LeaderBoard,  _clickId == 15?Constants.queryImageFade:Constants.queryImage, 15),
            ),
          ],
        ),
      );
    }else if(mainOptionClick == S.DAILY_ID){
      return Container(padding: EdgeInsets.fromLTRB(25.0,0.0, 25.0, 20.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: _dashboardCard(S.queries,  _clickId == 5?Constants.queryImageFade:Constants.queryImage, 5),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: _dashboardCard(S.Note, _clickId == 9?Constants.taskImageFade:Constants.taskImage, 9),
            ),
          ],
        ),
      );
    }
    else if(mainOptionClick == S.CALENDAR_ID){
      return Container(padding: EdgeInsets.fromLTRB(25.0,0.0, 25.0, 20.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: _dashboardCard(S.paySlip,  _clickId == 16?Constants.queryImageFade:Constants.queryImage, 16),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child:  _dashboardCard(S.myOffers,  _clickId == 17?Constants.queryImageFade:Constants.queryImage, 17),
            ),
          ],
        ),
      );
    }
    else{
      return Container(padding: EdgeInsets.fromLTRB(25.0,0.0, 25.0, 20.0),
//        child: Row(
//          children: <Widget>[
//            Expanded(
//              child: _dashboardCard(S.myDoc,  _clickId == 4?Constants.docImageFade:Constants.docImage, 4),
//            ),
//            SizedBox(width: 10.0),
//            Expanded(
//              child: _dashboardCard(S.queries,  _clickId == 5?Constants.queryImageFade:Constants.queryImage, 5),
//            ),
//            SizedBox(width: 10.0),
//            Expanded(
//              child: _dashboardCard(S.discuss,  _clickId == 6?Constants.discussImageFade:Constants.discussImage, 6),
//            ),
//          ],
//        ),
      );
    }

  }

  _cardRow3() {
    if(mainOptionClick == S.ATTENDANCE_ID){
      return Container();
    }else if(mainOptionClick == S.DAILY_ID){
      return Container(padding: EdgeInsets.fromLTRB(25.0,0.0, 25.0, 20.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: _dashboardCard(S.WorkLog,  _clickId == 11?Img.worklogfadeImage:Img.worklogImage, 11),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: _dashboardCard(S.MyContact,  _clickId == 12?Img.worklogfadeImage:Img.worklogImage, 12),
            ),
          ],
        ),
      );
    }else if(mainOptionClick == S.CALENDAR_ID){
      return Container(padding: EdgeInsets.fromLTRB(25.0,0.0, 25.0, 20.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: _dashboardCard(S.inventory,  _clickId == 18?Img.worklogfadeImage:Img.worklogImage, 18),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      );
    }
    else{
      return Container(padding: EdgeInsets.fromLTRB(25.0,0.0, 25.0, 20.0),
//        child: Row(
//          children: <Widget>[
//            Expanded(
//              child: _dashboardCard(S.event, _clickId == 7?Constants.eventImageFade:Constants.eventImage, 7),
//            ),
//            SizedBox(width: 10.0),
//            Expanded(
//              child: _dashboardCard(S.graph,  _clickId == 8?Constants.chartImageFade:Constants.chartImage, 8),
//            ),
//            SizedBox(width: 10.0),
//            Expanded(
//              child: Container(width: 30.0,),
//            )
//          ],
//        ),
      );
    }

  }

  Widget _dashboardCard(String value ,imagePath,int id){
    return  InkWell(
      onTap: (){
        _clickOperations(id);
      },
      child: Card(elevation: 6.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Container(
          padding: EdgeInsets.all(15.0),
          decoration: BoxDecoration(gradient: _clickId == id?Constants().baseColorGradient:Constants().whiteGradient,
              borderRadius: BorderRadius.circular(20.0)),
          child: Row(
            children: <Widget>[
              Image.asset(imagePath,width: Constants().containerWidth(context)*0.09,),
              SizedBox(width: 10.0),
              Expanded(
                child: Text(value,
                  textAlign: TextAlign.start,
                  style: Constants().txtStyleFont16(_clickId == id?Colors.white:ColorsUsed.baseColor,13.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  //main option structure
  Widget mainOptionCardStructure(String value ,imagePath,String id,WidgetCallBack widgetCallBack){
    return  InkWell(
      onTap: (){
        widgetCallBack.callBackInterface(value);
      },
      child: Ink(
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(//color: mainOptionClick != id?Color(0xffF9F9F9):Color(0xffEAEAED),
            borderRadius: BorderRadius.circular(15.0)),
        child: Column(
          children: <Widget>[
            Image.asset(imagePath,width: Constants().containerWidth(context)*0.08,),
            SizedBox(height: 10.0),
            Text(value,
              textAlign: TextAlign.start,
              style: Constants().txtStyleFont16(ColorsUsed.baseColor,12.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget chatStructure(String value ,imagePath,String id,WidgetCallBack widgetCallBack){
    return  InkWell(
      onTap: (){
        widgetCallBack.callBackInterface(value);
      },
      child: Ink(
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(//color: mainOptionClick != id?Color(0xffF9F9F9):Color(0xffEAEAED),
            borderRadius: BorderRadius.circular(15.0)),
        child: Column(
          children: <Widget>[
            Image.asset(imagePath,width: Constants().containerWidth(context)*0.115,),
            SizedBox(height: 10.0),
            Text(value,
              textAlign: TextAlign.start,
              style: Constants().txtStyleFont16(ColorsUsed.baseColor,12.0),
            ),
          ],
        ),
      ),
    );
  }

   _clickOperations(int id) {
    switch(id){
      case 1:
        setState(() {
          _clickId =1;
        });print('logme');
        Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeeLoggedIn()));
        break;
      case 2:
        setState(() {
          _clickId =2;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyTasks()));
        break;
      case 3:
        setState(() {
          _clickId =3;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyLeads()));
        break;
      case 4:
        setState(() {
          _clickId =4;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyFiles()));
        break;
      case 5:
        setState(() {
          _clickId =5;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyQuery()));
        break;
      case 6:
        setState(() {
          _clickId =6;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage()));
        break;
      case 7:
        setState(() {
          _clickId =7;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyEvent()));

        break;
      case 8:
        setState(() {
          _clickId =8;
        });
        break;
      case 9:
        setState(() {
          _clickId = 9;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyNotes()));
        break;
      case 10:
        setState(() {
          _clickId = 10;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) => UseFriendAttendance()));
        break;
        //worklog
      case 11:
        setState(() {
          _clickId = 11;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) => WorkLogList()));
        break;
        //contact
      case 12:
        setState(() {
          _clickId = 12;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyContact()));
        break;
      case 13:
        setState(() {
          _clickId = 13;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) => LeaveList()));
        break;
      case 14:
        setState(() {
          _clickId = 14;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) => ClaimList()));
        break;
      case 15:
        setState(() {
          _clickId = 15;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) => LeaderBoard()));
        break;
      case 16:
        setState(() {
          _clickId = 16;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyPaySlip()));
        break;
      case 17:
        setState(() {
          _clickId = 17;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyOffers()));
        break;
      case 18:
        setState(() {
          _clickId = 18;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) => InventoryList()));
        break;
      case 19:
        setState(() {
          _clickId = 19;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) => ExpenseForm()));
        break;
        //20 is for reminder
      case 20:
        setState(() {
          _clickId = 20;
        });
        Constants.showToast("In Progress");
//        Navigator.push(context, MaterialPageRoute(builder: (context) => AddExpense()));
        break;
        //21 is for tickets
      case 21:
        setState(() {
          _clickId = 21;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) => TicketList()));
        break;
        // 22 is for knowledge base
      case 22:
        setState(() {
          _clickId = 22;
        });
        Constants.showToast("In Progress");
//        Navigator.push(context, MaterialPageRoute(builder: (context) => AddExpense()));
        break;
    }
   }

   @override
   callBackInterface(String title) {
   switch(title){
     case S.addTask:
       print("add");
       Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewTask()));
       break;
    case S.audio:
       break;
     case S.LIST_NOTES:
       Navigator.push(context, MaterialPageRoute(builder: (context) => MyNotes()));
       break;
     case S.ATTENDANCE:
       print("ateendance");
       _attendanceOption();
       break;
     case S.ATTENDANCE_OUT:
       print("ateendance");
       _attendanceOption();
       break;
     case S.DAILY:
       print("darrr");
       break;
     case S.CALENDAR:
       print("acalendar");
       Navigator.push(context, MaterialPageRoute(builder: (context) => MyEvent()));
       break;
     case S.CHAT:
       print("chat");
       Navigator.push(context, MaterialPageRoute(builder: (context) => ChatRoom()));
       break;
    case S.File:
       Navigator.push(context, MaterialPageRoute(builder: (context) => MyFiles()));
       break;
     case S.MyContact:
       Navigator.push(context, MaterialPageRoute(builder: (context) => MyContact()));
       break;
     case S.MyClaims:
       Navigator.push(context, MaterialPageRoute(builder: (context) => ClaimList()));
       break;
     case S.MyLeaves:
       Navigator.push(context, MaterialPageRoute(builder: (context) => LeaveList()));
       break;
     case S.MORE:
       _mainOptionController.jumpToPage(1);
       break;
   }
  }

  Future<void> checkCheckInStatus() async  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _login= prefs.getBool('buttonState') ?? false;
  }
}

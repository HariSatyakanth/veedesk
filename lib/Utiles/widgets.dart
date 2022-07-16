import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/Utiles/strings.dart';
import 'package:newproject/pages/homeOptions/Events/MyEvent.dart';
import 'package:newproject/pages/homeOptions/Files/My_Files.dart';
import 'package:newproject/pages/homeOptions/Graphs.dart';
import 'package:newproject/pages/homeOptions/Leads/my_leads.dart';
import 'package:newproject/pages/homeOptions/Tasks/my_tasks.dart';
import 'package:newproject/pages/homeOptions/groupChat.dart';
import 'package:newproject/pages/homeOptions/log_me_in.dart';
import 'package:newproject/pages/homeOptions/queryDirectory/my_queries.dart';
import 'package:newproject/pages/myProfile.dart';

class Widgets{

  String menuImage1 = "Images/drawer/logme.png",
      menuImage2 = "Images/drawer/my-tasks.png",
      menuImage3 = "Images/drawer/leads.png",
      menuImage4 = "Images/home/doc (1).png",
      menuImage5 = "Images/drawer/query.png",
      menuImage6 = "Images/drawer/chat.png",
      menuImage7 = "Images/drawer/event.png",
      menuImage8 = "Images/drawer/chart.png",
      menuImage9 = "Images/drawer/phone.png",
     menuImage10 = "Images/drawer/logout.png";

  Widget appDrawer(BuildContext context,String name,profilePhoto){
    return Drawer(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(10.0, Constants().containerHeight(context)*0.09, 10.0, 25.0),
            decoration: BoxDecoration(gradient: Constants.drawerGradientColor),
          child: Column(
            children: <Widget>[
              GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Profile(0)));
                  },
                  child: Row(children: <Widget>[
                    CircleAvatar(
                        radius: 25.0,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Constants.imageUrl == null?CircularProgressIndicator(
                              strokeWidth: 1.0,backgroundColor: Colors.white,):Image.network(
                              Constants.imageUrl == "null"?Constants.USER_IMAGE:Constants.imageUrl,fit: BoxFit.cover,))
                    ),

                    SizedBox(width: 15.0),
                    Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(name == null?"-":name,
                                  style: Constants().txtStyleFont16(ColorsUsed.whiteColor,15.0),),
                              ],
                            ),
                            SizedBox(height: 5.0),
                            Text("Profile",
                              style: Constants().txtStyleFont16(ColorsUsed.baseColor,14.0),),
                          ],
                        )),
                    IconButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      icon: Image.asset("Images/drawer/cross.png",
                        color: ColorsUsed.whiteColor,width: 20.0,),)
                  ],)),
              _menuOptions(context,menuImage1,S.logMe,1),
              _menuOptions(context,menuImage2,S.myTask,2),
              _menuOptions(context,menuImage3,S.myLead,3),
              _menuOptions(context,menuImage4,S.myDoc,4),
              _menuOptions(context,menuImage5,S.queries,5),
              _menuOptions(context,menuImage6,S.discuss,6),
              _menuOptions(context,menuImage7,S.event,7),
//              _menuOptions(context,menuImage3,S.report,8),
              _menuOptions(context,menuImage8,S.chart,9),
              SizedBox(height: 20.0),
              Divider(color: Color(0xFF9F9DF7),thickness: 1.5,
                endIndent: Constants().containerWidth(context)*0.4,),
              _menuOptions(context,menuImage9,S.contact,10),
              _menuOptions(context,menuImage10,S.logout,11),
            ],
        )
        ),
      ),
    );
  }

  _menuOptions(BuildContext context,String assetImage,textValue,int option) {
    return GestureDetector(
      onTap: (){
        _clickOperations(context,option);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(15.0, 25.0, 0.0, 10.0),
        child: Row(
          children: [
            Image.asset(assetImage,
              color: ColorsUsed.whiteColor,width: 20.0,),
            SizedBox(width: 20.0),
            Expanded(
              child: Text(textValue,
                style: Constants().txtStyleFont16(ColorsUsed.whiteColor,16.0),),)
          ],
        )
      ),
    );
  }


//operations
  void _clickOperations(BuildContext context,int clickId) {
    switch(clickId){
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeeLoggedIn()));
        break;
        case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyTasks()));
        break;
        case 3:
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyLeads()));
        break;
        case 4:
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyFiles()));
        break;
        case 5:
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyQueries()));
        break;
        // Group Chat
        case 6:
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage()));
        break;
        case 7:
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyEvent()));
        break;
        case 8:
//        Navigator.push(context, MaterialPageRoute(builder: (context) => MyLeads()));
        break;
        //9 stands for graphs
        case 9:
        Navigator.push(context, MaterialPageRoute(builder: (context) => Graphs()));
        break;
        case 10:
//        Navigator.push(context, MaterialPageRoute(builder: (context) => MyLeads()));
        break;
        case 11:
        /*LoginModel().handleGoogleLogOut(context);*/Constants.logout(context);
    }
  }
}
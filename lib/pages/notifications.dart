import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/Utiles/widgets.dart';
import 'package:newproject/models/NotificationModal.dart';
import 'package:newproject/models/NotificationPojo.dart';
import 'package:newproject/pages/homeOptions/Tasks/my_tasks.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
 bool loader = true;
 String noti="Notification";
 var response,responseList;
 List<NotificationModal> notificationPojo;
 @override
  void initState() {
    super.initState();
    getNotificationList();
    notificationPojo = new List<NotificationModal>();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Widgets().appDrawer(context, Constants.userName, Constants.imageUrl),
      appBar: appBarOptions(),
      body: notificationListUI()
    );
  }

  //App Bar
  appBarOptions() {
    return PreferredSize(
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(40.0),
          bottomLeft: Radius.circular(40.0),
        ),
        child: AppBar(backgroundColor: ColorsUsed.baseColor,
          leading: Builder(builder: (context)=>IconButton(
              icon: Image.asset("Images/home/menu.png",color: ColorsUsed.whiteColor,width: 30.0,),
              onPressed: (){
                Scaffold.of(context).openDrawer();
              })),
          centerTitle: true,
          title: Text(noti,
         // title: Text("Notifications",
            style: Constants().txtStyleFont16(ColorsUsed.whiteColor,20.0),),
        ),
      ),
      preferredSize: Size.fromHeight(Constants().containerHeight(context)*0.1),
    );
  }

  //https://tasla.app/MyOffice/index.php?action=getNotificationList&userId1=7

//get profile details
  Future<dynamic> getNotificationList() async {
    try {
      await http
          .get(
          "${Constants.BaseUrl}action=getNotificationList&userId1=${Constants.userId}")
          .then((res) {
        print(res.body);
        setState(() {
          response = json.decode(res.body);
          responseList = response["getNotificationList"];
        });
        final int statusCode = res.statusCode;
        if (statusCode == 200) {
          print("its working 200");
          if (response["success"] == "1") {
            for (int i = 0; i < responseList.length; i++) {
              setState(() {
                loaderOff(false);

                notificationPojo.add(NotificationModal(responseList[i]["id"],responseList[i]["notificationId"]
                    ,responseList[i]["userId1"],responseList[i]["userId2"],responseList[i]["description"]));
              });
            }
          }else{
            loaderOff(false);
          }
        } else {
         loaderOff(false);
        }
      });
    } on SocketException catch (_) {
      print('not connected');
      Constants().noInternet(context);
    } catch (e) {}
  }

  notificationListUI() {
   if(notificationPojo.length !=0){
     return ListView.builder(
         itemCount: notificationPojo.length,
         itemBuilder: (context, index) {
           return Column(
             children: [
               InkWell(
                 onTap: () {
                   if(notificationPojo[index].notificationId=="1"){
                     Constants.showToast("Wish : "+notificationPojo[index].description);
                   }else{
                     Navigator.push(context, MaterialPageRoute(builder: (context) => MyTasks()));
                   }
                 },
                 child: Card(
                   elevation: 20.0,
                   shadowColor: ColorsUsed.baseColor,
                   shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(25.0)),
                   child: Column(
                     crossAxisAlignment:
                     CrossAxisAlignment.start,
                     children: [
                       SizedBox(height: 15),
                       Row(
                         children: [SizedBox(width: 15),
                           CircleAvatar(
                             child: Icon(Icons.local_fire_department_outlined),
                           ),SizedBox(width: 10),
                           Expanded(
                             child: Text(notificationPojo[index].description, style: TextStyle(
                                 fontSize: 15.0,
                                 fontWeight: FontWeight.bold,fontFamily: "Montserrat",
                                 color: ColorsUsed.baseColor)),
                           ),SizedBox(width: 8),],
                       ),
                       SizedBox(height: 15)
             ],
                   ),
                 ),
               ),
               SizedBox(height: 20.0),
             ],
           );
         });
   }else{
     return Center(
         child: Text(" No Notifications yet",style: TextStyle(fontSize: 25),)
     );
   }
  }

  void loaderOff(bool value) {
    setState(() {
      loader=value;
    });
  }
}

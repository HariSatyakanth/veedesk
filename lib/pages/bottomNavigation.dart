import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:newproject/PushNotification/PushNotification.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/pages/homePage.dart';
import 'package:newproject/pages/myProfile.dart';
import 'package:newproject/pages/notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation>
    with TickerProviderStateMixin {
  int _selectedTab = 1;
  TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    PushNotificationsManager().init(context);
    _tabCtrl = TabController(length: 3, vsync: this);
    getProfile();
  }

  //get profile details
  Future<dynamic> getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await http
          .get(
              "${Constants.BaseUrl}action=getUserProfile&userId=${Constants.userId}")
          .then((res) {
        print(res.body);
        var response = json.decode(res.body);
        final int statusCode = res.statusCode;
        print(statusCode);
        if (statusCode == 200) {
          print("its working 200");
          if (response["success"] == 1) {
             setState(() {
              Constants.email = response["Email_address"];
              String fullName = response["Full_Name"].toString();
              String profilePhoto = response["picture"].toString();
              String employeType = response["role"].toString();
              Constants.userName = fullName;
              Constants.imageUrl = profilePhoto;
              Constants.employeType = employeType;
              print(Constants.userName);
            });
        } else {

          }
        } else {

        }
      });
    } on SocketException catch (_) {
      print('not connected');
      Constants().noInternet(context);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: _customBottomNavigationBar(),
        body: _bottomBarItems());
  }

  _customBottomNavigationBar() {
    return ConvexAppBar(
        backgroundColor: Colors.white,
        controller: _tabCtrl,
        activeColor: ColorsUsed.baseColor,
        color: Colors.grey,
        items: [
          TabItem(icon: Icons.person, title: 'Profile'),
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.notifications, title: 'Notification'),
        ],
        initialActiveIndex: _selectedTab,
        onTap: (int i) {
          setState(() {
            _selectedTab = i;
          });
        });
  }

  _bottomBarItems() {
    return TabBarView(
      physics: NeverScrollableScrollPhysics(),
      controller: _tabCtrl,
      children: <Widget>[
        Profile(1),
        HomePage(),
        Notifications()],
    );
  }

}

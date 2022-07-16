import 'dart:io';
import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:newproject/Interfaces/ImageCallBAck.dart';
import 'package:newproject/Interfaces/callBackWidget.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/common/ImagePreview.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class Util {
  static Future<String> loadAsset(String filename) async {
    return await rootBundle.loadString('assets/$filename');
  }

  static getDeviceToken() {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging();
    return firebaseMessaging.getToken();
  }

  static int currentTimeMillis() {
    return new DateTime.now().millisecondsSinceEpoch;
  }

  static void openGithub() {
    _launchURL();
  }

  static String platform() {
    String os = Platform.operatingSystem; //in your code
    if (os == 'android') {
      return '2';
    } else {
      return '1';
    }
  }
  static bool validatePassword(String value){
    String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  static String changeDateToFormetted(String value){

    var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    var inputDate = inputFormat.parse(value); // <-- Incoming date

    var outputFormat = DateFormat('dd-MMM');
    var outputDate = outputFormat.format(inputDate); // <-- Desired date
    return outputDate;
  }


  static String formatDate(DateTime value){
    var inputFormat = DateFormat('yyyy-MM-dd');
    var inputDate = inputFormat.format(value);
    return inputDate.toString();
  }

  static void _launchURL() async {
    const url = 'https://github.com/SunPointed/mp_flutter_chart';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<void> launchCaller(String key, String value) async {
    String url = key + value;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static void whatsAppOpen(String phoneNumber) async {
    // await FlutterLaunch.launchWathsApp(phone: "8628960980", message: "Hello");
    var whatsAppUrl = "whatsapp://send?phone=$phoneNumber&text=Hi";
    await canLaunch(whatsAppUrl)
        ? launch(whatsAppUrl)
        : Constants.showToast("There is no whatsapp installed");
  }

  static convertMonth(String _month) {
    switch (_month) {
      case "1":
        return "Jan";
        break;
      case "2":
        return "Feb";
        break;
      case "3":
        return "Mar";
        break;
      case "4":
        return "Apr";
        break;
      case "5":
        return "May";
        break;
      case "6":
        return "Jun";
        break;
      case "7":
        return "Jul";
        break;
      case "8":
        return "Aug";
        break;
      case "9":
        return "Sept";
        break;
      case "10":
        return "Oct";
        break;
      case "11":
        return "Nov";
        break;
      case "12":
        return "Dec";
        break;
    }
  }

  static listOfImages(
      {BuildContext context,
      List<NetworkImage> images,
      String name,
      ImageCallBack widgetCallBack}) {
    return Container(
      height: 120.0,
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      width: Constants().containerWidth(context),
      child: ListView.builder(
          itemCount: images.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, i) {
            return Stack(
//              fit: StackFit.expand,
              children: <Widget>[
                new SizedBox(
                  child: Row(
                    children: [
                      InkWell(
                        child: Image.network(
                          images[i].url,
                          height: 110,
                          width: 80,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ImagePreview(images[i].url, name)));
                        },
                      ),
                      SizedBox(
                        width: 5,
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      widgetCallBack.imageCallBackInterface(name, i);
                    },
                    child: Icon(
                      Icons.cancel_outlined,
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }

  //_convert date
  static convertCompleteDate(DateTime _date){
    var _convertMonth = convertMonth(_date.month.toString());
    var _convertedDate = "${_date.year}-$_convertMonth-${_date.day}";
    print(_convertedDate);
    return _convertedDate;
  }

  static convertWeekDay(String weekDay) {
    switch (weekDay) {
      case "1":
        return "Mon";
        break;
      case "2":
        return "Tue";
        break;
      case "3":
        return "Wed";
        break;
      case "4":
        return "Thu";
        break;
      case "5":
        return "Fri";
        break;
      case "6":
        return "Sat";
        break;
      case "7":
        return "Sun";
        break;
    }
  }
}

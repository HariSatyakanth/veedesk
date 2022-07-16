import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newproject/Interfaces/callBackWidget.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:http/http.dart' as http;
import 'package:newproject/pages/bottomNavigation.dart';
import 'package:newproject/pages/login.dart';
import 'package:path/path.dart';

class AuthActionButton extends StatefulWidget {
  AuthActionButton(this._initializeControllerFuture, {@required this.onPressed,@required this.name,@required this.idd,@required this.pic,@required this.lat,@required this.lng,@required this.mContext});
  final Future _initializeControllerFuture;
  final Function onPressed;
  String name,pic,idd;
  double lat, lng;
  BuildContext mContext;
  @override
  _AuthActionButtonState createState() => _AuthActionButtonState();
}

class _AuthActionButtonState extends State<AuthActionButton> implements WidgetCallBack{
  String empReason;
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  DateTime now, then;
bool _loading=false;
  var _loginTime,timeNow;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      label:  Text('Take Photo'),
      icon: Icon(Icons.camera_alt),
      // Provide an onPressed callback.
      onPressed: () async {
        try {

          // onShot event (takes the image and predict output)
          bool faceDetected = await widget.onPressed();

          if (faceDetected) {

            Scaffold.of(context).showBottomSheet((context) => signSheet(context));
          }
        } catch (e) {
          // If an error occurs, log the error to the console.
          print(e);
        }
      },
    );
  }

  signSheet(context) {
    return Container(
      padding: EdgeInsets.all(20),
      height: 300,
      child: Column(
        children: [
          SizedBox(height: 20.0),
          Row(
            children: [
              InkWell(
                onTap: (){

                },
                child: CircleAvatar(radius: 15.0,
                  backgroundImage: NetworkImage(
                    widget.pic == null?Constants.USER_IMAGE:widget.pic,
                  ),
                ),
              ),
              SizedBox(width: 20.0),
              Text("Welcome ${widget.name}")
            ],
          ),
          SizedBox(height: 20.0),
          _enterEmail(),
          spinnerButton(),
          SizedBox(width: 20.0),

        ],
      ),
    );
  }

  _enterEmail() {
    return Container(padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            onChanged: (value){
              empReason = value;

            },
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(
                  color:Colors.grey[300],width: 2.0),),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(
                  color:ColorsUsed.baseColor,width: 2.0),),
              prefixIcon: Icon(Icons.email),
              hintText: 'Enter valid reason for using friend\'s device.',
//              isCollapsed: true,
            ),
            keyboardType: TextInputType.text,

          )
        ],
      ),
    );
  }
  spinnerButton() {
    if(_loading){
      return
        Center(child: CircularProgressIndicator());
    }else{
      return
        Constants().buttonRaised(widget.mContext,
            Colors.grey,"Attend",this);

    }
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  void callBackInterface(String title) {
    switch(title){
      case "Attend":
        if(empReason.length>8) {
          _loading=true;
          DateTime now = new DateTime.now();
          DateTime date = new DateTime(now.year, now.month, now.day);
          _loginTime = formatter.format(now);
          timeNow=now.toString().substring(0,19);
          hitApiForAttendance();
        }else{
          Constants.showToast("Enter valid reason.");
        }
      //  Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavigation()));
        break;
    }
  }

  Future<void> hitApiForAttendance() async {

    print("${Constants.BaseUrl}action=attendance&userId=${widget.idd}&"
        "userLat=${widget.lat}&userDeviceToken=1234&userLong=${widget.lng}&userDate=$_loginTime&"
        "userIp=545&userStatus=in&datetime=$timeNow");
    try{
      await http.get("${Constants.BaseUrl}action=attendance&userId=${widget.idd}&"
          "userLat=${widget.lat}&userDeviceToken=1234&userLong=${widget.lng}&userDate=$_loginTime&"
          "userIp=545&userStatus=in&datetime=$timeNow"
      ).then(( res) {
        print(res.body);
        var response = json.decode(res.body);
        final int statusCode = res.statusCode;
        print(statusCode);
        if (statusCode == 200) {
          print("its working 200");
          if(response["success"] == 1){
            Constants.showToast(widget.name + " attend office successfully at $timeNow");
            Navigator.pushAndRemoveUntil(widget.mContext, MaterialPageRoute(
                builder: (context) => BottomNavigation()), ModalRoute.withName("/BottomNavigation"));

          }else{

            Navigator.pop(widget.mContext);
            Navigator.pop(widget.mContext);
            Constants.showToast(response["message"]);
          }
        }else{

//          Scaffold.of(context).showSnackBar(Constants().showSnackMessage(response["Something went wrong !"]));
        }
      });}on SocketException catch (_) {
      print('not connected');
      Constants().noInternet(widget.mContext);
    }catch (e) {
    }
  }

}

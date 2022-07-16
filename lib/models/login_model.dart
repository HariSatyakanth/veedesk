import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:http/http.dart'as http;
import 'package:newproject/Utiles/util.dart';
import 'package:newproject/pages/bottomNavigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;  //at the top


class LoginModel{
  static String email = "",
  password = "",
  fullName = "",
  photo = "";
  static bool textVisibility = false;


  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Future<void> handleGoogleSignIn(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await _googleSignIn.signIn().then((value) {
        print(value);
        fullName = value.displayName;
        photo = value.photoUrl;

        prefs.setString("name", fullName);
        prefs.setString("Image", photo);
        print(fullName);
        Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavigation()));
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> handleGoogleLogOut(BuildContext context) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _googleSignIn.disconnect().then((value) {
      print(value);
      prefs.clear();
    });
  }

  Future<dynamic> Login(BuildContext context) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var isloader = Constants.loader(context);
    await isloader.show();
    print("${Constants.BaseUrl}action=login&userEmail=$email&userPassword=$password&"
        "userDeviceToken=${await Util.getDeviceToken()}&loginDevice="+Util.platform());
    try{
      await http.get("${Constants.BaseUrl}action=login&userEmail=$email&userPassword=$password&"
          "userDeviceToken=&loginDevice="+Util.platform()
      ).then(( res) {
        print(res.body);
        var response = json.decode(res.body);
        final int statusCode = res.statusCode;
        print(statusCode);
        if (statusCode == 200) {
          isloader.hide();
          print("its working 200");
            if(response["success"] == 1){
              print("in success");
              Constants.userId = response["userId"];
              preferences.setString("USERID", Constants.userId);
              Constants.popUpForAlertDialogs(context, "Login successfully", "");
//              Scaffold.of(context).showSnackBar(Constants().showSnackMessage("Login successfully"));
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (context) => BottomNavigation()), ModalRoute.withName("/Home"));
            }else{
              Constants.popUpForAlertDialogs(context, response["message"], "Alert!");
//              Scaffold.of(context).showSnackBar(Constants().showSnackMessage(response["message"]));
//              Navigator.pop(context);

            }
        }else{
          Scaffold.of(context).showSnackBar(Constants().showSnackMessage(response["Something went wrong !"]));
          Navigator.pop(context);
        }
      });}on SocketException catch (_) {
      print('not connected');
      isloader.hide();
     Constants().noInternet(context);
    }catch (e) {
      Navigator.pop(context);
      print(e);
    }
  }
  void onLoading(BuildContext context,int sec) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(backgroundColor: Colors.transparent,
            child: Container(//color: Colors.transparent,
              child: Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Constants().spinKit,
                    SizedBox(height: 10.0,),
                    Text("Please wait...",style: Constants().txtStyleFont16(Colors.white, 16.0),)
                  ],
                ),
              ),
            )
        );
      },
    );
    new Future.delayed(new Duration(seconds: sec), () {
      Navigator.pop(context);

    });
  }

//   validation(BuildContext context){
//    if(email.isNotEmpty){
//      if(EmailValidator.validate(email)){
//      if(password.isNotEmpty){
//        onLoading(context);
//      }else{
//        Constants.showToast("Please enter Password");
//        print("no pwd");
//      }
//      }else{
//        Constants.showToast("Please enter valid email");
//      }
//    }else{
//      print(textVisibility);
//      Constants.showToast("Please enter email");
//    }
//  }


}
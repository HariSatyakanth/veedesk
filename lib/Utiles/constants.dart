import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:newproject/Interfaces/callBackWidget.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/Images_path.dart';
import 'package:newproject/Utiles/strings.dart';
import 'package:newproject/models/login_model.dart';
import 'package:newproject/pages/homeOptions/Tasks/AddFollowUp.dart';
import 'package:newproject/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Constants {
  static String userName = "",
      imageUrl,
      userId = "",
      email = "",
      employeType = "",
      admin_type = "4";
  static const String BaseUrl = "https://tasla.app/MyOffice/index.php?";
  static const String ImageBaseUrl = "https://tasla.app/MyOffice/images/";
  static bool GROUP_CHAT_ENABLE = false;
  bool CHAT_BACK = false;
  static String loginType = "";
  static String OUT = "out";
  static String IN = "in";
  static String FOLDER_NAME = "/MyOffice/";

  // check the login type is gmail or manual
  static Future<String> getSocialType() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    Constants.loginType = _prefs.getString("LOGIN_METHOD");
    return Constants.loginType;
  }

  static gifImage(GifController controller) {
    return GifImage(
      controller: controller,
      gaplessPlayback: true,
      image: AssetImage("Images/ezgif.com-crop.gif"),
    );
  }

  static startGifAnimation(GifController controller) {
    controller.repeat(min: 0, max: 5, period: Duration(milliseconds: 500));
  }

  static stopGifAnimation(GifController controller) {
    controller.reset();
  }

  static logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Text('Are you sure that you want to logout?',
              style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                  color: ColorsUsed.baseColor)),
          actions: <Widget>[
            Row(
              children: [
                FlatButton(
                  child: Text(
                    'Yes',
                    style: TextStyle(fontSize: 17.0),
                  ),
                  onPressed: () {
                    prefs.remove('USERID');
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                        ModalRoute.withName("/Login"));
                  },
                ),
                FlatButton(
                  child: Text(
                    'No',
                    style: TextStyle(fontSize: 17.0),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  static String USER_IMAGE =
      "https://firebasestorage.googleapis.com/v0/b/real-state-570a3.appspot.com/o/users%2FPngItem_5813504.png?alt=media&token=7666ff96-9d51-4129-92ab-537be037fac2";
  static String GROUP_CHAT_ID = "1RPiEm0LQmsRSs7kschn";
  static var drawerGradientColor = LinearGradient(
      colors: [Color(0xFF0500Af), Color(0xFF4743D9), Color(0xFF9F9DF7)],
      end: Alignment.centerLeft,
      begin: Alignment.centerRight);
  var spinKit = SpinKitCircle(
    color: Color(0xFF0500Af),
    size: 50.0,
  );

  SnackBar showSnackMessage(String message) {
    return SnackBar(
      backgroundColor: ColorsUsed.baseColor,
      content: Text(message),
    );
  }

  static const String logImage = "Images/home/homelogme.png",
      taskImage = "Images/home/hometask.png",
      leadImage = "Images/home/homeleads.png",
      docImage = "Images/home/homedoc.png",
      queryImage = "Images/home/homequery.png",
      discussImage = "Images/home/homechat.png",
      eventImage = "Images/home/homeCalendar.png",
      chartImage = "Images/home/homechart.png";

  static const String logImageFade = "Images/home/logme 2.png",
      taskImageFade = "Images/home/task (2).png",
      leadImageFade = "Images/home/leads (2).png",
      docImageFade = "Images/drawer/doc.png",
      queryImageFade = "Images/home/query (2).png",
      discussImageFade = "Images/home/chat (2).png",
      eventImageFade = "Images/home/Calendar (2).png",
      chartImageFade = "Images/home/chart (2).png";

  Future<void> noInternet(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Text(
            'Network Problem !',
          ),
          content: const Text('Internet is not available',
              style: TextStyle(
                  fontFamily: 'selected',
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 15.0)),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Ok',
                style: TextStyle(fontSize: 17.0),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static showToast(String msg) {
    return Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: ColorsUsed.baseColor,
        textColor: ColorsUsed.whiteColor);
  }

  var greyGradient = LinearGradient(
      colors: [Colors.grey[300], Colors.grey[300]],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter);

  var whiteGradient = LinearGradient(
      colors: [Color(0xffFFFFFF), Color(0xffFFFFFF)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter);

  var baseColorGradient = LinearGradient(
      colors: [Color(0xFF0500AF), Colors.grey[300]],
      
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter);

  double containerHeight(BuildContext context) {
    print("size= ${MediaQuery.of(context).size}");
    return MediaQuery.of(context).size.height;
  }

  double containerWidth(BuildContext context) {
    print("wd= ${MediaQuery.of(context).size.width}");
    return MediaQuery.of(context).size.width;
  }

  //Alert Dialog with two buttons
  static popUpFortwoOptions(
      BuildContext context, String message, title, WidgetCallBack interface) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text(title),
            content: new Text(message),
            actions: <Widget>[
              new FlatButton(
                //Click on yes to perform operation according to use
                onPressed: () {
                  Navigator.pop(context);
                  interface.callBackInterface(message);
                },
                child: new Text('Yes'),
              ),
              FlatButton(
                //Click on no to reset/go to previous state
                onPressed: () {
                  Navigator.pop(context);
                },
                child: new Text('No'),
              ),
            ],
          );
        });
  }

//Alert Dialog for waiting
  static popUpForAlertDialogs(BuildContext context, String message, title) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text(title),
            content: new Text(message),
            /*Text("Thanks to be a part of us,but your application is pending for approval , as soon it is approved we'll notify you"),*/
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: new Text('ok'),
              ),
            ],
          );
        });
  }

  //selectedFont text
  static Widget selectedFontWidget(
      String title, Color textColor, double fontSize, FontWeight _boldOrNot) {
    return Text(title,
        style: new TextStyle(
            fontSize: fontSize,
            color: textColor,
            fontFamily: "Montserrat",
            fontWeight: _boldOrNot));
  }

  txtStyleFont16(Color colorValue, double font) {
    return TextStyle(
        fontSize: font,
        color: colorValue,
        fontFamily: "Montserrat",
        fontWeight: FontWeight.w500);
  }

  backButton(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        });
  }

  Widget buttonRaised(BuildContext context, Color colorValue, String title,
      WidgetCallBack widgetCallBack) {
    return SizedBox(
      height: containerWidth(context) * 0.1,
      child: RaisedButton(
        onPressed: () {
          widgetCallBack.callBackInterface(title);
        },
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        elevation: 0.0,
        color: colorValue,
        child: Text(title,
            style: TextStyle(
                fontSize: 16.0,
                color: ColorsUsed.whiteColor,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w500)),
      ),
    );
  }

  button(
      BuildContext context, Color colorValue, int clickId, String textValue) {
    return SizedBox(
      height: containerHeight(context) / 16,
      child: Builder(
        builder: (context) => RaisedButton(
          onPressed: () {
            _buttonClickOperation(clickId, context);
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          elevation: 0.0,
          color: colorValue,
          child: Text(textValue,
              style: TextStyle(
                  fontSize: 16.0,
                  color: ColorsUsed.whiteColor,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }

  _buttonClickOperation(int id, BuildContext context) {
    switch (id) {
      case 0:
        print("login");
//        LoginModel().validation(context);
//       Navigator.push(context, MaterialPageRoute(builder: (context)=>BottomNavigation()));
        break;
      case 1:
        print("google");
        LoginModel().handleGoogleSignIn(context);
        break;
      case 2:
        print("Continue");
        break;
    }
  }

  //focus
  static fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  //Simple keyboard TextField
  simpleField(
      BuildContext context,
      bool _readOnly,
      bool _obscureText,
      String message,
      TextEditingController _ctrl,
      FocusNode _focus,
      _nextFocus,
      IconData _iconData) {
    return TextFormField(
      validator: (value) => value.isEmpty ? message : null,
      textInputAction: TextInputAction.next,
      controller: _ctrl,
      obscureText: _obscureText,
      focusNode: _focus,
      readOnly: _readOnly,
      cursorColor: ColorsUsed.baseColor,
      onFieldSubmitted: (term) {
        Constants.fieldFocusChange(context, _focus, _nextFocus);
        print(_ctrl.text);
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 25.0, 0.0),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300], width: 2.0),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ColorsUsed.baseColor, width: 2.0),
        ),
        prefix: Icon(_iconData),
      ),
    );
  }

  //number keyboard TextField
  numericField(BuildContext context, String hint, String message,
      TextEditingController _ctrl, FocusNode _focus, _nextFocus) {
    return TextFormField(
      validator: (value) => value.isEmpty ? message : null,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      controller: _ctrl,
      focusNode: _focus,
      cursorColor: ColorsUsed.baseColor,
      onFieldSubmitted: (term) {
        Constants.fieldFocusChange(context, _focus, _nextFocus);
        print(_ctrl.text);
      },
      decoration: InputDecoration(
          hintText: hint,
          filled: true,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[200], width: 0.4),
              borderRadius: BorderRadius.circular(30.0)),
          fillColor: Colors.grey[200],
          contentPadding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 0.0),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))),
    );
  }

  //dotted line vertical
  static dottedLines() {
    return DottedLine(
      direction: Axis.vertical,
      lineLength: 120.0,
      lineThickness: 1.0,
      dashLength: 4.0,
      dashColor: Colors.black,
      dashRadius: 0.0,
      dashGapLength: 4.0,
      dashGapColor: Colors.transparent,
      dashGapRadius: 0.0,
    );
  }

  static completeLines() {
    return Container(
      color: ColorsUsed.baseColor,
      height: 120,
      width: 1,
    );
  }

  static loader(BuildContext context) {
    return ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
  }

  //Description TextField
  static descriptionField(BuildContext context, String hint, String message,
      TextEditingController _ctrl, FocusNode _focus, _nextFocus) {
    return TextField(
      textInputAction: TextInputAction.next,
      controller: _ctrl,
      maxLines: 5,
      focusNode: _focus,
      onSubmitted: (term) {
        Constants.fieldFocusChange(context, _focus, _nextFocus);
        print(_ctrl.text);
      },
      decoration: InputDecoration(
          hintText: hint,
          filled: true,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[200], width: 0.4),
              borderRadius: BorderRadius.circular(30.0)),
          fillColor: Colors.grey[200],
          contentPadding: EdgeInsets.fromLTRB(25.0, 15.0, 25.0, 15.0),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))),
    );
  }

  static Widget commonEditTextField(
      IconData _iconData,
      TextEditingController _controller,
      bool _readOnly,
      String _hintText,
      String errorMessage,
      TextInputType _keyboardType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          readOnly: _readOnly,
          onChanged: (value) {
            print(value);
          },
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300], width: 2.0),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: ColorsUsed.baseColor, width: 2.0),
            ),
            prefixIcon: Icon(_iconData),
            hintText: _hintText,
//              isCollapsed: true,
          ),
          keyboardType: _keyboardType,
        ),
        SizedBox(height: 10.0),
        Text(
          errorMessage,
          style: Constants().txtStyleFont16(Colors.red, 12),
        )
      ],
    );
  }

  //common textField with error
  static Widget commonEditTextFieldWithoutIcon(
      TextEditingController _controller,
      bool _readOnly,
      String _hintText,
      String errorMessage,
      TextInputType _keyboardType) {
    return TextField(
      controller: _controller,
      readOnly: _readOnly,
      onChanged: (value) {
        print(value);
      },
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300], width: 2.0),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ColorsUsed.baseColor, width: 2.0),
        ),
        hintText: _hintText,
//              isCollapsed: true,
      ),
      keyboardType: _keyboardType,
    );
  }

  static List<NetworkImage> getImageArray(String paths) {
    String imgUrl = paths;
    List<NetworkImage> imgList = new List<NetworkImage>();
    imgUrl = imgUrl.substring(1, imgUrl.length - 1);
    if (imgUrl.contains(",")) {
      imgUrl.split(',').forEach((tag) {
        imgList.add(NetworkImage(S.IMAGE_PATH + tag.replaceAll("\"", "")));
      });
    } else {
      imgList.add(NetworkImage(S.IMAGE_PATH + imgUrl.trim()));
    }
    return imgList;
  }

  static List<NetworkImage> getImageString(String paths) {
    String imgUrl = paths;
    List<NetworkImage> imgList = new List<NetworkImage>();
    if (imgUrl.contains(",")) {
      imgUrl.split(',').forEach((tag) {
        imgList.add(NetworkImage(S.IMAGE_PATH + tag.replaceAll("\"", "")));
      });
    } else {
      imgList.add(NetworkImage(S.IMAGE_PATH + imgUrl.trim()));
    }
    return imgList;
  }

  static String getAudioUrl(String paths) {
    String audioUrl = paths;
    audioUrl = audioUrl.substring(1, audioUrl.length - 1);
    if (audioUrl.contains(",")) {
      audioUrl.split(',').forEach((tag) {
        audioUrl = S.IMAGE_PATH + tag.replaceAll("\"", "");
      });
    } else {
      audioUrl = S.IMAGE_PATH + audioUrl.trim();
    }
    return audioUrl;
  }

  static String convertTimeStamp(int timestamp) {
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
    var startTime =
        DateTime(date.year, date.month, date.day, date.hour, date.minute);
    var currentTime = DateTime.now();
    var diff = currentTime.difference(startTime).inDays;
    var diff1 = currentTime.difference(startTime).inHours;
    var diff2 = currentTime.difference(startTime).inMinutes;
    if (diff1 == 0) {
      return diff2.toString() + " min ago";
    } else if (diff == 0) {
      return diff1.toString() + " hours ago";
    } else {
      return diff.toString() + " days ago";
    }
  }

  //get all values of workLogList
  static workLogList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("WorkLogList${Constants.userId}");
  }
}

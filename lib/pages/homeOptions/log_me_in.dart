import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:newproject/Interfaces/callBackWidget.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:http/http.dart' as http;
import 'package:newproject/pages/homeOptions/WorkLog/AddWorkLog.dart';
import 'package:newproject/pages/homeOptions/WorkLog/WorkLogDetails.dart';
import 'package:newproject/pages/version_2_files/MediaFileUploading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:newproject/Utiles/constants.dart';

class EmployeeLoggedIn extends StatefulWidget {
  @override
  _EmployeeLoggedInState createState() => _EmployeeLoggedInState();
}

class _EmployeeLoggedInState extends State<EmployeeLoggedIn>
    implements WidgetCallBack {
  Position _currentPosition;
  double lat, lng;
  Completer<GoogleMapController> _controller = Completer();
  List<Marker> allMarkers = [];
  bool _login = false, _loader = true, _break = false;
  String _message;

  var currentAddress = "";

  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  DateTime now, then;
  var _loginTime, _logOutTime, _difference, timeNow;
  var workLogList;

  @override
  void initState() {
    super.initState();
    _checkStatus();
    _getLocation();
  }

  _getLocation() async {
    _currentPosition = await getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    setState(() {
      lat = _currentPosition.latitude;
      lng = _currentPosition.longitude;
      _loader = false;
    });
    await getAddressForLatLong().then((value) {
      setState(() {
        currentAddress = value;
      });
    });
    return _currentPosition;
  }

  //get current user location
  getAddressForLatLong() async {
    var address = await Geocoder.local
        .findAddressesFromCoordinates(Coordinates(lat, lng));
    print(address.first.addressLine);
    return address.first.addressLine;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
            child: _loader
                ? Center(
                    child: Constants().spinKit,
                  )
                : GoogleMap(
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    markers: Set<Marker>.from([
                      Marker(
                          draggable: false,
                          markerId: MarkerId(lat.toString() + lng.toString()),
                          position: LatLng(
                            lat,
                            lng,
                          ),
                          infoWindow: InfoWindow(
                              title: Constants.userName == null
                                  ? "-"
                                  : Constants.userName)),
                    ]),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    initialCameraPosition: CameraPosition(
                      target: LatLng(lat, lng),
                      zoom: 14.4746,
                    ),
                  ),
          ),
          Align(
              alignment: Alignment(-0.8, -0.8),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: CircleAvatar(
                  radius: 20.0,
                  backgroundColor: ColorsUsed.baseColor,
                  child: Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: Constants().containerHeight(context) * 0.30,
              width: Constants().containerWidth(context),
              child: Card(
                elevation: 1.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: _loader
                    ? Center(child: Text("Data is loading..."))
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 20.0),
                            Row(
                              children: [
                                SizedBox(width: 20.0),
                                Text(
                                  Constants.userName == null
                                      ? "-"
                                      : Constants.userName,
                                  style: Constants()
                                      .txtStyleFont16(Colors.black, 17.0),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.0),
                            Row(
                              children: [
                                SizedBox(width: 20.0),
                                Icon(
                                  Icons.location_on,
                                  color: ColorsUsed.baseColor,
                                ),
                                SizedBox(width: 5.0),
                                Expanded(
                                    child: Text(currentAddress,
                                        style: TextStyle(
                                            color: Colors.grey[500],
                                            fontWeight: FontWeight.bold))),
                                SizedBox(width: 20.0),
                              ],
                            ),
                            SizedBox(height: 5.0),
                            Row(
                              children: [
                                SizedBox(width: 27.0),
                                CircleAvatar(
                                  radius: 5.0,
                                  backgroundColor: ColorsUsed.baseColor,
                                ),
                                SizedBox(width: 15.0),
                                Expanded(
                                    child: Text(
                                  DateTime(
                                              DateTime.now().year,
                                              DateTime.now().month,
                                              DateTime.now().day)
                                          .toString()
                                          .substring(0, 10) +
                                      " at " +
                                      TimeOfDay.now()
                                          .toString()
                                          .substring(10, 15),
                                  style: TextStyle(
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.bold),
                                )),
                                SizedBox(width: 20.0),
                              ],
                            ),
                            SizedBox(height: 40.0),
                            Row(
                              children: [
                                SizedBox(width: 20.0),
                                Expanded(
                                  child: _login
                                      ? Constants().buttonRaised(context,
                                          Colors.red, "Logme Out", this)
                                      : Constants().buttonRaised(context,
                                          Colors.green, "Logme In", this),
                                ),
                                SizedBox(width: 20.0),
                                Expanded(
                                  child: spinnerButton(),
                                ),
                                SizedBox(width: 20.0),
                              ],
                            )
                          ],
                        ),
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<dynamic> loginOffice(BuildContext context) async {
    setState(() {
      _loader = true;
    });
    print("${Constants.BaseUrl}action=attendance&userId=${Constants.userId}&"
        "userLat=$lat&userDeviceToken=1234&userLong=$lng&userDate=$_loginTime&"
        "userIp=545&userStatus=in&datetime=$timeNow");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      await http
          .get(
              "${Constants.BaseUrl}action=attendance&userId=${Constants.userId}&"
              "userLat=$lat&userDeviceToken=1234&userLong=$lng&userDate=$_loginTime&"
              "userIp=545&userStatus=in&datetime=$timeNow")
          .then((res) {
        print(res.body);
        var response = json.decode(res.body);
        final int statusCode = res.statusCode;
        print(response);
        setState(() {
          _loader = false;
        });
        if (statusCode == 200) {
          print("its working 200");
          if (response["success"] == 1) {
            setState(() {
              _login = true;
              _break = true;
            });
            preferences.setBool("buttonState", _login);
            preferences.setBool("breakeBtnState", _break);
          } else {
            Constants.popUpForAlertDialogs(context, response["message"], "");
          }
        } else {
//          Scaffold.of(context).showSnackBar(Constants().showSnackMessage(response["Something went wrong !"]));
        }
      });
    } on SocketException catch (_) {
      print('not connected');
      Constants().noInternet(context);
    } catch (e) {}
  }

  logOutOffice(BuildContext context, String status, int checkClick) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print("${Constants.BaseUrl}action=userInOut&userId=${Constants.userId}&"
            "userDate=$_logOutTime&userStatus=" +
        status +
        "&datetime=$timeNow");
    try {
      await http
          .get(
              "${Constants.BaseUrl}action=userInOut&userId=${Constants.userId}&"
              "userDate=$_logOutTime&userStatus=out&datetime=$timeNow")
          .then((res) {
        print(res.body);
        var response = json.decode(res.body);
        final int statusCode = res.statusCode;
        print(statusCode);
        setState(() {
          _loader = false;
        });
        if (statusCode == 200) {
          print("its working 200");
          if (response["success"] == 1) {
            //0 is for resume
            if (checkClick == 0) {
              setState(() {
                _break = true;
              });
              preferences.setBool("breakeBtnState", _break);
            }
            //1 is for break;
            else if (checkClick == 1) {
              setState(() {
                _break = false;
              });
              preferences.setBool("breakeBtnState", _break);
            } else {
              setState(() {
                _login = false;
              });
              preferences.setBool("buttonState", _login);
            }
            Constants.popUpForAlertDialogs(
                context,
                "Your working hours are " + response["workingHours"] + "hours.",
                "");
//            Constants.showToast("Thank you working hours "+response["workingHours"]);
//            Constants.showToast("Thank you working hours "+response["workingHours"]);

//            Scaffold.of(context).showSnackBar(Constants().showSnackMessage("Login successfully"));
//            Navigator.of(context).push(new MaterialPageRoute(builder: (context) => BottomNavigation()));
          } else {
            print(response["message"]);
            Scaffold.of(context).showSnackBar(
                Constants().showSnackMessage(response["message"]));
          }
        } else {
          print("Something went wrong");
//          Scaffold.of(context).showSnackBar(Constants().showSnackMessage(response["Something went wrong !"]));
        }
      });
    } on SocketException catch (_) {
      print('not connected');
      Constants().noInternet(context);
    } catch (e) {}
  }

  Future<dynamic> _checkAttendanceStatus() async {
    DateTime now = new DateTime.now();

    setState(() {
      _loginTime = formatter.format(now);
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print(
        "${Constants.BaseUrl}action=checkAttendance&userId=${Constants.userId}"
        "&userDate=$_loginTime");
    try {
      await http
          .get(
              "${Constants.BaseUrl}action=checkAttendance&userId=${Constants.userId}"
              "&userDate=$_loginTime")
          .then((res) {
        print(res.body);
        print("status${res.body}");
        var _statusResponse = json.decode(res.body);
        final int statusCode = res.statusCode;
        print(_statusResponse);
        if (statusCode == 200) {
          print("check 200");
          if (_statusResponse["success"] == 1) {
            setState(() {
              _login = true;
            });
            if (_statusResponse["userStatus"] == "in") {
              setState(() {
                _break = true;
              });
            } else {
              setState(() {
                _break = false;
              });
            }
            preferences.setBool("buttonState", _login);
            preferences.setBool("breakeBtnState", _break);
          } else {}
        } else {
//          Scaffold.of(context).showSnackBar(Constants().showSnackMessage(response["Something went wrong !"]));
        }
      });
    } on SocketException catch (_) {
      print('not connected');
      Constants().noInternet(context);
    } catch (e) {}
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  void callBackInterface(String title) {
    switch (title) {
      case "Logme In":
        //     now = DateTime.now();
        DateTime now = new DateTime.now();
        DateTime date = new DateTime(now.year, now.month, now.day);

        setState(() {
          _loginTime = formatter.format(now);
        });
        timeNow = now.toString().substring(0, 19);
        print("Time : $date");
        print("Time : $now");
        print("Time : $timeNow");
        loginOffice(context);

        break;
      case "Logme Out":
        openWorkLogConfirmation();
        break;
      case "Break":
        DateTime now = new DateTime.now();
        DateTime date = new DateTime(now.year, now.month, now.day);
        timeNow = now.toString().substring(0, 19);
        _logOutTime = date.toString();
        logOutOffice(context, Constants.OUT, 1);
        break;
      case "Resume":
        if (_login) {
          DateTime now = new DateTime.now();
          DateTime date = new DateTime(now.year, now.month, now.day);
          timeNow = now.toString().substring(0, 19);
          _logOutTime = date.toString();
          logOutOffice(context, Constants.IN, 0);
        } else {
          Constants.showToast("Please add attendance first..");
        }
        break;
    }
  }

  openLoggedotDialog() async {
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Container(
              child: Text(
                  "Once you Logged Out, you can't login again .Are You Sure?"),
            ),
            actions: <Widget>[
              new FlatButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new FlatButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.pop(context);
                    DateTime now = new DateTime.now();
                    DateTime date = new DateTime(now.year, now.month, now.day);
                    timeNow = now.toString().substring(0, 19);
                    _logOutTime = date.toString();
                    logOutOffice(context, Constants.OUT, 2);
                  })
            ],
          );
        });
  }

  openWorkLogConfirmation() async {
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Container(
              child: Text(
                  "Before Logout you can review or submit your today workLog"),
            ),
            actions: <Widget>[
              workLogList != null
                  ? FlatButton(
                      child: const Text('Review'),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    WorkLogDetails(1, "Today ")));
                      })
                  : FlatButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
              workLogList != null
                  ? FlatButton(
                      child: const Text('Submit'),
                      onPressed: () async {
                        setState(() {
                          _loader = true;
                        });
                        Navigator.pop(context);
                        Map jsonMap = {"data": await Constants.workLogList()};
                        print(jsonMap);
                        MediaFilesUpload()
                            .addWorkLog(jsonMap, context)
                            .then((value) {
                          print("value$value");
                          if (value) {
                            DateTime now = new DateTime.now();
                            DateTime date =
                                new DateTime(now.year, now.month, now.day);
                            timeNow = now.toString().substring(0, 19);
                            _logOutTime = date.toString();
                            logOutOffice(context, Constants.OUT, 2);
                          }
                        });

                        /*DateTime now = new DateTime.now();
                    DateTime date = new DateTime(now.year, now.month, now.day);
                    timeNow=now.toString().substring(0,19);
                    _logOutTime=date.toString();
                    logOutOffice(context,Constants.OUT,2);*/
                      })
                  : Container(),
              FlatButton(
                  child: const Text('Add worklog'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddWorkLog())).then((value) =>
                        value ? _checkStatus() : _checkAttendanceStatus());
                  }),
            ],
          );
        });
  }

  Future<void> _checkStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _login = prefs.getBool('buttonState') ?? false;
      _break = prefs.getBool('breakeBtnState') ?? false;
    });

    workLogList = await Constants.workLogList();
    if (!_login) {
      _checkAttendanceStatus();
    }
  }

  spinnerButton() {
    if (_login) {
      return _break
          ? Constants().buttonRaised(context, Colors.red, "Break", this)
          : Constants().buttonRaised(context, Colors.green, "Resume", this);
    } else {
      return SizedBox(width: 0.0);
    }
  }
}

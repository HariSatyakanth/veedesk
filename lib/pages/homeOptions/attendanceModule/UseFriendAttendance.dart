import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:newproject/Interfaces/callBackWidget.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:http/http.dart' as http;
import 'package:newproject/pages/homeOptions/attendanceModule/OpenFaceDetection.dart';
import 'package:newproject/pages/homeOptions/attendanceModule/services/facenet.service.dart';
import 'package:newproject/pages/homeOptions/attendanceModule/services/ml_vision_service.dart';
import 'package:camera/camera.dart';


class UseFriendAttendance extends StatefulWidget {
  @override
  _UseFriendAttendanceState createState() => _UseFriendAttendanceState();
}

class _UseFriendAttendanceState extends State<UseFriendAttendance>
    implements WidgetCallBack {
  Position _currentPosition;
  double lat, lng;
  Completer<GoogleMapController> _controller = Completer();
  List<Marker> allMarkers = [];
  bool _login = false,
      _loader = true;
  String empEmail,
      _errorMessageEmail = "";

  var currentAddress = "";

  // Services injection
  FaceNetService _faceNetService = FaceNetService();
  MLVisionService _mlVisionService = MLVisionService();
  CameraDescription cameraDescription;

  @override
  void initState() {
    super.initState();
    setState(() {
      _login = false;
      lat = 30.221102;
      lng = 76.519264;
    });

    _getLocation();
    _startUp();
  }

  _startUp() async {
    _setLoading(true);

    List<CameraDescription> cameras = await availableCameras();

    /// takes the front camera
    cameraDescription = cameras.firstWhere(
          (CameraDescription camera) =>
      camera.lensDirection == CameraLensDirection.front,
    );

    // start the services
    await _faceNetService.loadModel();
    _mlVisionService.initialize();

    _setLoading(false);
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

  getAddressForLatLong() async {
    var address = await Geocoder.local.findAddressesFromCoordinates(
        Coordinates(lat, lng));
    print(address.first.addressLine);
    return address.first.addressLine;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
            child: _loader ? Center(child: Constants().spinKit,) : GoogleMap(
              mapType: MapType.normal,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: Set<Marker>.from([
                Marker(
                    draggable: false,
                    markerId: MarkerId(lat.toString() + lng.toString()),
                    position: LatLng(
                      lat, lng,
                    ),
                    infoWindow: InfoWindow(
                        title: Constants.userName == null ? "-" : Constants
                            .userName)
                ),
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
                child: CircleAvatar(radius: 20.0,
                  backgroundColor: ColorsUsed.baseColor,
                  child: Icon(
                    Icons.chevron_left, color: Colors.white, size: 30.0,),),
              )
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: Constants().containerHeight(context) * 0.3,
              width: Constants().containerWidth(context),
              child: Card(elevation: 1.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20.0),
                      _enterEmail(),
                      spinnerButton(),

                      SizedBox(width: 20.0),

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

  spinnerButton() {
    if (!_login) {
      return
        Constants().buttonRaised(context,
            Colors.grey, "Check email", this);
    } else {
      return
        Center(child: CircularProgressIndicator());
    }
  }

  _enterEmail() {
    return Container(padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            onChanged: (value) {
              empEmail = value;
            },
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(
                  color: Colors.grey[300], width: 2.0),),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(
                  color: ColorsUsed.baseColor, width: 2.0),),
              prefixIcon: Icon(Icons.email),
              hintText: 'Enter email address',
//              isCollapsed: true,
            ),
            keyboardType: TextInputType.emailAddress,

          ),
          SizedBox(height: 10.0),
          Text(_errorMessageEmail,
            style: Constants().txtStyleFont16(Colors.red, 12),)
        ],
      ),
    );
  }

  Future<dynamic> _checkEmailStatus(String email) async {
    try {
      await http.get("${Constants.BaseUrl}action=checkEmail&email=$email").
      then((res) {
        print(res.body);
        print("status${res.body}");
        var _statusResponse = json.decode(res.body);
        final int statusCode = res.statusCode;
        print(statusCode);
        if (statusCode == 200) {
          print("check 200");
          if (_statusResponse["success"] == 1) {
            setState(() {
              _login = false;
              _errorMessageEmail = "";
            });
            // Constants.showToast("No saved Image in db 😞");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    FaceDetection(
                        cameraDescription: cameraDescription,
                        name: _statusResponse["Full_Name"],
                        pic: _statusResponse["picture"],
                        idd: _statusResponse["Id"],
                        lat:lat,
                        lng:lng,
                    ),
              ),
            );
          } else {
            setState(() {
              _login = false;
              _errorMessageEmail = "User not found 😞";
            });
          }
        } else {}
      });
    } on SocketException catch (_) {
      print('not connected');
      Constants().noInternet(context);
    } catch (e) {}
  }

  @override
  void callBackInterface(String title) {
    switch (title) {
      case "Check email":
        if (empEmail.isNotEmpty) {
          if (EmailValidator.validate(empEmail)) {
            if (empEmail == Constants.email) {
              setState(() {
                _errorMessageEmail =
                "Sorry!You can't use this feature with your own email";
              });
            } else {
              setState(() {
                _login = true;
              });
              _checkEmailStatus(empEmail);
            }
          } else {
            setState(() {
              _errorMessageEmail = "Please enter a valid email address";
            });
          }
        } else {
          setState(() {
            _errorMessageEmail = "Please enter email address";
          });
        }


        break;
    }
  }

  void _setLoading(bool bool) {
    setState(() {
      _loader = bool;
    });
  }
}

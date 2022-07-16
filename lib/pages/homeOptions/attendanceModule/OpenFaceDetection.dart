import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/pages/homeOptions/attendanceModule/services/camera.service.dart';
import 'package:newproject/pages/homeOptions/attendanceModule/services/facenet.service.dart';
import 'package:newproject/common/auth-action-button.dart';
import 'package:newproject/common/FacePainter.dart';
import 'package:newproject/pages/homeOptions/attendanceModule/services/ml_vision_service.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

class FaceDetection extends StatefulWidget {
  final CameraDescription cameraDescription;
  String name, pic, idd;
  double lat, lng;
  FaceDetection(
      {Key key,
      @required this.cameraDescription,
      @required this.name,
      @required this.pic,
      @required this.idd,
      @required this.lat,
      @required this.lng})
      : super(key: key);

  @override
  FaceDetectionState createState() => FaceDetectionState();
}

class FaceDetectionState extends State<FaceDetection> {
  String imagePath;
  Face faceDetected;
  Size imageSize;

  bool _detectingFaces = false;
  bool pictureTaked = false;

  Future _initializeControllerFuture;
  bool cameraInitializated = false;

  // switchs when the user press the camera
  bool _saving = false;
  bool _bottomSheetVisible = false;

  // service injection
  MLVisionService _mlVisionService = MLVisionService();
  CameraService _cameraService = CameraService();
  FaceNetService _faceNetService = FaceNetService();

  @override
  void initState() {
    super.initState();

    /// starts the camera & start framing faces
    _start();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _cameraService.dispose();
    super.dispose();
  }

  /// starts the camera & start framing faces
  _start() async {
    _initializeControllerFuture =
        _cameraService.startService(widget.cameraDescription);
    await _initializeControllerFuture;

    setState(() {
      cameraInitializated = true;
    });

    _frameFaces();
  }

  /// handles the button pressed event
  Future<void> onShot() async {
    print('onShot performed'); //

    if (faceDetected == null) {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Text('No face detected!'),
          );
        },
        //  child:
      );

      return false;
    } else {
      imagePath =
          join((await getTemporaryDirectory()).path, '${DateTime.now()}.png');

      _saving = true;

      await Future.delayed(Duration(milliseconds: 500));
      await _cameraService.cameraController.stopImageStream();
      await Future.delayed(Duration(milliseconds: 200));
      await _cameraService.takePicture(imagePath);

      setState(() {
        _bottomSheetVisible = true;
        pictureTaked = true;
      });

      return true;
    }
  }

  /// draws rectangles when detects faces
  _frameFaces() {
    imageSize = _cameraService.getImageSize();

    _cameraService.cameraController.startImageStream((image) async {
      if (_cameraService.cameraController != null) {
        // if its currently busy, avoids overprocessing
        if (_detectingFaces) return;

        _detectingFaces = true;

        try {
          List<Face> faces = await _mlVisionService.getFacesFromImage(image);

          if (faces.length > 0) {
            setState(() {
              faceDetected = faces[0];
            });

            if (_saving) {
              _faceNetService.setCurrentPrediction(image, faceDetected);
              setState(() {
                _saving = false;
              });
            }
          } else {
            setState(() {
              faceDetected = null;
            });
          }

          _detectingFaces = false;
        } catch (e) {
          print(e);
          _detectingFaces = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double mirror = math.pi;
//    final width = MediaQuery.of(context).size.width;
//    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (pictureTaked) {
                return Container(
                  width: Constants().containerWidth(context),
                  height: Constants().containerHeight(context),
                  child: Transform(
                      alignment: Alignment.center,
                      child: Image.file(File(imagePath)),
                      transform: Matrix4.rotationY(mirror)),
                );
              } else {
                return Transform.scale(
                  scale: 1.0,
                  child: AspectRatio(
                    aspectRatio: MediaQuery.of(context).size.aspectRatio,
                    child: OverflowBox(
                      alignment: Alignment.center,
                      child: FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Container(
                          width: Constants().containerWidth(context),
                          height: Constants().containerWidth(context) /
                              _cameraService.cameraController.value.aspectRatio,
                          child: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              CameraPreview(_cameraService.cameraController),
                              CustomPaint(
                                painter: FacePainter(
                                    face: faceDetected, imageSize: imageSize),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: !_bottomSheetVisible
            ? AuthActionButton(
                _initializeControllerFuture,
                onPressed: onShot,
                name: widget.name,
                idd: widget.idd,
                pic: widget.pic,
                lat: widget.lat,
                lng: widget.lng,
                mContext: context,
              )
            : Container());
  }
}

import 'dart:async';

import 'package:audio_recorder/audio_recorder.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:newproject/Interfaces/ImageCallBAck.dart';
import 'package:newproject/Interfaces/callBackWidget.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/Images_path.dart';
import 'package:newproject/Utiles/LoadImage.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/Utiles/database.dart';
import 'package:newproject/Utiles/strings.dart';
import 'package:newproject/Utiles/util.dart';
import 'package:newproject/common/ImagePreview.dart';
import 'dart:io' as io;
import 'package:file/local.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:newproject/pages/version_2_files/MediaFileUploading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permissions_plugin/permissions_plugin.dart';

class AddQuery extends StatefulWidget {
  final LocalFileSystem localFileSystem;

  AddQuery({localFileSystem})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();
  @override
  _AddQueryState createState() => _AddQueryState();
}

class _AddQueryState extends State<AddQuery> with SingleTickerProviderStateMixin implements WidgetCallBack,ImageCallBack {
  String _senderEmail, _receiverEmail, _description;
  TextEditingController _senderEmailCtrl =
      TextEditingController(text: Constants.email);
  AudioPlayer _audioPlayer;
  GifController controller;
  TextEditingController _subjectCtrl = TextEditingController();
  TextEditingController _descriptionCtrl = TextEditingController();
  List _departList;
  bool _isLoading = false, _record = false,isPlaying=false;
  File _image;
  String _imgURL = "", _audioFileName = "";
  String selectDepart;
  Recording _recording = new Recording();
  List<NetworkImage> images;
  final TextEditingController _audioPathController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = GifController(vsync: this);
    images = new List<NetworkImage>();
    _departList = [
      "Select Department",
      "Network Team",
      "Mobile Team",
      "Web Team",
      "ROR Team"
    ];
    selectDepart = "Select Department";
    _audioPlayer = AudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Row(
          children: [
            SizedBox(width: 35.0),
            Image.asset(
              Img.myOfficeImage,
              width: 20.0,
            ),
            SizedBox(width: 10.0),
            Text(
              "Add Query",
              textAlign: TextAlign.center,
              style: Constants().txtStyleFont16(ColorsUsed.whiteColor, 21.0),
            ),
          ],
        ),
        backgroundColor: ColorsUsed.baseColor,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 40.0),
              child: Column(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(35.0),
                      bottomRight: Radius.circular(35.0),
                    ),
                    child: Container(
                      height: Constants().containerHeight(context) / 5.5,
                      width: Constants().containerWidth(context),
                      color: ColorsUsed.baseColor,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20.0,
                        Constants().containerHeight(context) / 7, 20.0, 20.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: [
                            Icon(Img.emailIcon,size: 20.0,color: Colors.grey,),
                            SizedBox(width: 10.0),
                            Expanded(child: _enterEmail("From", true, _senderEmailCtrl, "Email")),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        departName(),
                        SizedBox(height: 20.0),
                        Row(
                          children: [
                            Image.asset(Img.notesTitleImage,width: 20.0,color: Colors.grey,),
                            SizedBox(width: 10.0),
                            Expanded(
                              child: _enterEmail("Subject", false, _subjectCtrl,
                                  "Enter query subject"),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Row(mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(child: showImage(context, "My Query")),
                          ],
                        ),
                        Row(mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                                onTap: () {
                                  LoadImage().showPicker(context, this);
                                },
                                child: CircleAvatar(
                                  child: Icon(Icons.upload_outlined),
                                )),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Row(mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(child: Constants.gifImage(controller)),
                            SizedBox(width: 10.0),
                            deleteRecord()
                          ],
                        ),
                        SizedBox(height: 20.0),
                        _descriptionBox(),
                        SizedBox(height: 20.0),
                        _showCircularSubmit(),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment(0.8, -1.8),
              heightFactor: 0.1,
              child: Image.asset(
                "Images/forgotPassword/forgot.png",
                width: Constants().containerHeight(context) / 4.8,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _showCircularSubmit() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Row(
      children: <Widget>[
        Expanded(
            child: Constants()
                .buttonRaised(context, ColorsUsed.baseColor, S.submit, this))
      ],
    );
  }

  Widget departName() {
    return Row(
      children: <Widget>[
        Image.asset(Img.deptImage,width: 20.0,color: Colors.grey,),
        SizedBox(width: 10.0),
        Expanded(
          child: Container(
            child: DropdownButton<String>(
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  size: 30.0,
                  color: Colors.black,
                ),
                isExpanded: true,
                items: _departList?.map((item) {
                      return new DropdownMenuItem<String>(
                          child: new Text(
                            item,
                            style: TextStyle(fontSize: 14.0),
                          ),
                          value: item);
                    })?.toList() ??
                    [],
                onChanged: (String valueSelected) async {
                  setState(() {
                    selectDepart = valueSelected;
                    print(selectDepart);
                  });
                },
                value: selectDepart),
          ),
        ),
      ],
    );
  }

  Widget _enterEmail(String _prefixText, bool _readValue,
      TextEditingController _controller, String hitText) {
    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
      child: TextField(
        controller: _controller,
        readOnly: _readValue,
        onChanged: (value) {},
        decoration: InputDecoration(
          labelText: _prefixText,
          hintText: hitText,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300], width: 2.0),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ColorsUsed.baseColor, width: 2.0),
          ),
//          prefixText: "$_prefixText  "
        ),
      ),
    );
  }

  _descriptionBox() {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: TextField(
        controller: _descriptionCtrl,
        maxLines: 6,
        onChanged: (value) {},
        decoration: InputDecoration(
          hintText: "Add Query",
          contentPadding: EdgeInsets.fromLTRB(8.0, 15.0, 5.0, 10.0),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide.none,
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide.none,
          ),
//          prefixText: "$_prefixText  "
        ),
      ),
    );
  }

  @override
  void callBackInterface(String title) {
    switch (title) {
      case "Submit":
        validation();
        break;
      case "Camera":
        cameraMethod();
        break;
      case "Gallery":
        galleryMethod();
        break;
      case S.START_RECORD:

        _start();
        break;
      case S.STOP_RECORD:
        Constants.stopGifAnimation(controller);
        _stop();
        break;
      case S.DELETE_RECORD:
        setState(() {
          _record = false;
          _audioFileName = "";
          _audioPathController.text = "";
          _recording = new Recording(duration: new Duration(), path: "");
        });
        break;
    }
  }

  validation() async {
    if (selectDepart == "Select Department") {
      Constants.showToast("Please Select Department");
    } else {
      if (_subjectCtrl.text.isNotEmpty) {
        if (_descriptionCtrl.text.length > 10) {
          Map<String, dynamic> chatMessageMap = {
            "message": _descriptionCtrl.text,
            "sender": Constants.userName,
            "department": selectDepart,
            "subject": _subjectCtrl.text,
            'time': DateTime.now().millisecondsSinceEpoch,
            'userId': Constants.userId,
            'status': 'open',
          };
          setState(() {
            _isLoading = true;
          });
          DatabaseMethods().addQuery(chatMessageMap);

          Timer(Duration(seconds: 2), () {
            Constants.showToast("Query Posted!!");
            Navigator.pop(context);
          });
        } else {
          Constants.showToast(
              "Please add Proper description of query(Minimum 15 Words)");
        }
      } else {
        Constants.showToast("Please add Subject of query");
      }
    }
  }

  deleteRecord() {
    if (_audioFileName.isEmpty) {
      return _record
          ? InkWell(
              onTap: () {
                Constants.popUpFortwoOptions(
                    context, S.STOP_RECORD, S.CONFIRM_MESSAGE, this);
              },
              child: CircleAvatar(
                child: Icon(Icons.mic_none_outlined),
              ),
            )
          : InkWell(
              onTap: () {
                Constants.popUpFortwoOptions(
                    context, S.START_RECORD, S.CONFIRM_MESSAGE, this);
              },
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.mic_none_outlined,
                  color: Colors.white,
                ),
              ),
            );
    } else {
      return Row(children: [
        !isPlaying? InkWell(
          onTap: () {
            Constants.startGifAnimation(controller);
            play(Constants.ImageBaseUrl+_audioFileName);
          },
          child: CircleAvatar(
            backgroundColor: Colors.blue,
            child: Icon(
              Icons.play_arrow_outlined,
              color: Colors.white,
            ),
          ),
        ):InkWell(
          onTap: () {
            Constants.stopGifAnimation(controller);
            pause();
          },
          child: CircleAvatar(
            backgroundColor: Colors.blue,
            child: Icon(
              Icons.pause,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
  /*      Visualizer(
          builder: (BuildContext context, List<int> wave) {
            return new CustomPaint(
              painter: new MultiWaveVisualizer(
                waveData: wave,
                height: 20,
                color: Colors.blueAccent,
              ),
              child: new Container(),
            );
          },
          id:5,
        ),*/
        InkWell(
          onTap: () {
            Constants.popUpFortwoOptions(
                context, S.DELETE_RECORD, S.CONFIRM_MESSAGE, this);
          },
          child: CircleAvatar(
            backgroundColor: Colors.red,
            child: Icon(
              Icons.delete_outline,
              color: Colors.white,
            ),
          ),
        )
      ]);
    }
  }

  _start() async {
    try {
      if (await AudioRecorder.hasPermissions) {
        Constants.startGifAnimation(controller);
        if (_audioPathController.text != null &&
            _audioPathController.text != "") {
          String path = _audioPathController.text;
          if (!_audioPathController.text.contains('/')) {
            io.Directory appDocDirectory =
                await getApplicationDocumentsDirectory();
            path = appDocDirectory.path + Constants.FOLDER_NAME + _audioPathController.text;
          }
          print("Start recording: $path");

          await AudioRecorder.start(
              path: path, audioOutputFormat: AudioOutputFormat.AAC);
        } else {
          await AudioRecorder.start();
        }
        bool isRecording = await AudioRecorder.isRecording;
        setState(() {
          _recording = new Recording(duration: new Duration(), path: "");
          _record = isRecording;
        });

        //startHandler(false);
      } else {
        Map<Permission, PermissionState> permission =
            await PermissionsPlugin.requestPermissions(
                [Permission.WRITE_EXTERNAL_STORAGE, Permission.RECORD_AUDIO]);
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  _stop() async {
    setState(() {
      _isLoading = true;
    });
    var recording = await AudioRecorder.stop();
    print("Stop recording: ${recording.path}");
    bool isRecording = await AudioRecorder.isRecording;
    File file = widget.localFileSystem.file(recording.path);
    print("  File length: ${await file.length()}");
    setState(() {
      _recording = recording;
      _record = isRecording;
      _audioFileName = recording.path.toString();
    });
    print(_audioFileName);
//    startHandler(true);
    _audioPathController.text = recording.path;
    MediaFilesUpload().uploadAudio(recording, context).then((value) {
      this.setState(() {
        _isLoading = false;
        _audioFileName = value;
      });
    });
  }
  play(String audioUr) async {
    int result = await _audioPlayer.play(audioUr);
    if (result == 1) {
      setState(() {
        isPlaying = true;
      });
      _audioPlayer.onPlayerCompletion.listen((event) {
        setState(() => isPlaying = false);
      });
    } else {
      Constants.showToast("No Audio Found");
    }
  }

  pause() async {
    await _audioPlayer.pause();
    setState(() {
      isPlaying = false;
    });
  }
  Widget showImage(BuildContext context, String name) {
    return images.length > 0
        ? Util.listOfImages(context: context,images: images,name: name,widgetCallBack: this)
        : new Container(
            height: 0.0,
          );
  }

//gallery method

  galleryMethod() async {
    if (_isLoading) {
      Constants.showToast(S.UPLOADING);
    } else {
      /*if (_multipleImageURI.length == 2) {
        Constants.showToast(S.MAX_ATTACH);
      } else {*/
      _image = await ImagePicker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 1000,
          maxWidth: 1200,
          imageQuality: 70);

      if (_image != null) {
        setState(() {
          _isLoading = true;
        });
      }
      MediaFilesUpload().uploadImage(_image, context).then((value) {
        print(value);
        setState(() {
          _isLoading = false;
          images.add(NetworkImage(Constants.ImageBaseUrl + value));
        });
      });
//      }
    }
  }

  //camera method
  cameraMethod() async {
    if (_isLoading) {
      Constants.showToast(S.UPLOADING);
    } else {
      _image = await ImagePicker.pickImage(
          source: ImageSource.camera,
          maxHeight: 1000,
          maxWidth: 1200,
          imageQuality: 70);
      if (_image != null) {
        setState(() {
          _isLoading = true;
        });
      }
      print(_imgURL);
      MediaFilesUpload().uploadImage(_image, context).then((value) {
        print(value);
        setState(() {
          _isLoading = false;
          images.add(NetworkImage(Constants.ImageBaseUrl + value));
        });
      });
    }
  }

  @override
  void imageCallBackInterface(String type, int i) {
    switch(type){
      case "My Query":
        setState(() {
          images.removeAt(i);
        });
    }
  }
}

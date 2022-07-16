import 'dart:async';
import 'dart:math';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:newproject/Interfaces/callBackWidget.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/LoadImage.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/Utiles/database.dart';
import 'package:newproject/Utiles/message_tile.dart';
import 'package:newproject/Utiles/strings.dart';
import 'package:newproject/common/AudioTile.dart';
import 'dart:io';
import 'package:permissions_plugin/permissions_plugin.dart';
import 'dart:io' as io;
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newproject/common/ImageTile.dart';
import 'package:newproject/pages/homeOptions/Add_Notes/Add_Notes.dart';
import 'package:newproject/pages/version_2_files/MediaFileUploading.dart';
import 'package:path_provider/path_provider.dart';

class ChatPage extends StatefulWidget {
  final LocalFileSystem localFileSystem;

  ChatPage({localFileSystem})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();


  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> implements WidgetCallBack {
  Stream<QuerySnapshot> _chats;
  TextEditingController messageEditingController = new TextEditingController();
  final TextEditingController _audioPathController = TextEditingController();
  ScrollController _controller = ScrollController();
  File _image;
  Recording _recording;
  Random random = new Random();
  bool _isLoading = false,isRecord=false;
  String checkMsg = "";

  Widget _chatMessages() {
    return StreamBuilder(
      stream: _chats,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                controller: _controller,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  if (snapshot.data.documents[index].data["type"] == 1) {
                    return MessageTile(
                      message: snapshot.data.documents[index].data["message"],
                      sender: snapshot.data.documents[index].data["sender"],
                      profilePic:
                          snapshot.data.documents[index].data["profile"],
                      timestamp: snapshot.data.documents[index].data["time"],
                      sentByMe: Constants.userId ==
                          snapshot.data.documents[index].data["userId"],
                    );
                  } else if (snapshot.data.documents[index].data["type"] == 2) {
                    return ImageTile(
                      attachmentImg:
                          snapshot.data.documents[index].data["attachmentImg"],
                      sender: snapshot.data.documents[index].data["sender"],
                      profilePic:
                          snapshot.data.documents[index].data["profile"],
                      timestamp: snapshot.data.documents[index].data["time"],
                      sentByMe: Constants.userId ==
                          snapshot.data.documents[index].data["userId"],
                    );
                  }else if (snapshot.data.documents[index].data["type"] == 3) {
                    return AudioBar(
                      audioUrl:
                          snapshot.data.documents[index].data["audioUrl"],
                      sender: snapshot.data.documents[index].data["sender"],
                      profilePic:
                          snapshot.data.documents[index].data["profile"],
                      timestamp: snapshot.data.documents[index].data["time"],
                      sentByMe: Constants.userId ==
                          snapshot.data.documents[index].data["userId"],
                    );
                  }
                })
            : Container();
      },
    );
  }

  _sendMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "type": 1,
        "message": messageEditingController.text,
        "sender": Constants.userName,
        'time': DateTime.now().millisecondsSinceEpoch,
        'userId': Constants.userId,
        'profile':
            "http://conferenceoeh.com/wp-content/uploads/profile-pic-dummy.png",
      };

      DatabaseMethods().sendMessage(Constants.GROUP_CHAT_ID, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
        checkMsg="";
      });
      Timer(Duration(milliseconds: 300),
          () => _controller.jumpTo(_controller.position.maxScrollExtent));
    }
  }

  @override
  void initState() {
    super.initState();
    _recording = new Recording();
    Timer(Duration(milliseconds: 500),
        () => _controller.jumpTo(_controller.position.maxScrollExtent));
    DatabaseMethods().getGroupChats(Constants.GROUP_CHAT_ID).then((val) {
      // print(val);
      setState(() {
        _chats = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(Constants().containerHeight(context) * 0.08),
          child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
              ),
              child: AppBar(
                title: Text('My Office ERP',
                    style: TextStyle(color: Colors.white)),
                centerTitle: true,
                backgroundColor: ColorsUsed.baseColor,
                elevation: 0.0,
              ))),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(child: _chatMessages()),
          ),
          !_isLoading
              ? Container(
                  padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 10.0),
                  alignment: Alignment.bottomCenter,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(15.0, 0.0, 10.0, 0.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Colors.grey[400]),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
                              setState(() {
                                checkMsg = value;
                                print(checkMsg);
                              });
                            },
                            textCapitalization: TextCapitalization.sentences,
                            controller: messageEditingController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                hintText: "Send a message ...",
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                border: InputBorder.none),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        !isRecord?GestureDetector(
                          onTap: () {
                            LoadImage().showPicker(context, this);
                          },
                          child: CircleAvatar(
                            radius: 20.0,
                            backgroundColor: ColorsUsed.whiteColor,
                            child: Image.asset(
                              "Images/attach 1.png",
                              width: 22.0,
                            ),
                          ),
                        ):GestureDetector(
                          onTap: () {
                            //record Audio
                            setState(() {
                              checkMsg="";
                              isRecord=false;
                            });

                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.red,
                            child: Icon(
                              Icons.cancel_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        !checkMsg.isEmpty
                            ? GestureDetector(
                                onTap: () {
                                  !isRecord?_sendMessage():_stop();
                                },
                                child: CircleAvatar(
                                  radius: 20.0,
                                  backgroundColor: ColorsUsed.baseColor,
                                  child: Image.asset(
                                    "Images/Send (1).png",
                                    width: 22.0,
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  //record Audio
                                  setState(() {
                                    checkMsg="a";
                                    isRecord=true;
                                  });
                                  _start();
                                },
                                child: CircleAvatar(
                                  backgroundColor: ColorsUsed.baseColor,
                                  child: Icon(
                                    Icons.mic_none_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                      ],
                    ),
                  ),
                )
              : Center(child: CircularProgressIndicator())
        ],
      ),
    );
  }

  @override
  void callBackInterface(String title) {
    switch (title) {
      case "Camera":
        cameraMethod();
        break;
      case "Gallery":
        galleryMethod();
        break;
    }
  }

  galleryMethod() async {
    if (_isLoading) {
      Constants.showToast(S.UPLOADING);
    } else {
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
        setState(() {
          _isLoading = false;
        });
        setImageByFirebase("attachmentImg",2,S.IMAGE_PATH + value);
      });
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
      MediaFilesUpload().uploadImage(_image, context).then((value) {
        setState(() {
          _isLoading = false;
        });
        setImageByFirebase("attachmentImg",2,S.IMAGE_PATH + value);
      });
    }
  }

  void setImageByFirebase(String value, int i,String url) {
    if (url.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "type": i,
        value: url,
        "sender": Constants.userName,
        'time': DateTime.now().millisecondsSinceEpoch,
        'userId': Constants.userId,
        'profile':
            "http://conferenceoeh.com/wp-content/uploads/profile-pic-dummy.png",
      };

      DatabaseMethods().sendMessage(Constants.GROUP_CHAT_ID, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
      Timer(Duration(milliseconds: 300),
          () => _controller.jumpTo(_controller.position.maxScrollExtent));
    }
  }

  _start() async {
    try {
      if (await AudioRecorder.hasPermissions) {
        if (_audioPathController.text != null && _audioPathController.text != "") {
          String path = _audioPathController.text;
          if (!_audioPathController.text.contains('/')) {
            io.Directory appDocDirectory =
            await getApplicationDocumentsDirectory();
            path = appDocDirectory.path + '/' + _audioPathController.text;
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
          isRecord = isRecording;
        });


        //startHandler(false);
      } else {
        Map<Permission, PermissionState> permission = await PermissionsPlugin
            .requestPermissions([
          Permission.WRITE_EXTERNAL_STORAGE,
          Permission.RECORD_AUDIO
        ]);
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
      isRecord = isRecording;
    });
//    startHandler(true);
    _audioPathController.text = recording.path;
    MediaFilesUpload().uploadAudio(recording, context).then((value) {
      this.setState(() {
        checkMsg="";
        _isLoading = false;
      });
      setImageByFirebase("audioUrl",3,S.IMAGE_PATH + value);

    });
  }
}

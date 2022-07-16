import 'dart:convert';
import 'dart:io';
import 'dart:io' as io;
import 'package:audio_recorder/audio_recorder.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:file/local.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newproject/Interfaces/ImageCallBAck.dart';
import 'package:newproject/Interfaces/callBackWidget.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/Images_path.dart';
import 'package:newproject/Utiles/LoadImage.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/Utiles/strings.dart';
import 'package:newproject/Utiles/util.dart';
import 'package:newproject/common/ImagePreview.dart';
import 'package:newproject/pages/version_2_files/MediaFileUploading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permissions_plugin/permissions_plugin.dart';

class QueryFollowUpAdd extends StatefulWidget {
  final LocalFileSystem localFileSystem;

  final queryId;

  //const FollowUpAdd({this.taskId});
  QueryFollowUpAdd({localFileSystem,this.queryId}) : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  _FollowUpActionState createState() => _FollowUpActionState();
}


class _FollowUpActionState extends State<QueryFollowUpAdd>  with SingleTickerProviderStateMixin
    implements WidgetCallBack,ImageCallBack {
  TextEditingController _titleCtrl = TextEditingController();
  bool _isLoading = false,_record=false;
  Recording _recording = new Recording();
  TextEditingController _descriptionCtrl = TextEditingController();
  List<NetworkImage> images;
  List imageArrayList = [];
  File _image;
  String _imgURL = "",_audioFileName="";
  String _audioUrl = "";
  GifController controller;
  DateFormat formatter = DateFormat('yyyy-M-dd, HH:mm:ss');

  final TextEditingController _audioPathController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    images = new List<NetworkImage>();
    controller = GifController(vsync: this);
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Row(
          children: [
            SizedBox(width: 20.0),
            Image.asset(
              Img.myOfficeImage,
              width: 20.0,
            ),
            SizedBox(width: 10.0),
            Text(
              "Add Follow Up",
              textAlign: TextAlign.center,
              style: Constants().txtStyleFont16(ColorsUsed.whiteColor, 21.0),
            ),
          ],
        ),
        backgroundColor: ColorsUsed.baseColor,
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
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
                    padding: EdgeInsets.fromLTRB(
                        20.0,
                        Constants().containerHeight(context) / 7,
                        20.0,
                        20.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: [
                            Icon(
                              Img.emailIcon,
                              size: 20.0,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 10.0),
                            Expanded(
                                child: _enterEmail(
                                    "Title", false, _titleCtrl, "Title")),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(child: showImage(context, "My Tasks")),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                                onTap: () {
                                  if (images.length < 5) {
                                    LoadImage().showPicker(context, this);
                                  }
                                },
                                child: CircleAvatar(
                                  child: Icon(Icons.upload_outlined),
                                )),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Image.asset(Img.uploadAudioImage,width: 20.0,color: Colors.grey),
                            SizedBox(width: 10.0,),
                            Expanded(
                                child: Constants.gifImage(controller)
                            ),SizedBox(width: 10.0,),
                            deleteRecord(),
                          ],
                        ),
                        Row(
                          children: [
                            Image.asset(
                              Img.notesTitleImage,
                              width: 20.0,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 10.0),
                            Expanded(
                              child: _enterEmail("Subject", false,
                                  _descriptionCtrl, "Enter description"),
                            ),
                          ],
                        ),
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

  //gallery method

  galleryMethod() async {
    if (_isLoading) {
      Constants.showToast(S.UPLOADING);
    } else {
      _image = await ImagePicker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 1000,
          maxWidth: 1200,
          imageQuality: 70);
      setState(() {
        _imgURL = _image.path.split('/').last.substring(12); //.toString();
      });
      print(_imgURL);
      MediaFilesUpload().uploadImage(_image, context).then((value) {
        print(value);
        setState(() {
          imageArrayList.add(value);
          images.add(NetworkImage(Constants.ImageBaseUrl + value));
        });
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
      setState(() {
        _imgURL = _image.toString();
      });
      print(_imgURL);
      MediaFilesUpload().uploadImage(_image, context).then((value) {
        print(value);
        setState(() {
          imageArrayList.add(value);
          images.add(NetworkImage(Constants.ImageBaseUrl + value));
        });
      });
    }
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

  //get Task lists
  var _response;

  /*https://tasla.app/MyOffice/index.php?action=followupQueriesInsert&queryId=8&followupTitle=8&
  followup_date=2021-01-15%2002:36:15&followup_by=8&imagesUrl=8&audioUrl=8&Status=8&Description=8*/
  Future<dynamic> _addFollowUp() async {
    DateTime now = DateTime.now();
    String dateToday = formatter.format(now);
    print(
        "${Constants.BaseUrl}action=followupQueriesInsert&followup_by=${Constants.userId}&queryId=${widget.queryId}&"
            "followupTitle=${_titleCtrl.text}&followup_date=${dateToday}&Description=${_descriptionCtrl.text}&imagesUrl=$imageArrayList"
            "&audioUrl=$_audioUrl&status=0");
    try {
      await http
          .get(
          "${Constants.BaseUrl}action=followupQueriesInsert&followup_by=${Constants.userId}&queryId=${widget.queryId}&"
              "followupTitle=${_titleCtrl.text}&followup_date=${dateToday}&Description=${_descriptionCtrl.text}&imagesUrl=$imageArrayList"
              "&audioUrl=$_audioUrl&status=0")
          .then((res) {
        print(res.body);
        print("status${res.body}");
        setState(() {
          _response = json.decode(res.body);
        });
        final int statusCode = res.statusCode;
        print(statusCode);
        if (statusCode == 200) {
          print("check 200${_response["success"]}");
          if (_response["success"] == 1) {
            setState(() {
              _isLoading = false;
            });
            Navigator.pop(context, true);
          }
        }
      });
    } on SocketException catch (_) {
      print('not connected');
      Constants().noInternet(context);
    } catch (e) {}
  }

  Widget showImage(BuildContext context, String name) {
    if (images != null) {
      return images.length > 0
          ? /*Container(
              height: 120.0,
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              width: Constants().containerWidth(context),
              child: ListView.builder(
                  itemCount: images.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) {
                    return Stack(
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
                                          builder: (context) => ImagePreview(
                                              images[i].url, name)));
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
                              setState(() {
                                images.removeAt(i);
                              });
                            },
                            child: Icon(
                              Icons.cancel_outlined,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
            )*/Util.listOfImages(context: context,images: images,name: "FollowUp Task",widgetCallBack: this)
          : new Container(
        height: 0.0,
      );
    } else {
      return Container();
    }
  }

  @override
  void callBackInterface(String title) {
    switch (title) {
      case S.submit:
        if (_titleCtrl.text.isNotEmpty) {
          if (imageArrayList.length != 0) {
            if (_descriptionCtrl.text.isNotEmpty) {
              setState(() {
                _isLoading = true;
              });
              _addFollowUp();
            } else {
              Constants.showToast("Add description");
            }
          } else {
            Constants.showToast("Add atleast one image");
          }
        } else {
          Constants.showToast("Add title");
        }
        break;
      case "Camera":
        cameraMethod();
        break;
      case "Gallery":
        galleryMethod();
        break;
      case S.STOP_RECORD:
        Constants.stopGifAnimation(controller);
        _stop();
        break;
      case S.START_RECORD:

        _start();
        break;
      case S.DELETE_RECORD:
        setState(() {
          _record=false;
          _audioFileName="";
          _audioPathController.text="";
          _recording = new Recording(duration: new Duration(), path: "");
        });
    }
  }

  @override
  void imageCallBackInterface(String type, int i) {
    switch(type){
      case "FollowUp Task":
        setState(() {
          images.removeAt(i);
        });
    }
  }

  deleteRecord() {
    if(_audioFileName.isEmpty){
      return   _record?InkWell(
        onTap: (){
          Constants.popUpFortwoOptions(context, S.STOP_RECORD, S.CONFIRM_MESSAGE, this);
        },
        child: CircleAvatar(
          child: Icon(Icons.mic_none_outlined),),
      ) :InkWell(
        onTap: (){
          Constants.popUpFortwoOptions(context, S.START_RECORD, S.CONFIRM_MESSAGE, this);
        },
        child: CircleAvatar(backgroundColor: Colors.grey,
          child: Icon(Icons.mic_none_outlined,color: Colors.white,),),
      );
    }else{
      return  InkWell(
        onTap: (){
          Constants.popUpFortwoOptions(context, S.DELETE_RECORD, S.CONFIRM_MESSAGE, this);
        },
        child: CircleAvatar(backgroundColor: Colors.red,
          child: Icon(Icons.delete_outline,color: Colors.white,),),
      );
    }

  }
  _start() async {
    try {
      if (await AudioRecorder.hasPermissions) {
        Constants.startGifAnimation(controller);
        if (_audioPathController.text != null && _audioPathController.text != "") {
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
      _record = isRecording;
      _audioFileName= recording.path.toString();
    });print(_audioFileName);
//    startHandler(true);
    _audioPathController.text = recording.path;
    MediaFilesUpload().uploadAudio(recording, context).then((value) {
      this.setState(() {
        _isLoading = false;
        _audioUrl=value;
      });
    });
  }

}

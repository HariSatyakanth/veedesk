import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'dart:math';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:file/local.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:newproject/Interfaces/ImageCallBAck.dart';
import 'package:newproject/Interfaces/callBackWidget.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/Images_path.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/Utiles/strings.dart';
import 'package:newproject/Utiles/util.dart';
import 'package:newproject/common/ImagePreview.dart';
import 'package:newproject/pages/version_2_files/ImagePickerPath.dart';
import 'package:newproject/pages/version_2_files/MediaFileUploading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permissions_plugin/permissions_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AddNotes extends StatefulWidget {
  final LocalFileSystem localFileSystem;

  AddNotes({localFileSystem})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  _AddNotesState createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes>with SingleTickerProviderStateMixin implements WidgetCallBack,ImageCallBack {
  double _progess = 0;
  File _image;
  List<File> _multipleImageURI = [];
  List<String> _multipleImageURL;
  String _imgURL = "",_audioFileName="";
  bool _isLoading = false,_record=false;
  int audioTimer=60;
  Timer timer;
  List audioArrayList = [];
  List imageArrayList = [];
  bool _loader = false;
  List<NetworkImage> images;
  Timer _timer;
  bool checkTime=true;
  int _startTime = 60;
  GifController controller;

  static var  imageController;
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _audioPathController = TextEditingController();
  Recording _recording = new Recording();
  Random random = new Random();
  DateTime now;
  DateFormat formatter = DateFormat('yyyy-M-dd, HH:mm:ss');
  String dateToday;

  @override
  void initState(){
    super.initState();
    images = new List<NetworkImage>();
    controller = GifController(vsync: this);
    imageController = TextEditingController(text: "Image Upload");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarOptions(),
      body: _loader?Center(child: CircularProgressIndicator()): SingleChildScrollView(
        child: Stack(
          children: [
            Container(padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 30.0),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25.0),
                      bottomRight: Radius.circular(25.0),
                    ),
                    child: Container(
                      padding: EdgeInsets.only(top: Constants().containerHeight(context)*0.0),
                      height: Constants().containerHeight(context)/5.5,
                      width: Constants().containerWidth(context),
                      color: ColorsUsed.baseColor,
                    ),
                  ),
                 Container(padding: EdgeInsets.fromLTRB(25.0, 25, 25.0, 10),
                   child: Column(
                     children: [
                       SizedBox(height: Constants().containerHeight(context)*0.06),
                       Row(
                         children: [
                           Image.asset(Img.notesTitleImage,width: 20.0,color: Colors.grey,),
                           SizedBox(width: 10.0,),
                           Expanded(
                             child: Constants.commonEditTextFieldWithoutIcon( _notesController, false,
                                 "Notes Title", "", TextInputType.multiline),
                           ),
                         ],
                       ),
                       SizedBox(height: Constants().containerWidth(context)*0.04),

                       Row(
                         children: [
                           Image.asset(Img.uploadAudioImage,width: 20.0,color: Colors.grey),
                           SizedBox(width: 10.0,),
                           Expanded(
                             child: Constants.gifImage(controller)
                           ),SizedBox(width: 10.0,),
                           deleteRecord(),
                         ],
                       ),SizedBox(height: 10.0,),
//              Text("duration: "+_recording.duration.toString(),style: Constants().txtStyleFont16(Colors.black, 13.0),),
//              Text("timer: 00:"+audioTimer.toString(),style: Constants().txtStyleFont16(Colors.black, 13.0),),


                       SizedBox(height: Constants().containerWidth(context)*0.01),
                       Row(mainAxisAlignment: MainAxisAlignment.start,
                         children: [
                           Expanded(child: showImage(context, "My Notes")),
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
                       SizedBox(height: Constants().containerWidth(context)*0.06),
                       Constants.descriptionField(context, "Add Description", "", _descController, null, null),
                       SizedBox(height: Constants().containerWidth(context)*0.1),
                       Row(
                         children: [SizedBox(width: Constants().containerWidth(context)*0.1),
                           Expanded(child: Constants().buttonRaised(context, ColorsUsed.baseColor, S.submit, this)),
                           SizedBox(width: Constants().containerWidth(context)*0.1),],
                       )
                     ],
                   ),
                 )
                ],
              ),),
            Align(
              alignment: Alignment(0.0,-2.15),
              heightFactor: 0.1,
              child: Image.asset("Images/task/add notes.png",
                width: Constants().containerHeight(context)*0.2,),
            )
          ],
        ),
      ),
    );
  }

  //AppBAr
  _appBarOptions() {
    return AppBar(
      backgroundColor: ColorsUsed.baseColor,
      centerTitle: true,elevation: 0.0,
      title: Row(
        children: [SizedBox(width: 35.0),
          Image.asset(Img.myOfficeImage,width: 20.0,),
          SizedBox(width: 10.0),
          Text("Add Notes",
            style: Constants().txtStyleFont16(ColorsUsed.whiteColor,18.0),
          ),
        ],
      ),
    );
  }
  reverseCounter({int check}){
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_startTime == 0 || check==0) {
          if(checkTime){
          setState(() {
            checkTime=false;
            timer.cancel();
            _stop();
          });
          }
        } else {
          setState(() {
            _startTime--;
          });
        }
      },
    );
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
      _image = await ImagePicker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 1000,
          maxWidth: 1200,
          imageQuality: 70);
      setState(() {
        _imgURL = _image.toString();
        imageController = TextEditingController(text: _imgURL);
      });
      print(_imgURL);
      MediaFilesUpload().uploadImage(_image,context).then((value) {
        print(value);
        setState(() {
          _loader = false;
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
        imageController = TextEditingController(text: _imgURL);
      });
      print(_imgURL);
      MediaFilesUpload().uploadImage(_image,context).then((value) {
        print(value);
        setState(() {
          _loader = false;
          imageArrayList.add(value);
          images.add(NetworkImage(Constants.ImageBaseUrl + value));
        });
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
      _loader = true;
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
          _loader = false;
        audioArrayList.add(value);
      });
    });
  }


  Future<dynamic> addNotes(BuildContext context) async{
    setState(() {
      _loader= true;
    });
    try{
      await http.get("${Constants.BaseUrl}action=noteInsert&userId= ${Constants.userId}&"
          "title=${_notesController.text}&discription=${_descController.text}&"
          "imageUpload=$imageArrayList&audioUpload=$audioArrayList&dateTime= $dateToday&"
          "company_id= ${S.companyId}"
      ).then(( res) {
        print("hello");
        print(res.body);
        var response = json.decode(res.body);
        final int statusCode = res.statusCode;
        print(statusCode);
        if (statusCode == 200) {
          print("its working 200");
          if(response["success"] == 1){
            print("in success");
            setState(() {
              _loader= false;
            });
            Constants.showToast(response["message"]);
            Navigator.pop(context,true);
          }else{
            setState(() {
              _loader= false;
            });
            Constants.showToast(response["message"]);
          }
        }else{
          Scaffold.of(context).showSnackBar(Constants().showSnackMessage(response["Something went wrong !"]));

        }
      });}on SocketException catch (_) {
      print('not connected');
      Constants().noInternet(context);
    }catch (e) {
    }
  }

  @override
  void callBackInterface(String title) {
    switch(title){
      case "Submit":
        print(audioArrayList);
        print("$imageArrayList");
       setState(() {
         now = DateTime.now();
         dateToday = formatter.format(now);
       });print(dateToday);
        validation();
        break;
      case "Camera":
        cameraMethod();
        break;
      case "Gallery":
        galleryMethod();
        break;
      case S.START_RECORD:

//        reverseCounter();
        _start();
        //play

        break;
      case S.STOP_RECORD:
        Constants.stopGifAnimation(controller);
        //0 for reset counter
//        reverseCounter(check: 0);
        _stop();
        break;
      case S.DELETE_RECORD:
        setState(() {
          _record=false;
          _audioFileName="";
          _audioPathController.text="";
          _recording = new Recording(duration: new Duration(), path: "");
        });
        break;
    }
  }

   validation() {
    if(_notesController.text.isNotEmpty){
      if(_descController.text.isNotEmpty){
        if(imageArrayList.isNotEmpty){
          if(audioArrayList.isNotEmpty){
            addNotes(context);
          }else{
            Constants.showToast("Add atleast one audio");
          }
        }else{
          Constants.showToast("Add atleast one image");
        }
      }else{
        Constants.showToast("Add description");
      }
    }else{
      Constants.showToast("Add title");
    }
   }

  @override
  void imageCallBackInterface(String type, int i) {
    switch(type){
      case "My Notes":
        setState(() {
          images.removeAt(i);
        });
    }
  }


}

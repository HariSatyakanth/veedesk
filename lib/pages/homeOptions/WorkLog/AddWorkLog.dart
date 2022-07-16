import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:io' as io;
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:http/http.dart'as http;
import 'package:audio_recorder/audio_recorder.dart';
import 'package:file/local.dart';
import 'package:flutter/material.dart';
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
import 'package:newproject/models/RolePojo.dart';
import 'package:newproject/pages/version_2_files/ImagePickerPath.dart';
import 'package:newproject/pages/version_2_files/MediaFileUploading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permissions_plugin/permissions_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddWorkLog extends StatefulWidget {
  final LocalFileSystem localFileSystem;

  AddWorkLog({localFileSystem})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();
  @override
  _AddWorkLogState createState() => _AddWorkLogState();
}

class _AddWorkLogState extends State<AddWorkLog> with SingleTickerProviderStateMixin implements WidgetCallBack,ImageCallBack{
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
  bool _loader = true;
  String projectNameId;
  Role projectNameDropdownValue;
  List<Role> projectNameList;
  String workLogStartTime,workLogEndTime;
  List<String> timeList = ["9:00 am","10:00 am",
    "11:00 am","12:00 am","1:00 pm","2:00 pm","3:00 pm","4:00 pm",
    "5:00 pm","6:00 pm","7:00 pm"];
  GifController controller;
  List<NetworkImage> images;
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
    projectNameList=new List<Role>();
    Role projectName  = Role(id: "0", role: "ProjectName");
    setState(() {
      projectNameDropdownValue= projectName;
      projectNameList.add(projectName);
      getprojectName(context);
    });
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
                      height: Constants().containerHeight(context)/4.5,
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
                            Image.asset(Img.projectNameImage,width: 20.0,),
                            SizedBox(width: 10.0),
                            Expanded(child: projectNameDropDown()),
                          ],
                        ),
                        SizedBox(height: Constants().containerHeight(context)*0.01),
                        Row(
                          children: [
                            Image.asset(Img.timeImage), SizedBox(width: 15.0,),
                            Expanded(child: timeStartListDropDown()),
                            SizedBox(width: 15.0,),
                            Text("-"),
                            SizedBox(width: 15.0,),
                            Image.asset(Img.timeImage),
                            SizedBox(width: 15.0,),
                            Expanded(child: timeEndListDropDown())
                          ],
                        ),
                        SizedBox(height: Constants().containerHeight(context)*0.01),
                        Row(
                          children: [
                            Image.asset(Img.notesTitleImage,width: 20.0,color: Colors.grey,),
                            SizedBox(width: 10.0,),
                            Expanded(
                              child: Constants.commonEditTextFieldWithoutIcon(_notesController, false,
                                  "Task Title", "", TextInputType.multiline),
                            ),
                          ],
                        ),
                        SizedBox(height: Constants().containerWidth(context)*0.04),

                        Row(
                          children: [
                            Image.asset(Img.uploadAudioImage,width: 20.0,color: Colors.grey,),
                            SizedBox(width: 10.0,),
                            Expanded(
                              child: Constants.gifImage(controller),
                            ),SizedBox(width: 10.0,),
                            deleteRecord(),
                          ],
                        ),SizedBox(height: 10.0,),
                        SizedBox(height: Constants().containerWidth(context)*0.01),
                        Row(mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(child: showImage(context, "WorkLog")),
                          ],
                        ),
                        SizedBox(height: Constants().containerWidth(context)*0.01),
                        _ImagePicker(imageController, "Image upload", "message"),
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
              alignment: Alignment(0.0,-2.2),
              heightFactor: 0.1,
              child: Image.asset("Images/task/add worklog banner.png",
                width: Constants().containerHeight(context)*0.18,),
            )
          ],
        ),
      ),
    );
  }

  Widget showImage(BuildContext context, String name) {
    return images.length > 0
        ? Util.listOfImages(context: context,images: images,name: "WorkLog",widgetCallBack: this)
        : new Container(
      height: 0.0,
    );
  }

  //AppBAr
  _appBarOptions() {
    return AppBar(
      backgroundColor: ColorsUsed.baseColor,elevation: 0.0,
      title: Row(
        children: [SizedBox(width: 35.0),
          Image.asset(Img.myOfficeImage,width: 20.0,),
          SizedBox(width: 10.0),
          Text("Add WorkLog",
            style: Constants().txtStyleFont16(ColorsUsed.whiteColor,18.0),
          ),
        ],
      ),
      centerTitle: true,
    );
  }

  _ImagePicker(TextEditingController _ctrl,String hint,message){
    return Row(
      children: [
        Image.asset(Img.uploadPicImage,width: 20.0,),
        SizedBox(width: 10.0,),
        Expanded(
          child: TextField(
            onTap: (){

            },
            readOnly: true,
            style: TextStyle(color: Colors.black54),
            controller: _ctrl,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(
                  color:Colors.grey[300],width: 2.0),),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(
                  color:ColorsUsed.baseColor,width: 2.0),),

            ),
          ),
        ),SizedBox(width: 10.0,),
        InkWell(
            onTap: (){
              LoadImage().showPicker(context,this);
            },
            child: CircleAvatar(
              child: Icon(Icons.upload_outlined),))
      ],
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
      //getCameraImage(_image);
      setState(() {
        _imgURL = _image.toString();
//        imageController = TextEditingController(text: _imgURL);
//        _multipleImageURI.add(_image);
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
//      }
    }
  }

  //camera method
  cameraMethod() async {
    if (_isLoading) {
      Constants.showToast(S.UPLOADING);
    } else {
      /*if (_multipleImageURI.length == 2) {
        Constants.showToast(S.MAX_ATTACH);
      } else {*/
      _image = await ImagePicker.pickImage(
          source: ImageSource.camera,
          maxHeight: 1000,
          maxWidth: 1200,
          imageQuality: 70);
      //getCameraImage(_image);
      setState(() {
        _imgURL = _image.toString();
//        imageController = TextEditingController(text: _imgURL);
//        _multipleImageURI.add(_image);
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
//      }
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

  void startHandler(bool cancel) {
    // Start the periodic timer which prints something after 5 seconds and then stop it .

    if(audioTimer == 0 || cancel){
      timer=  new Timer.periodic(new Duration(seconds: 1), (time) {
        timer.cancel();

      });
      _stop();
    }else{
      timer=  new Timer.periodic(new Duration(seconds: 1), (time) {
        //startHandler(false);
      });
      print("$audioTimer");
      setState(() {
        audioTimer=audioTimer-1;
      });
    }
  }

  //Role list
  Widget projectNameDropDown(){
    return DropdownButton<Role>(
      isExpanded: true,
      value: projectNameDropdownValue,
      onChanged: (Role newValue) {
        setState(() {
          projectNameId = newValue.id;
          projectNameDropdownValue = newValue;
        });
      },
      items:projectNameList
          .map<DropdownMenuItem<Role>>((Role value) {
        return DropdownMenuItem<Role>(
          value: value,
          child: Text(value.role),
        );
      }).toList(),
    );
  }

  //get projectName details
  Future<dynamic> getprojectName(BuildContext context) async{

    try{
      await http.get("${Constants.BaseUrl}action=getRole"
      ).then(( res) {
        print(res.body);
        var response = json.decode(res.body);
        final int statusCode = res.statusCode;
        print(statusCode);
        if (statusCode == 200) {
          setState(() {
            _loader = false;
          });
          print("its working 200");
          if(response["success"] == "1"){
            /*Role rolePojo= Role.fromJson(json.decode(res.body));*/
            for(int i=0;i<response["role"].length;i++){

              Role role  = Role(
                  id: response["role"][i]["Id"],
                  role: response["role"][i]["Role"]);
              setState(() {
                projectNameList.add(role);
              });


            }

          }
        }else{
//          Scaffold.of(context).showSnackBar(Constants().showSnackMessage(response["Something went wrong !"]));
        }
      });}on SocketException catch (_) {
      print('not connected');
      Constants().noInternet(context);
    }catch (e) {
    }
  }

  //time list
  Widget timeStartListDropDown(){
    return DropdownButton<String>(
      hint: Text("Start time"),
      isExpanded: false,
      value: workLogStartTime,
      onChanged: (String newValue) {
        setState(() {
          workLogStartTime = newValue;
        });
      },
      items:timeList
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }


  Widget timeEndListDropDown(){
    return DropdownButton<String>(
      hint: Text("End time"),
      isExpanded: false,
      value: workLogEndTime,
      onChanged: (String newValue) {
        setState(() {
          workLogEndTime = newValue;
        });
      },
      items:timeList
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

//  Future<dynamic> addNotes(BuildContext context) async{
//    setState(() {
//      _loader= true;
//    });
//    try{
//      await http.get("${Constants.BaseUrl}action=noteInsert&userId= ${Constants.userId}&"
//          "title=${_notesController.text}&discription=${_descController.text}&"
//          "imageUpload=$imageArrayList&audioUpload=$audioArrayList&dateTime= $dateToday&"
//          "company_id= ${S.companyId}"
//      ).then(( res) {
//        print("hello");
//        print(res.body);
//        var response = json.decode(res.body);
//        final int statusCode = res.statusCode;
//        print(statusCode);
//        if (statusCode == 200) {
//          print("its working 200");
//          if(response["success"] == 1){
//            print("in success");
//            setState(() {
//              _loader= false;
//            });
//            Constants.showToast(response["message"]);
//            Navigator.pop(context,true);
//          }else{
//            setState(() {
//              _loader= false;
//            });
//            Constants.showToast(response["message"]);
//          }
//        }else{
//          Scaffold.of(context).showSnackBar(Constants().showSnackMessage(response["Something went wrong !"]));
//
//        }
//      });}on SocketException catch (_) {
//      print('not connected');
//      Constants().noInternet(context);
//    }catch (e) {
//    }
//  }

  @override
  void callBackInterface(String title) async{
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

        _start();
        break;
      case S.STOP_RECORD:
        Constants.stopGifAnimation(controller);
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
      case "S.submit":
        Map jsonMap ={
          "data": await Constants.workLogList()
        };print(jsonMap);
        MediaFilesUpload().addWorkLog(jsonMap, context);
    }
  }

  validation() async {
    print("ekmd${await Constants.workLogList()}");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (projectNameDropdownValue.role != "ProjectName") {
      if(workLogStartTime != null){
        if(workLogEndTime != null){
          if (_notesController.text.isNotEmpty) {
            if (_descController.text.isNotEmpty) {
              if (imageArrayList.isNotEmpty) {
                if (audioArrayList.isNotEmpty) {
                  Map jsonMap = {
                    S.WORKlOG_USERID: Constants.userId,
                    S.WORKlOG_PROJECTNAME: projectNameDropdownValue.role,
                    S.WORKlOG_INITIALTIME: workLogStartTime,
                    S.WORKlOG_FINISHTIME: workLogEndTime,
                    S.WORKlOG_TITLE: _notesController.text,
                    S.WORKlOG_AUDIO: audioArrayList,
                    S.WORKlOG_IMAGE: imageArrayList,
                    S.WORKlOG_DESCRIPTION: _descController.text,
                    S.WORKlOG_DATE: ("${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}")
                  };
                  print(jsonMap);
                  List logList = [];
                //  logList.add(jsonMap);
                  if(await Constants.workLogList() != null){
                    logList = jsonDecode(await Constants.workLogList());
                    logList.add(jsonMap);
                  }else{
                    logList.add(jsonMap);
                  }
                  print("asba$logList");
                  print("WorkLogList${Constants.userId}");
                  prefs.setString("WorkLogList${Constants.userId}", jsonEncode(logList));
                  Constants.showToast("WorkLog Added Successfully");
                  Navigator.pop(context,true);
                } else {
                  Constants.showToast("Add atleast one audio");
                }
              } else {
                Constants.showToast("Add atleast one image");
              }
            } else {
              Constants.showToast("Add description");
            }
          } else {
            Constants.showToast("Add title");
          }
        } else {
          Constants.showToast("Select closing time");
        }
      } else {
        Constants.showToast("Select initial time");
      }
    }else{
      Constants.showToast("Select Project Name");
    }
  }

  @override
  void imageCallBackInterface(String type, int i) {
    switch(type){
      case "WorkLog":
        setState(() {
          images.removeAt(i);
        });
    }
  }


}

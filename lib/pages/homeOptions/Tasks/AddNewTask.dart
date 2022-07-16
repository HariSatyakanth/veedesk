import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:io' as io;
import 'package:audio_recorder/audio_recorder.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
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
import 'package:http/http.dart'as http;
import 'package:newproject/models/RolePojo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permissions_plugin/permissions_plugin.dart';

class AddNewTask extends StatefulWidget {
  final LocalFileSystem localFileSystem;

  AddNewTask({localFileSystem})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();
  @override
  _AddNewTaskState createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> with SingleTickerProviderStateMixin implements WidgetCallBack,ImageCallBack {
  double _progess = 0;
  String roleId,empId;
  File _image;
  List<File> _multipleImageURI = [];
  List<String> _multipleImageURL;
  String _imgURL = "",_audioFileName="";
  bool _isLoading = false,_record=false;
  Role roleDropdownValue;
  List<Role> roleList;
  Role empRoleDropdownValue;
  List<Role> empRoleList;

  static var imageController;
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _audioPathController = TextEditingController();
  GifController controller;
  Recording _recording = new Recording();
  Random random = new Random();
  int audioTimer=60;
  List audioArrayList = [];
  List imageArrayList = [];
  bool _loader = true;
  DateTime now;
  DateFormat formatter = DateFormat('yyyy-M-dd, HH:mm:ss');
  String dateToday;
  List<NetworkImage> images;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  @override
  void initState(){
    super.initState();
    roleList=new List<Role>();
    images = new List<NetworkImage>();
    empRoleList=new List<Role>();
    controller = GifController(vsync: this);
    Role role  = Role(id: "0", role: "Select Department");
    Role role1  = Role(id: "0", role: "Select Employee");
    setState(() {
      roleDropdownValue=role;
      roleList.add(role);
      empRoleDropdownValue=role1;
      empRoleList.add(role1);
    });
    getRole(context);
    imageController = TextEditingController(text: "Image upload");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarOptions(),
      body: _loader?Center(child: CircularProgressIndicator(),):SingleChildScrollView(
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
                          Image.asset(Img.deptImage,width: 20.0,color: Colors.grey),
                          SizedBox(width: 10.0,),
                          Expanded(child: roleListDropDown()),
                        ],
                      ),
                      SizedBox(height: Constants().containerWidth(context)*0.01),
                      Row(
                        children: [
                          Image.asset(Img.empImage,width: 20.0,color: Colors.grey),
                          SizedBox(width: 10.0,),
                          Expanded(child: empNameListDropDown()),
                        ],
                      ),
                      SizedBox(height: Constants().containerWidth(context)*0.01),
                      Row(
                        children: [
                          Image.asset(Img.notesTitleImage,width: 20.0,color: Colors.grey,),
                          SizedBox(width: 10.0,),
                          Expanded(
                            child: Constants.commonEditTextFieldWithoutIcon( _taskController, false,
                                "Task Title", "", TextInputType.multiline),
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
                      ),
//                      Text("duration: "+_recording.duration.toString(),style: Constants().txtStyleFont16(Colors.black, 13.0),),
//                      Text("timer: 00:"+audioTimer.toString(),style: Constants().txtStyleFont16(Colors.black, 13.0),),
                      SizedBox(height: Constants().containerWidth(context)*0.03),
                      Row(mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(child: showImage(context, "My Tasks")),
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
              alignment: Alignment(0.0,-2.0),
              heightFactor: 0.1,
              child: Image.asset("Images/task/Add task banner.png",
                width: Constants().containerHeight(context)*0.22),
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
      leading: Constants().backButton(context),
      centerTitle: true,elevation: 0,
      title: Row(
        children: [SizedBox(width: 35.0),
          Image.asset(Img.myOfficeImage,width: 20.0,),
          SizedBox(width: 10.0),
          Text("Add Task",
            textAlign: TextAlign.center,
            style: Constants().txtStyleFont16(ColorsUsed.whiteColor,21.0),
          ),
        ],
      ),
    );
  }

  Widget showImage(BuildContext context, String name) {
    return images.length > 0
        ? Util.listOfImages(context: context,images: images,name: "Task",widgetCallBack: this)
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
        _imgURL = _image.path.split('/').last.substring(12);//.toString();
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

  //get Role details
  Future<dynamic> getRole(BuildContext context) async{

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
              roleList.add(role);
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
  Future<dynamic> getEmpListDb(String roleId) async {
    setState(() {
      _loader = true;
    });
    try{
      await http.get("${Constants.BaseUrl}action=getRoleByList&id=$roleId"
      ).then(( res) {
        print(res.body);
        var response = json.decode(res.body);
        final int statusCode = res.statusCode;
        print(statusCode);
        if (statusCode == 200) {
          print("its working 200");
          setState(() {
            _loader = false;
          });
          if(response["success"] == "1"){
            for(int j=0;j<response["role"].length;j++){
              if(response["role"][j]["Full_Name"].toString() == "null"){
                setState(() {
                  empRoleList.add(Role(
                      id: response["role"][j]["Id"],
                      role: "Tasla's Employee"));
                });
              }else{
                setState(() {
                  empRoleList.add(Role(
                      id: response["role"][j]["Id"],
                      role: response["role"][j]["Full_Name"]));
                });
              }
            }
          }
        }else{
          Constants.showToast(S.SOME_WRONG);

        }
      });}on SocketException catch (_) {
      print('not connected');
      Constants().noInternet(context);
    }catch (e) {
    }
  }

  

  //Role list
  Widget roleListDropDown(){
    return DropdownButton<Role>(
      isExpanded: true,
      value: roleDropdownValue,
      onChanged: (Role newValue) {
        setState(() {
          roleId = newValue.id;
          empRoleList.clear();
          Role role1  = Role(id: "0", role: "Select Employee");
          empRoleDropdownValue=role1;
          empRoleList.add(role1);
          roleDropdownValue = newValue;
          getEmpListDb(roleId);
        });
      },
      items:roleList
          .map<DropdownMenuItem<Role>>((Role value) {
        return DropdownMenuItem<Role>(
          value: value,
          child: Text(value.role),
        );
      }).toList(),
    );
  }

  //Role list
  Widget empNameListDropDown(){
    return DropdownButton<Role>(
      isExpanded: true,
      value: empRoleDropdownValue,
      onChanged: (Role newValue) {
        setState(() {
          empId = newValue.id;
          print("EmpID "+empId);
          empRoleDropdownValue = newValue;
        });
      },
      items:empRoleList
          .map<DropdownMenuItem<Role>>((Role value) {
        return DropdownMenuItem<Role>(
          value: value,
          child: Text(value.role),
        );
      }).toList(),
    );
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


  @override
  void callBackInterface(String title) {
    switch(title){
      case "Submit":
        print(audioArrayList);
        print("$imageArrayList");
        setState(() {
          now = DateTime.now();
          dateToday = formatter.format(now);
        });print(empRoleDropdownValue.role);
        validation();
        break;
      case "Camera":
        print("Camera");
        cameraMethod();
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
        break;
      case "Gallery":
       galleryMethod();
    }
  }

  Future<dynamic> addTask(BuildContext context) async{
    print("${Constants.BaseUrl}action=taskInsert&Task=${_taskController.text}&"
        "Assigned_To=${empId}&Current_Status=1&Sevirity=1&Attachment=1&"
        "Assigned_By = ${Constants.userId}&Assigned_Time=$dateToday&ETC=1&Remarks=1&"
        "Target_Time=1&Aging=1&Due=1&company=${S.companyId}&description=${_descController.text}&"
        "imageUpload=$imageArrayList&audioUpload=$audioArrayList");
    setState(() {
      _loader= true;
    });
    try{
      await http.get("${Constants.BaseUrl}action=taskInsert&Task=${_taskController.text}&"
          "Assigned_To=${empId}&Current_Status=1&Sevirity=1&Attachment=1&"
          "Assigned_By=${Constants.userId}&Assigned_Time=$dateToday&ETC=1&Remarks=1&"
          "Target_Time=1&Aging=1&Due=1&company=${S.companyId}&description=${_descController.text}&"
          "imageUpload=$imageArrayList&audioUpload=$audioArrayList"
      ).then(( res) {
        print(res.body);
        var response = json.decode(res.body);
        final int statusCode = res.statusCode;
        print(statusCode);
        if (statusCode == 200) {
          setState(() {
            _loader= false;
          });
          print("its working 200");
          if(response["success"] == 1){
            Constants.showToast(response["message"]);
            Navigator.pop(context,true);
          }
        }else{
          Scaffold.of(context).showSnackBar(Constants().showSnackMessage(response["Something went wrong !"]));
          setState(() {
            _loader= false;
          });
        }
      });}on SocketException catch (_) {
      print('not connected');
      Constants().noInternet(context);
    }catch (e) {
    }
  }

  validation() {
    if(_taskController.text.isNotEmpty){
      if(_descController.text.isNotEmpty) {
        if (empRoleDropdownValue.role != "Select Employee") {
          if (imageArrayList.isNotEmpty) {
            if (audioArrayList.isNotEmpty) {
              addTask(context);
            } else {
              Constants.showToast("Add atleast one audio");
            }
          } else {
            Constants.showToast("Add atleast one image");
          }
        } else {
          Constants.showToast("Select employee name from list");
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
      case "Task":
        setState(() {
          images.removeAt(i);
        });
    }
  }


}

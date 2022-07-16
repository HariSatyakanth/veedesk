import 'dart:convert';
import 'dart:io';
import 'dart:io' as io;
import 'dart:math';
import 'package:file/local.dart';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:http/http.dart'as http;
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
import 'package:newproject/pages/homeOptions/Leads/ClientListPOJO.dart';
import 'package:newproject/pages/version_2_files/MediaFileUploading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permissions_plugin/permissions_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeadsInsert extends StatefulWidget {
  final LocalFileSystem localFileSystem;

  LeadsInsert({localFileSystem})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();
  @override
  _LeadsInsertState createState() => _LeadsInsertState();
}

class _LeadsInsertState extends State<LeadsInsert> with SingleTickerProviderStateMixin  implements WidgetCallBack,ImageCallBack {
  String roleDropdownValue;
  String clientsID;
  Recording _recording = new Recording();
  bool _loader = true,_record=false;
  List<GetClietnsList> clientList = [];
  GifController controller;
  List<NetworkImage> images;
  static var  imageController;
  String currencySymbol;
  List<String> currencyList = ["\$","€","₹"];
  final TextEditingController _namesController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _audioPathController = TextEditingController();
  final TextEditingController _quotationController = TextEditingController(text: "Add Quotation link ");
  final TextEditingController _proposalController = TextEditingController(text: "Add your Proposal link");
  String _imgURL = "",_audioFileName="";
  List audioArrayList = [];
  List imageArrayList = [];
  File _image;
  FilePickerResult _paths;
  String _directoryPath;
  String _extension = ".pdf";
  String _fileName;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getClientList();
    images = new List<NetworkImage>();
    controller = GifController(vsync: this);
    imageController = TextEditingController(text: "Image Upload");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarOptions(),
      body: _loader?Center(child: Constants().spinKit,):SingleChildScrollView(
        child: Container(padding: EdgeInsets.fromLTRB(30.0, 25.0, 30.0, 20.0),
           child: Column(crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Row(
                 children: [
                   Image.asset(Img.projectNameImage,width: 20.0,color: Colors.grey,),
                   SizedBox(width: 10.0,),
                   Expanded(
                     child: Constants.commonEditTextFieldWithoutIcon(_namesController, false,
                         "Project Name", "", TextInputType.multiline),
                   ),
                 ],
               ),
               SizedBox(height: Constants().containerHeight(context)*0.01),
               Row(
                 children: [
                   Image.asset(Img.projectNameImage,width: 20.0,color: Colors.grey,),
                   SizedBox(width: 10.0,),
                   Expanded(child: clientListDropDown()),
                 ],
               ),
               Row(
                 children: [
                   Image.asset(Img.projectNameImage,width: 20.0,color: Colors.grey,),
                   SizedBox(width: 10.0,),
                   currencyDropDown(),
                   Expanded(
                     child: Constants.commonEditTextFieldWithoutIcon(_amountController, false,
                         "Estimated value", "", TextInputType.number),
                   ),
                 ],
               ),
               Row(
                 children: [
                   Image.asset(Img.projectNameImage,width: 20.0,color: Colors.grey,),
                   SizedBox(width: 10.0,),
                   Expanded(
                     child: Constants.commonEditTextFieldWithoutIcon(_timeController, false,
                         "Estimated time(in days)", "", TextInputType.number),
                   ),
                 ],
               ),SizedBox(height: 5.0,),
               Row(
                 children: [SizedBox(width: 30.0,),
                   Constants.selectedFontWidget("* Time is calculated in days", Colors.grey, 12, FontWeight.w500)
                 ],
               ),
               TextField(
                 /*onTap: (){
                   _openFileExplorer();
                 },*/
                 controller: _quotationController,
                 readOnly: false,
                 onChanged: (value){
                   print(value);
                 },
                 decoration: InputDecoration(
                   enabledBorder: UnderlineInputBorder(borderSide: BorderSide(
                       color:Colors.grey[300],width: 2.0),),
                   focusedBorder: UnderlineInputBorder(borderSide: BorderSide(
                       color:ColorsUsed.baseColor,width: 2.0),),
//              isCollapsed: true,
                 ),
               ),
               TextField(
                 controller: _proposalController,
                 readOnly: false,
                 onChanged: (value){
                   print(value);
                 },
                 decoration: InputDecoration(


//              isCollapsed: true,
                 ),
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
        ),
      ),
    );
  }

  Widget showImage(BuildContext context, String name) {
    return images.length>0
        ? Util.listOfImages(context: context,images: images,name: name,widgetCallBack: this)
        : new Container(
      height: 0.0,
    );
  }

  _appBarOptions() {
    return PreferredSize(
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(30.0),
          bottomLeft: Radius.circular(30.0),
        ),
        child: AppBar(
          backgroundColor: ColorsUsed.baseColor,
          leading: Constants().backButton(context),
          centerTitle: true,
          title: Row(
            children: [SizedBox(width: 35.0),
              Image.asset(Img.myOfficeImage,width: 20.0),
              SizedBox(width: 10.0,),
              Text("Add Leads",
                style: Constants().txtStyleFont16(ColorsUsed.whiteColor, 20.0),
              ),
            ],
          ),
        ),
      ),
      preferredSize:
      Size.fromHeight(Constants().containerHeight(context) * 0.08),
    );
  }

  Widget currencyDropDown(){
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        hint: Text("Currency"),
        isExpanded: false,
        value: currencySymbol,
        onChanged: (String newValue) {
          setState(() {
            currencySymbol = newValue;
          });
        },
        items:currencyList
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
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
    if (_loader) {
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
    if (_loader) {
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

  //Leave list
  Widget clientListDropDown(){
    return DropdownButton<String>(
      hint: Text("Select Client"),
      isExpanded: true,
      value: roleDropdownValue,
      onChanged: (String newValue) {
        setState(() {
          print(newValue);
          roleDropdownValue = newValue;
        });
      },
      items:clientList
          .map<DropdownMenuItem<String>>((GetClietnsList client) {
        return DropdownMenuItem<String>(

          value: client.id,
          child: Text(client.clientName),
        );
      }).toList(),
    );
  }


  Future<dynamic> getClientList() async{
    setState(() {
      _loader= true;
    });//&userId=5&claimId=3&title=sdhfs&amount=55&imageUrl=kk.jpg&audioUrl=pe.jpg&description=ghfjkh
    try{
      await http.get("${Constants.BaseUrl}action=getClietnsList"
      ).then(( res) {

        print(res.body);
        var response = json.decode(res.body);
        final int statusCode = res.statusCode;
        print(statusCode);
        if (statusCode == 200) {
          print("its working 200");
          setState(() {
            _loader= false;
          });
          if(response["success"] == "1"){
            print("in success");
            for(int i=0;i<response["getClietnsList"].length;i++){
              setState(() {
                clientList.add(GetClietnsList(
                    id: response["getClietnsList"][i]["Id"],
                    clientName: response["getClietnsList"][i]["Client_Name"]));
              });
              print(clientList[i].id);
            }

          }else{
            setState(() {
              _loader= false;
            });
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
        print("clientIDc$clientsID");
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
    }
  }

  void _openFileExplorer() async{
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        type: FileType.custom,/*_pickingType,*/
//        allowMultiple: _multiPick,
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '')?.split(',')
            : null,
      ));
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    catch (ex) {
      print(ex);
    }
    if(_paths!=null){
      print("hello${_paths.paths}");
      MediaFilesUpload().uploadFiles(_paths.paths.first, context).then((uploadedFileUrl){
        print("uploadedFileUrl$uploadedFileUrl");
      });
    }else{
      print("no");
    }
    if (!mounted) return;
    print("value1${_paths}");
    setState(() {
      _fileName = _paths != null ? _paths/*.map((e) => e.name)*/.toString() : '...';
    });
  }

  validation() async {
    print("ekmd${await Constants.workLogList()}");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_namesController.text.isNotEmpty) {
      if(roleDropdownValue != null){
      if(currencySymbol != null){
        if(_amountController.text.isNotEmpty){
        if(_timeController.text.isNotEmpty){
          if (_descController.text.isNotEmpty) {
             print("ok");
             addLeads(context);
            } else {
              Constants.showToast("Add description");
            }

        } else {
          Constants.showToast("Add estimated time");
        }
        } else {
          Constants.showToast("Add amount");
        }
      } else {
        Constants.showToast("Select currency");
      }
      } else {
        Constants.showToast("Select client");
      }
    }else{
      Constants.showToast("Add Project Name");
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

  Future<dynamic> addLeads(BuildContext context) async{
    setState(() {
      _loader= true;
    });//Project_Name , Client , Status , Estimate_Value , Estimate_Timeline , Proposal
// ,Quotation , Reamrks, company ,imageUpload , audioUpload
    print("${Constants.BaseUrl}action=leadInsert&userId=${Constants.userId}&Project_Name= ${_namesController.text}&"
        "Client=$roleDropdownValue&Status=1&imageUpload=${imageArrayList}&audioUpload=${audioArrayList}&Estimate_Timeline=${_timeController.text}&"
        "Estimate_Value= ${currencySymbol+_amountController.text}&Reamrks= ${_descController.text}&company=1&Proposal=${_proposalController.text}&"
        "Quotation=${_quotationController.text}");
    try{
      await http.get("${Constants.BaseUrl}action=leadInsert&userId=${Constants.userId}&Project_Name= ${_namesController.text}&"
          "Client=$roleDropdownValue&Status=1&imageUpload=${imageArrayList}&audioUpload=${audioArrayList}&Estimate_Timeline=${_timeController.text}&"
          "Estimate_Value= ${currencySymbol+_amountController.text}&Reamrks= ${_descController.text}&company=1&Proposal=${_proposalController.text}&"
          "Quotation=${_quotationController.text}"
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



}






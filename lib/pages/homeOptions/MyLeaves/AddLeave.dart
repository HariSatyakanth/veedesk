import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newproject/Interfaces/callBackWidget.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/Images_path.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/Utiles/strings.dart';
import 'package:newproject/common/ImagePreview.dart';
import 'package:newproject/pages/version_2_files/ImagePickerPath.dart';
import 'package:newproject/pages/version_2_files/MediaFileUploading.dart';

class AddLeave extends StatefulWidget {
  @override
  _AddLeaveState createState() => _AddLeaveState();
}

class _AddLeaveState extends State<AddLeave> implements WidgetCallBack{
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  DateTime selectedDate ;
  DateTime selectedEndDate ;
  String roleDropdownValue;
  String leaveStartDate = "Select Date",leaveEndDate = "Select Date";
  List<String> roleList = ["Medical Leave(ML)","Casual Leave(CL)",
    "Paid Leave(PL)","Unpaid Leave(UL)"];
  File _image;
  bool _loader = false;
  String uploadedImagePath;
  static var  imageController  = TextEditingController(text: "Related document(if any)");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarOptions(),
      body: _loader?Center(child: CircularProgressIndicator()):SingleChildScrollView(
        child: Container(padding: EdgeInsets.fromLTRB(30.0, 25.0, 30.0, 20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(Img.timeImage,width: 20.0,color: Colors.grey,),
                  SizedBox(width: 10.0,),
                  Expanded(child: leaveListDropDown()),
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    child: Text("Start Date : ",style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.w500,
                        color: Colors.grey[500]),),
                  ),
                  SizedBox(width: 20.0),
                  FlatButton(
                   onPressed: (){
                     DatePicker.showDatePicker(context,
                         showTitleActions: true,
                         minTime: DateTime.now(),
                         maxTime: DateTime(DateTime.now().year+1, 12, 31),
                         onChanged: (date) {
                           print('change ${date.day+date.month+date.year}');
                           setState(() {
                             leaveStartDate = ("${date.year}-${date.month}-${date.day}");
                           });
                         }, onConfirm: (date) {
                           print('confirm $date');
                           setState(() {
                             leaveStartDate = ("${date.year}-${date.month}-${date.day}");
                             selectedDate = date;
                           });
                         }, currentTime: null, locale: LocaleType.en);
                    setState(() {

                    });
                   },
                   child: Text(leaveStartDate))
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    child: Text("End Date : ",style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.w500,
                        color: Colors.grey[500]),),
                  ),
                  SizedBox(width: 20.0),
                  FlatButton(
                      onPressed: (){
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime: DateTime(selectedDate.year,selectedDate.month,selectedDate.day),
                            maxTime: DateTime(selectedDate.year+1, 12, 31),
                            onChanged: (date) {
                              print('change ${date.day+date.month+date.year}');
                              setState(() {
                                selectedEndDate = date;
                                leaveEndDate = ("${date.year}-${date.month}-${date.day}");
                              });
                            }, onConfirm: (date) {
                              print('confirm $date');
                              setState(() {
                                leaveEndDate = ("${date.year}-${date.month}-${date.day}");
                              });
                            }, currentTime: null, locale: LocaleType.en);
                        setState(() {

                        });
                      },
                      child: Text(leaveEndDate))
                ],
              ),
              SizedBox(height: 20.0),
              _ImagePicker(imageController, "Image upload", "message"),
              SizedBox(height: 10.0),
              uploadedImagePath == null?Container():Row(
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          ImagePreview(Constants.ImageBaseUrl+uploadedImagePath, "Inventory")));
                    },
                    child: Image.network(
                        Constants.ImageBaseUrl+uploadedImagePath,width: Constants().containerWidth(context)*0.2,),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Constants.descriptionField(context, "Reason For Leave", "", _reasonController, null, null),
              SizedBox(height: 50.0),
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
          title: Text(
            "Add Leaves",
            style: Constants().txtStyleFont16(ColorsUsed.whiteColor, 20.0),
          ),
        ),
      ),
      preferredSize:
      Size.fromHeight(Constants().containerHeight(context) * 0.08),
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
      _image = await ImagePicker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 1000,
          maxWidth: 1200,
          imageQuality: 70);
       MediaFilesUpload().uploadImage(_image,context).then((value) {
        print(value);
        setState(() {
//          _loader = false;
          Constants.loader(context).hide();
          if(uploadedImagePath==null){
          uploadedImagePath = value;
          }else{
            uploadedImagePath = null;
            uploadedImagePath = value;
          }
//          imageArrayList.add(value);
        });
      });
  }

  //camera method
  cameraMethod() async {

      _image = await ImagePicker.pickImage(
          source: ImageSource.camera,
          maxHeight: 1000,
          maxWidth: 1200,
          imageQuality: 70);
      MediaFilesUpload().uploadImage(_image,context).then((value) {
        print(value);
        setState(() {
          _loader = false;
          Constants.loader(context).hide();
          if(uploadedImagePath==null){
            uploadedImagePath = value;
          }else{
            uploadedImagePath = null;
            uploadedImagePath = value;
          }
//          imageArrayList.add(value);
        });
      });
//      }
    }

  //Leave list
  Widget leaveListDropDown(){
    return DropdownButton<String>(
      hint: Text("Select Leave Type"),
      isExpanded: true,
      value: roleDropdownValue,
      onChanged: (String newValue) {
        setState(() {
          roleDropdownValue = newValue;
        });
      },
      items:roleList
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  @override
  void callBackInterface(String title) {
    switch(title){
      case "Submit":
        print(roleDropdownValue);
        validation();
        break;
      case "Camera":
        cameraMethod();
        break;
      case "Gallery":
        galleryMethod();
        break;
    }
  }

  Future<dynamic> addLeave(BuildContext context) async{
    var diff = selectedEndDate.day-selectedDate.day+1;
    setState(() {
      _loader= true;
    });
    //1 is for pending status
    try{
      await http.get("${Constants.BaseUrl}action=userLeave&userId=${Constants.userId}&reason=${_reasonController.text}&"
          "startDate=$leaveStartDate&endDate=$leaveEndDate&day=$diff&status=1&leave_type=$roleDropdownValue"
          "attachmentImage=$uploadedImagePath"
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

  validation() async {
    if(roleDropdownValue != null){
      if(leaveStartDate != "Select Date"){
        if(leaveEndDate != "Select Date"){
          if(_reasonController.text.isNotEmpty){
            addLeave(context);
          }else{
            Constants.showToast("Please add proper reason of leave");

          }
        }else{
          Constants.showToast("Selet leave end date");

        }
      }else{
        Constants.showToast("Select initial date ");

      }
    }else{
      Constants.showToast("Select leave type");

    }

  }

}

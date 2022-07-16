import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:newproject/Interfaces/callBackWidget.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/Images_path.dart';
import 'package:newproject/Utiles/strings.dart';
import 'package:newproject/common/FilePageAPi.dart';
import 'package:newproject/common/ImagePreview.dart';
import 'package:newproject/pages/version_2_files/ImagePickerPath.dart';
import 'package:newproject/pages/version_2_files/MediaFileUploading.dart';
import '../../../Utiles/constants.dart';

class CreateMeeting extends StatefulWidget {
  @override
  _CreateMeetingState createState() => _CreateMeetingState();
}

class _CreateMeetingState extends State<CreateMeeting>implements WidgetCallBack {
  bool allDay = false;
  static String startDate;
  DateTime startDateFormat;
  DateFormat formatter = DateFormat('MMMM, yyyy');
  static String endDate;
  var eventNameController = TextEditingController();
  String workLogStartTime,workLogEndTime;
  List<String> timeList = ["9:00 am","10:00 am",
    "11:00 am","12:00 pm","1:00 pm","2:00 pm","3:00 pm","4:00 pm",
    "5:00 pm","6:00 pm","7:00 pm"];
  File _image;
  bool _loader = false;
  String uploadedImagePath;
  final TextEditingController _descriptionController = TextEditingController();
  static var  imageController  = TextEditingController(text: "Related document(if any)");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startDate = "Select Date";
    endDate = "Select Date";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25.0),
            bottomRight: Radius.circular(25.0),
          ),
          child: AppBar(centerTitle: true,elevation: 0.0,backgroundColor: ColorsUsed.baseColor,
            title:  Text("Create Meeting",
              textAlign: TextAlign.center,
              style: Constants().txtStyleFont16(ColorsUsed.whiteColor,21.0),
            ),),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.0),
            Row(
              children: [SizedBox(width: 20.0),
                Constants.selectedFontWidget(formatter.format(DateTime.now()), ColorsUsed.textBlueColor,
                    15.0, FontWeight.bold)
              ],
            ),
            Container(margin: EdgeInsets.fromLTRB(0,22.0,0,20),
              padding: EdgeInsets.fromLTRB(20,0.0,20,30.0),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(25.0),
                  color: ColorsUsed.whiteColor),
              child: Column(
                children: [
                  TextField(
                    controller: eventNameController,
                    maxLength: 8,
                    decoration: InputDecoration(
                        errorBorder: InputBorder.none,
                        border: InputBorder.none,
                        hintText: "Meeting Name",
                        hintStyle: Constants().txtStyleFont16(Colors.grey[500], 16.0)
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Constants.selectedFontWidget("Starts", ColorsUsed.textBlueColor,
                            15.0, FontWeight.bold),
                      ),
                      FlatButton(
                          onPressed: () {
//                            DatePicker.showDatePicker(context,
//                                showTitleActions: true,
//                                minTime: DateTime.now(),
//                                maxTime: DateTime(DateTime.now().year, DateTime.now().month+2, 31),
//                                onChanged: (date) {
//                                  print('change ${date.hour}');
//                                }, onConfirm: (Date1) {
//                                  print('confirm $Date1');
//                                  setState(() {
//                                    startDateFormat = Date1;
//                                    startDate = "${Date1.year}-${Date1.month}-${Date1.day}";
//                                  });
//                                }, currentTime: DateTime.now(), locale: LocaleType.en);
                            DatePicker.showDateTimePicker(context,
                                showTitleActions: true,
                                minTime: DateTime.now(),
                                maxTime: DateTime(DateTime.now().year, DateTime.now().month+2, 31),
                                onChanged: (date) {
                                  print('change ${date.hour}');
                                }, onConfirm: (Date1) {
                                  print('confirm $Date1');
                                  setState(() {
                                    startDateFormat = Date1;
                                    startDate = Date1.toString();//"${Date1.year}-${Date1.month}-${Date1.day}";
                                  });
                                }, currentTime: DateTime.now(), locale: LocaleType.en);

                          },
                          child: Text(startDate,
                            style: TextStyle(color: Colors.blue),
                          ))
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Constants.selectedFontWidget("Ends", ColorsUsed.textBlueColor,
                            15.0, FontWeight.bold),
                      ),
                      FlatButton(
                          onPressed: () {
//                            DatePicker.showDatePicker(context,
//                                showTitleActions: true,
//                                minTime: startDateFormat,
//                                maxTime: DateTime(startDateFormat.year, startDateFormat.month+2, 31),
//                                onChanged: (date) {
//                                  print('change ${date.hour}');
//                                }, onConfirm: (date2) {
//                                  print('confirm $date2');
//                                  setState(() {
//                                    endDate = "${date2.year}-${date2.month}-${date2.day}";
//                                  });
//                                }, currentTime: DateTime.now(), locale: LocaleType.en);
                            DatePicker.showDateTimePicker(context,
                                showTitleActions: true,
                                minTime: startDateFormat,
                                maxTime: DateTime(startDateFormat.year, startDateFormat.month+2, 31),
                                onChanged: (date) {
                                  print('change ${date.hour}');
                                }, onConfirm: (date2) {
                                  print('confirm $date2');
                                  setState(() {
                                    endDate = date2.toString();
                                  });
                                }, currentTime: DateTime.now(), locale: LocaleType.en);

                          },
                          child: Text(endDate,
                            style: TextStyle(color: Colors.blue),
                          ))
                    ],
                  ),
                  uploadedImagePath == null?_ImagePicker(imageController, "Image upload", "message"):Row(
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                              ImagePreview(Constants.ImageBaseUrl+uploadedImagePath, "Inventory")));
                        },
                        child: Image.network(
                          Constants.ImageBaseUrl+uploadedImagePath,width: Constants().containerWidth(context)*0.2,),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: (){
                          Constants.popUpFortwoOptions(context, S.deleteImage, "Are you sure?", this);
                        },icon: Icon(Icons.delete_forever,color: Colors.red),
                      )
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Constants.descriptionField(context, "Add description", "", _descriptionController, null, null),

                  SizedBox(height: 30.0),
                  Row(
                    children: [SizedBox(width: 30.0),
                      Expanded(child: Constants().buttonRaised(context, ColorsUsed.baseColor, "Save", this)),
                      SizedBox(width: 30.0)],
                  )
                ],
              ),
            ),
          ],
        ),
      )
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
        uploadedImagePath = value;
//          imageArrayList.add(value);
      });
    });
//      }
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


  addMeeting() async {
    var loader = Constants.loader(context);
    await loader.show();
    try{
      var response = await FilePageApi().getRequest("triosolveMeetingsAdd&userId=${Constants.userId}&"
          "meeting_name=MyOffice-${eventNameController.text}&start_date=$startDate&start_time=$workLogStartTime"
          "&end_date=$endDate&end_time=$workLogEndTime&meeting_des=${_descriptionController.text}&baner_img=$uploadedImagePath", context);
      var responseList = await json.decode(response.body);
      print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.body);
        loader.hide();
        Navigator.pop(context,true);
      }
      else{
        loader.hide();
        Constants.showToast(responseList["error"]);
      }
    }on SocketException catch(e){
      loader.hide();
      Constants().noInternet(context);
    }
  }

  @override
  void callBackInterface(String title) {
    switch(title){
      case "Save":
        if(eventNameController.text.isNotEmpty){
          if(eventNameController.text.length<9){
          if(startDate!="Select Date"){
            if(endDate!="Select Date"){
                  if(_descriptionController.text.isNotEmpty){
                    addMeeting();
                print("done");
                  }else{
                    Constants.showToast("Please add proper description");
                  }

            }else{
              Constants.showToast("Select End Date");
            }
          }else{
            Constants.showToast("Select Start Date");
          }
          }else{
            Constants.showToast("Meeting name not exceed 8 words");
          }
        }else{
          Constants.showToast("Enter Meeting Name");
        }
        break;
      case "Camera":
        cameraMethod();
        break;
      case "Gallery":
        galleryMethod();
        break;
      case S.deleteImage:
        setState((){
          uploadedImagePath = null;
        });
        break;
    }
  }
}

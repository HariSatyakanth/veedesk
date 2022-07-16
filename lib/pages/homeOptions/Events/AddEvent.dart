import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:newproject/Interfaces/callBackWidget.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/common/FilePageAPi.dart';
import '../../../Utiles/constants.dart';

class AddEvent extends StatefulWidget {
  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> implements WidgetCallBack{
  bool allDay = false;
  static String startDate;
  DateTime startDateFormat;
  DateFormat formatter = DateFormat('MMMM, yyyy');
  static String endDate;
  var eventNameController = TextEditingController();

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
            title:  Text("Add Events",
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
                    decoration: InputDecoration(
                      errorBorder: InputBorder.none,
                      border: InputBorder.none,
                      hintText: "Enter event",
                      hintStyle: Constants().txtStyleFont16(Colors.grey[500], 16.0)
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Constants.selectedFontWidget("All day", ColorsUsed.textBlueColor,
                            15.0, FontWeight.bold),
                      ),
                      Switch(
                          value: allDay,
                          onChanged: (value){
                            setState(() {
                              allDay = value;
                            });
                          })

                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Constants.selectedFontWidget("Starts", ColorsUsed.textBlueColor,
                            15.0, FontWeight.bold),
                      ),
                      FlatButton(
                          onPressed: () {
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime.now(),
                                maxTime: DateTime(DateTime.now().year, DateTime.now().month+2, 31),
                                onChanged: (date) {
                                  print('change ${date.hour}');
                                }, onConfirm: (Date1) {
                                  print('confirm $Date1');
                                  setState(() {
                                    startDateFormat = Date1;
                                    startDate = "${Date1.year}-${Date1.month}-${Date1.day}";
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
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: startDateFormat,
                                maxTime: DateTime(startDateFormat.year, startDateFormat.month+2, 31),
                                onChanged: (date) {
                                  print('change ${date.hour}');
                                }, onConfirm: (date2) {
                                  print('confirm $date2');
                                  setState(() {
                                    endDate = "${date2.year}-${date2.month}-${date2.day}";
                                  });
                                }, currentTime: DateTime.now(), locale: LocaleType.en);

                          },
                          child: Text(endDate,
                            style: TextStyle(color: Colors.blue),
                          ))
                    ],
                  ),
//              Row(
//                children: [
//                  Expanded(
//                    child: Constants.selectedFontWidget("Repeat", ColorsUsed.textBlueColor,
//                        15.0, FontWeight.bold),
//                  ),
//
//                ],
//              ),
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
      ),
    );
  }

  addEvents() async {
    var loader = Constants.loader(context);
    await loader.show();
    try{
      var response = await FilePageApi().getRequest("eventInsert&userId=${Constants.userId}&"
          "title=${eventNameController.text}&startDate=$startDate&endDate=$endDate", context);
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
          if(startDate!="Select Date"){
            if(endDate!="Select Date"){
              addEvents();

            }else{
              Constants.showToast("Select End Date");
            }
          }else{
            Constants.showToast("Select Start Date");
          }
        }else{
          Constants.showToast("Enter Event Name");
        }
        break;
    }
  }

}



import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/common/FilePageAPi.dart';

class GraphPageApis{

  // lead Graphs
  leadsGraph({String userID,String month,BuildContext context})async{
    var loader = Constants.loader(context);
    await loader.show();
    try{
      var response = await FilePageApi().getRequest("leadsTotalCount&userId=$userID&month=$month",context);
      var responseList = await json.decode(response.body);
      print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.body);
        loader.hide();

      }
      else{

        Constants.showToast(responseList["error"]);
      }
    }on SocketException catch(e){
      Constants().noInternet(context);
    }
  }

  // lead Graphs
  tasksGraph({String userID,String month,BuildContext context})async{
    var loader = Constants.loader(context);
    await loader.show();
    try{
      var response = await FilePageApi().getRequest("taskTotalCount&userId=$userID&month=$month",context);
      var responseList = await json.decode(response.body);
      print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.body);
        loader.hide();
        Constants.showToast(responseList["message"]);
      }
      else{

        Constants.showToast(responseList["error"]);
      }
    }on SocketException catch(e){
      Constants().noInternet(context);
    }
  }

  // attendance Graphs
  attendanceGraph({String userID,String month,BuildContext context})async{
    var loader = Constants.loader(context);
    await loader.show();
    try{
      var response = await FilePageApi().getRequest("attendanceTotalCount&userId=$userID&month=$month",context);
      var responseList = await json.decode(response.body);
      print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.body);
        loader.hide();
        Constants.showToast(responseList["message"]);
      }
      else{
//        Constants.showToast(responseList["error"]);
      }
    }on SocketException catch(e){
      Constants().noInternet(context);
    }
  }





  // Apis for KPICharts

// worklog Graphs
  workLogGraph({String userID,String date,BuildContext context})async{
    var loader = Constants.loader(context);
    await loader.show();
    try{//&userId=8&currentDate=2021-01-29
      var response = await FilePageApi().getRequest("getSumWorklogsDate&userId=$userID&currentDate=$date",context);
      var responseList = await json.decode(response.body);
      print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.body);
        loader.hide();

      }
      else{

        Constants.showToast(responseList["error"]);
      }
    }on SocketException catch(e){
      Constants().noInternet(context);
    }
  }

}
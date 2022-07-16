import 'dart:convert';
import 'dart:io';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';

class MediaFilesUpload {

  //upload image
     uploadImage(File file, BuildContext context) async{
       await Constants.loader(context).show();
      var response;
      FormData formData = FormData();
      formData.files.addAll([
        MapEntry("photo", await MultipartFile.fromFile(file.path)),
      ]);
      try {
        await Dio().post("${Constants.BaseUrl}action=imageUpload", data: formData
        ).then((res) {
          print(res.data);
         response = json.decode(res.data);
          final int statusCode = res.statusCode;
          print(statusCode);
          if (statusCode == 200) {
            print("its working 200"); Constants.loader(context).hide();
            if (response["success"] == 1) {
              print(response.toString());
         } else {

            }
          } else {
          }
        });
      } on SocketException catch (_) {
        print('not connected');
        Constants().noInternet(context);
      } catch (e) {}
      return response["img_url"];
    }

    //uploadFile
     uploadFiles(String file, BuildContext context) async{
       await Constants.loader(context).show();
       var response;
       FormData formData = FormData();
       formData.files.addAll([
         MapEntry("photo", await MultipartFile.fromFile(file)),
       ]);
       try {
         await Dio().post("${Constants.BaseUrl}action=imageUpload", data: formData
         ).then((res) {
           print(res.data);
           response = json.decode(res.data);
           final int statusCode = res.statusCode;
           print(statusCode);
           if (statusCode == 200) {
             print("its working 200"); Constants.loader(context).hide();
             if (response["success"] == 1) {
               print(response.toString());
             } else {

             }
           } else {
           }
         });
       } on SocketException catch (_) {
         print('not connected');
         Constants().noInternet(context);
       } catch (e) {}
       return response["img_url"];
     }

    //upload audio
     uploadAudio(Recording file, BuildContext context) async {
       var response;
       FormData formData = FormData();
      formData.files.addAll([
        MapEntry("audio", await MultipartFile.fromFile(file.path)),
      ]);
      try {
        await Dio().post("${Constants.BaseUrl}action=audioUpload", data: formData
        ).then((res) {
          print(res.data);
          response = json.decode(res.data);
          final int statusCode = res.statusCode;
          print(statusCode);
          if (statusCode == 200) {
            print("its working 200");
            if (response["success"] == 1) {
              print( response["audio_url"]);

            }
          } else {
          }
        });
      } on SocketException catch (_) {
        print('not connected');
        Constants().noInternet(context);
      } catch (e) {}
      return response["audio_url"];
    }


     // POST METHOD FOR API WITHOUT TOKEN
     postRequest(String url,BuildContext context, Map map) async{
       print( Constants.BaseUrl + url);
       return await http.post(
         Constants.BaseUrl + url,
         /*headers: <String, String>{
           'Accept':	'application/json',
           'Content-Type': 'application/json',
         },*/
         body: map,
       );
     }

     //workLog Api
      addWorkLog(Map map, BuildContext context) async {
       SharedPreferences prefs = await SharedPreferences.getInstance();
       try{
         var response = await postRequest("action=workLogs&", context, map);
         print(response.body);
         var responseList = jsonDecode(response.body);
         print(response.statusCode);
         if (response.statusCode == 200 ||response.statusCode == 201) {
           if(responseList["success"]==1){
             prefs.remove("WorkLogList${Constants.userId}");
             Constants.showToast("Log out successfully");
             return true;
           }
         }else{
         }
       }on SocketException catch(e){

       }

     }

/*     static showAudioVisualizers(){
       return Visualizer(
         builder: (BuildContext context, List<int> wave) {
           return new CustomPaint(
             painter: new LineVisualizer(
               waveData: wave,
               height: MediaQuery.of(context).size.height,
               width : MediaQuery.of(context).size.width,
               color: Colors.blueAccent,
             ),
             child: new Container(),
           );
         },
         id: 13,
       );
     }*/

}
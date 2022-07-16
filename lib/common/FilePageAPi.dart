import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:http/http.dart'as http;
import 'package:newproject/models/FolderListPojo.dart';
import 'package:newproject/models/GetFileListPOjo.dart';

class FilePageApi{
   static String BaseUrl =  "https://tasla.app/MyOffice/index.php?action=";
  //get requests
  getRequest(String url,BuildContext context) async{
    print(BaseUrl+url);
    return await http.get(BaseUrl + url,
    );
  }

  //Insert Folder
  createNewFolder(String userID,String folderName, BuildContext context) async {
    var loader = Constants.loader(context);
    await loader.show();
    try{
      var response = await getRequest("foldersInsert&userId=$userID&folderName=$folderName&isVisible=1&timestamp=8", context);
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

  //get folders
  getFolderList(String userID,BuildContext context) async {
    try{
      var response = await getRequest("folderList&userId=$userID", context);
      var responseList = await json.decode(response.body);
      print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.body);
        if(responseList["success"] == "1") {
          return FolderListPojo.fromJson(json.decode(response.body));
        }else{
          return null;
        }
      }
      else{
        Constants.showToast(responseList["error"]);
      }
    }on SocketException catch(e){
      Constants().noInternet(context);
    }
  }

   //rename existing folder
   renameFolder(String folderID,String folderName,BuildContext context) async {
     var loader = Constants.loader(context);
     await loader.show();
     try{
       var response = await getRequest("folderUpdate&id=$folderID&folderName=$folderName&isVisible=1&timestamp=8", context);
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

   //get folders
   deleteFolder(String folderID,BuildContext context) async {
     var loader = Constants.loader(context);
     await loader.show();
     try{
       var response = await getRequest("folderDelete&&id=$folderID", context);
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

   //get file
   deleteFile(String fileID,BuildContext context) async {
     var loader = Constants.loader(context);
     await loader.show();
     try{
       var response = await getRequest("fileDelete&id=$fileID", context);
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

   //add file to
   addFile({String folderID,String userID,String fileName,
     int fileType,String fileUrl ,BuildContext context}) async {
     var loader = Constants.loader(context);
     await loader.show();
     try{
       var response = await getRequest("fileInsert&userId=$userID&folderId=$folderID&fileName=$fileName&"
           "timestamp=2020-12-16%2001:26&url=$fileUrl&type=$fileType",context);
       var responseList = await json.decode(response.body);
       print(response.statusCode);
       if (response.statusCode == 200 || response.statusCode == 201) {
         print(response.body);
         loader.hide();
         Constants.showToast(responseList["message"]);
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

   //add file to
   getFileList({String folderID,BuildContext context}) async {
     var loader = Constants.loader(context);
     await loader.show();
     try{
       var response = await getRequest("fileList&folderId=$folderID",context);
       var responseList = await json.decode(response.body);
       print(response.statusCode);
       if (response.statusCode == 200 || response.statusCode == 201) {
         print(response.body);
         loader.hide();
         if(responseList["success"]=="1") {
           return GetFileListPOJO.fromJson(json.decode(response.body));
         }else{
           return null;
         }
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

}
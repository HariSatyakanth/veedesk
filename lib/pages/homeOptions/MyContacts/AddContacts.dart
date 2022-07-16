import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart'as http;
import 'dart:io' as io;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newproject/Interfaces/callBackWidget.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/Images_path.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/Utiles/strings.dart';
import 'package:newproject/pages/version_2_files/ImagePickerPath.dart';
import 'package:newproject/pages/version_2_files/MediaFileUploading.dart';

class AddContacts extends StatefulWidget {
  @override
  _AddContactsState createState() => _AddContactsState();
}

class _AddContactsState extends State<AddContacts> implements WidgetCallBack{
  TextEditingController _nameCtrl = TextEditingController();
  TextEditingController _contactNumCtrl = TextEditingController();
  TextEditingController _descriptionCtrl = TextEditingController();
  TextEditingController _emailCtrl = TextEditingController();
  bool _isLoading=false;
  bool checkBoxValue=false;
  File _image;
  String uploadedImagePath;
  static var  imageController  = TextEditingController(text: "Related document(if any)");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,elevation: 0.0,backgroundColor: ColorsUsed.baseColor,
       title:  Row(
        children: [SizedBox(width: 35.0),
          Image.asset(Img.myOfficeImage,width: 20.0,),
          SizedBox(width: 10.0),
          Text("Add Contact",
            textAlign: TextAlign.center,
            style: Constants().txtStyleFont16(ColorsUsed.whiteColor,21.0),
          ),
        ],
      ),),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(padding: EdgeInsets.only(bottom: 40.0),
              child: Column(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(35.0),
                      bottomRight: Radius.circular(35.0),
                    ),
                    child: Container(
                      height: Constants().containerHeight(context)/5.5,
                      width: Constants().containerWidth(context),
                      color: ColorsUsed.baseColor,

                    ),
                  ),
                  Container(padding: EdgeInsets.fromLTRB(20.0, Constants().containerHeight(context)/7, 20.0, 20.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: [
                            Icon(Icons.person,color: Colors.grey,),
                            SizedBox(width: 20.0),
                            Expanded(child: _enterEmail("Name",false,_nameCtrl,"Enter Name")),
                          ],
                        ),
//                        SizedBox(height: 20.0),
                        Row(
                          children: [
                            Icon(Icons.phone_android,color: Colors.grey,),
                            SizedBox(width: 20.0),
                            Expanded(child: _enterEmail("Mobile",false,_contactNumCtrl,"Enter Contact")),
                          ],
                        ),
//                        SizedBox(height: 20.0),
                        Row(
                          children: [
                            Icon(Icons.email_outlined,color: Colors.grey,),
                            SizedBox(width: 20.0),
                            Expanded(child: _enterEmail("Email",false,_emailCtrl,"Enter Email")),
                          ],
                        ),
                        _ImagePicker(imageController, "Image upload", "message"),
                        SizedBox(height: 10.0),
                        uploadedImagePath == null?Container():Row(
                          children: [
                            Image.network(
                              Constants.ImageBaseUrl+uploadedImagePath,width: Constants().containerWidth(context)*0.2,),
                          ],
                        ),
                        SizedBox(height: 20.0),
//                        SizedBox(height: 20.0),
                        whatsAppCheck(),
//                        SizedBox(height: 20.0),
                        _descriptionBox(),
                        SizedBox(height: 20.0),
                        _showCircularSubmit(),
                      ],
                    ),)
                ],
              ),
            ),
            Align(
              alignment: Alignment(0.8,-1.8),
              heightFactor: 0.1,
              child: Image.asset("Images/forgotPassword/forgot.png",width: Constants().containerHeight(context)/4.8,),
            )
          ],
        ),
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
        _isLoading = false;
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

 Widget  _enterEmail(String _prefixText,bool _readValue,TextEditingController _controller,String hitText) {
    return Container(padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
      child: TextField(
        controller: _controller,
        readOnly: _readValue,
        onChanged: (value){

        },
        decoration: InputDecoration(
          labelText: _prefixText,
          hintText: hitText,
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color:Colors.grey[300],width: 2.0),),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color:ColorsUsed.baseColor,width: 2.0),),
//          prefixText: "$_prefixText  "
        ),
      ),
    );
  }
  _descriptionBox(){
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: TextField(
        controller: _descriptionCtrl,
        maxLines: 6,
        onChanged: (value){

        },
        decoration: InputDecoration(
          hintText: "Add Description",
          contentPadding: EdgeInsets.fromLTRB(8.0,15.0,5.0,10.0),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none,),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none,),
//          prefixText: "$_prefixText  "
        ),
      ),
    );
  }
  Widget _showCircularSubmit() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Row(
      children: <Widget>[
        Expanded(child: Constants().buttonRaised(context,
            ColorsUsed.baseColor, S.SAVE,this))
      ],
    );
  }
  Widget whatsAppCheck(){
    return Container(
      child: Row(mainAxisAlignment: MainAxisAlignment.end,
        children: [
          new Checkbox(value: checkBoxValue,
              activeColor: Colors.green,
              onChanged:(bool newValue){
                setState(() {
                  checkBoxValue = newValue;
                });
              }),
       Text(
        "Is Contact on WhatsApp?",
        style: TextStyle(
          color: checkBoxValue?Colors.green:Colors.grey,
        ),
      )
        ],
      ),
    );
  }

  @override
  void callBackInterface(String title) {
   switch(title){
     case S.SAVE:
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

  Future<dynamic> addNotes(BuildContext context) async{
    setState(() {
      _isLoading= true;
    });
    print("${Constants.BaseUrl}action=addContact&userId= ${Constants.userId}&"
        "userName=${_nameCtrl.text}&contactNumber=${_contactNumCtrl.text}&"
        "imageUrl=${uploadedImagePath}&isWhatsApp= ${checkBoxValue.toString()}&email=${_emailCtrl.text}&description= ${_descriptionCtrl.text}");
    try{
      await http.get("${Constants.BaseUrl}action=addContact&userId= ${Constants.userId}&"
          "userName=${_nameCtrl.text}&contactNumber=${_contactNumCtrl.text}&"
          "imageUrl=${uploadedImagePath}&isWhatsApp= ${checkBoxValue.toString()}&email=${_emailCtrl.text}&description= ${_descriptionCtrl.text}"
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
              _isLoading= false;
            });
            Constants.showToast(response["message"]);
            Navigator.pop(context,true);
          }else{
            setState(() {
              _isLoading= false;
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
    if(_nameCtrl.text.isNotEmpty){
      if(_contactNumCtrl.text.isNotEmpty){
        if(_emailCtrl.text.isNotEmpty){
          if(_descriptionCtrl.text.isNotEmpty){
            addNotes(context);
          }else{
            Constants.showToast("Please add proper description of query(Minimum 10 Words)");

          }
        }else{
          Constants.showToast("Please add email");

        }
      }else{
        Constants.showToast("Please add phone number");

      }
    }else{
      Constants.showToast("Please enter name");

    }

  }

}

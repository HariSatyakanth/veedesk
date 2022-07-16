import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newproject/Interfaces/callBackWidget.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/Images_path.dart';
import 'package:newproject/Utiles/LoadImage.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/Utiles/strings.dart';
import 'package:newproject/Utiles/widgets.dart';
import 'package:newproject/pages/homePage.dart';
import 'package:newproject/pages/version_2_files/MediaFileUploading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  final id;
  Profile(this.id);
  @override
  _ProfileState createState() => _ProfileState(id);
}

class _ProfileState extends State<Profile> implements WidgetCallBack{
  int id;
  _ProfileState(this.id);
  static String email = "", fullName = "",userName = "",contact = "",whatsApp = "",
  password = "",address = "", status = "",employeeCode = "",profilePhoto;
  TextEditingController _userNameController;
  TextEditingController _fullNameController ;
  TextEditingController _emailController ;
  TextEditingController _contactController;
  TextEditingController _whatsAppController;
  TextEditingController _employeeController ;
  TextEditingController _addressController;
  TextEditingController _statusController;

  final FocusNode _userNameFocus = FocusNode();
  final FocusNode _fullNameFocus = FocusNode();
  final FocusNode _contactFocus = FocusNode();
  final FocusNode _whatsAppFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _showPassword = true,_readOnly = true,_loading = true;
  File profileImage;

  @override
  void initState(){
    super.initState();
    getProfile(context);
    _getGoogleProfile();
  }

  _getGoogleProfile() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    /*Constants.userName = prefs.getString("name");
    Constants.imageUrl = prefs.getString("Image");*/
    Constants.userId = prefs.getString("USERID");

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: ColorsUsed.backGroundColor,
      drawer: Widgets().appDrawer(context, Constants.userName, Constants.imageUrl),
      appBar: _appBarOptions(),
      body: _loading ? Center(child: CircularProgressIndicator(),):SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(35.0, 25.0, 35.0, 30.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                  child: Container(
                    child: Column(
                      children: [
                        _profilePhoto(),
                        SizedBox(height: 35.0),
                        _enterUserName(),
                      _enterFullName(),
                      _enterEmail(),
                        _enterContact(),
                        _enterWhatsApp(),
                        _enterAddress(),
                        _enterEmpCode(),
                        _enterStatus()
                      ],
                    ),
                  )),
              SizedBox(height: 50.0),
              _readOnly?Container():Row(
                children: [
                  Expanded(
                    child: Constants().buttonRaised(context, ColorsUsed.baseColor,
                        S.submit, this),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _profilePhoto() {
    return Stack(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(radius: 50.0,backgroundColor: Colors.grey,
             backgroundImage: profilePhoto == "null"?NetworkImage(Constants.USER_IMAGE):NetworkImage(profilePhoto)),
          ],
        ),
        _readOnly?Container():Align(alignment: Alignment(0.04, 0.0),
         heightFactor: 6.7,
         child: InkWell(
           onTap: (){
             print('hello');
             LoadImage().showPicker(context,this);
           },
           child: Container(
             decoration: BoxDecoration(color: ColorsUsed.baseColor,
             borderRadius: BorderRadius.circular(30.0)),
             width: 100.0,
            height: 30.0,
            child: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.photo_camera,color: Colors.white,size: 13.0),
                SizedBox(width: 5.0),
                Text("Change",style: Constants().txtStyleFont16(ColorsUsed.whiteColor, 11.0),),
              ],
            ),
        ),
         ),)
      ],
    );
  }

  //App Bar
  _appBarOptions() {
    return PreferredSize(
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(40.0),
          bottomLeft: Radius.circular(40.0),
        ),
        child: AppBar(backgroundColor: ColorsUsed.baseColor,
          leading: id==0?Constants().backButton(context):Builder(builder: (context)=>IconButton(
              icon: Image.asset("Images/home/menu.png",color: ColorsUsed.whiteColor,width: 30.0,),
              onPressed: (){
                Scaffold.of(context).openDrawer();
              })),
          centerTitle: true,
          title: Text("My Profile",
            style: Constants().txtStyleFont16(ColorsUsed.whiteColor,20.0),),
          actions: [
            IconButton(
                icon: Icon(Icons.edit,color: ColorsUsed.whiteColor,),
                onPressed: (){
                  setState(() {
                    _readOnly = false;
                  });
                }),SizedBox(width: 15.0,)
          ],
        ),
      ),
      preferredSize: Size.fromHeight(Constants().containerHeight(context)*0.1),
    );
  }

  _enterUserName() {
    return Container(padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            textInputAction: TextInputAction.next,
            controller: _userNameController,
            readOnly: _readOnly,
            focusNode: _userNameFocus,
            onChanged: (value){
              userName = _userNameController.text;
            },
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(
                  color:Colors.grey[300],width: 2.0),),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(
                  color:ColorsUsed.baseColor,width: 2.0),),
              prefixIcon: IconButton(icon: Image.asset(Img.profileUser),onPressed: (){},),
            ),
            onFieldSubmitted: (term){
              Constants.fieldFocusChange(context, _userNameFocus,_fullNameFocus);
            },
          ),
        ],
      ),
    );
  }

  _enterFullName() {
    return Container(padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            textInputAction: TextInputAction.next,
            controller: _fullNameController,
            readOnly: _readOnly,
            focusNode: _fullNameFocus,
            onChanged: (value){

            },
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(
                  color:Colors.grey[300],width: 2.0),),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(
                  color:ColorsUsed.baseColor,width: 2.0),),
              prefixIcon: IconButton(icon: Image.asset(Img.profileUser),onPressed: (){},),
            ),
            onFieldSubmitted: (term){
              Constants.fieldFocusChange(context, _fullNameFocus,_contactFocus);
            },
          ),
        ],
      ),
    );
  }

  _enterEmail() {
    return Container(padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _emailController,
            readOnly: true,
            onChanged: (value){
              setState(() {
                email = _emailController.text;
              });
            },
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(
                  color:Colors.grey[300],width: 2.0),),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(
                  color:ColorsUsed.baseColor,width: 2.0),),
              prefixIcon: IconButton(icon: Image.asset(Img.profileMail),onPressed: (){},),
            ),
          ),
        ],
      ),
    );
  }

  _enterEmpCode() {
    return Container(padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _employeeController,
            readOnly: true,
            onChanged: (value){
              employeeCode = _employeeController.text;
            },
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color:Colors.grey[300],width: 2.0),),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: ColorsUsed.baseColor,width: 2.0),),
                prefixIcon: IconButton(icon: Image.asset(Img.profileEmployeeCode),onPressed: (){},),
            ),
          )
        ],
      ),
    );
  }

  _enterContact() {
    return Container(padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            textInputAction: TextInputAction.next,
            controller: _contactController,
            readOnly: _readOnly,
            focusNode: _contactFocus,
            onChanged: (value){
              contact = _contactController.text;
            },
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(
                  color:Colors.grey[300],width: 2.0),),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(
                  color:ColorsUsed.baseColor,width: 2.0),),
              prefixIcon: IconButton(icon: Image.asset(Img.profilePhone),onPressed: (){},),
            ),
            onFieldSubmitted: (term){
              Constants.fieldFocusChange(context, _contactFocus,_whatsAppFocus);
            },
          ),
        ],
      ),
    );
  }

  _enterWhatsApp() {
    return Container(padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            textInputAction: TextInputAction.next,
            focusNode: _whatsAppFocus,
            controller: _whatsAppController,
            readOnly: _readOnly,
            onChanged: (value){
              whatsApp = _whatsAppController.text;
            },
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(
                  color:Colors.grey[300],width: 2.0),),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(
                  color:ColorsUsed.baseColor,width: 2.0),),
              prefixIcon: IconButton(icon: Image.asset(Img.profileWhatsApp),onPressed: (){},),
            ),
            onFieldSubmitted: (term){
              Constants.fieldFocusChange(context, _whatsAppFocus,_addressFocus);
            },
          ),
        ],
      ),
    );
  }

  _enterAddress() {
    return Container(padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            focusNode: _addressFocus,
            controller: _addressController,
            readOnly: _readOnly,
            onChanged: (value){
              address = _addressController.text;
            },
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(
                  color:Colors.grey[300],width: 2.0),),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(
                  color:ColorsUsed.baseColor,width: 2.0),),
              prefixIcon: Icon(Img.addressIcon),
            ),
          ),
        ],
      ),
    );
  }

  _enterStatus() {
    return Container(padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _statusController,
            readOnly: true,
            onChanged: (value){
              status = _statusController.text;
            },
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(
                  color:Colors.grey[300],width: 2.0),),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(
                  color:ColorsUsed.baseColor,width: 2.0),),
              prefixIcon: IconButton(icon: Image.asset(Img.profileStatus),onPressed: (){},),
            ),
          ),
        ],
      ),
    );
  }

  //get profile details
  Future<dynamic> getProfile(BuildContext context) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      await http.get("${Constants.BaseUrl}action=getUserProfile&userId=${Constants.userId}"
      ).then(( res) {
        print(res.body);
        var response = json.decode(res.body);
        final int statusCode = res.statusCode;
        print(statusCode);
        if (statusCode == 200) {
          print("its working 200");
          if(response["success"] == 1){
            print(response["Email_address"]);
            prefs.setString("EMAIL", response["Email_address"]);
            setState(() {
              Constants.email = response["Email_address"];
              email = response["Email_address"].toString();
              fullName = response["Full_Name"].toString();
              userName = response["Username"].toString();
              contact = response["Contact_Number"].toString();
              whatsApp = response["Whatsapp_Number"].toString();
              address = response["Address"].toString();
              profilePhoto = response["picture"].toString();
              status = response["Status"].toString()=="null"?"status not provided":response["Status"].toString();
              employeeCode = response["Emp_Code"].toString();
              Constants.userName=fullName;
              Constants.imageUrl=profilePhoto;
              print(Constants.userName);
              _loading = false;
                _userNameController = TextEditingController(text: userName);
                _fullNameController = TextEditingController(text: fullName);
                _emailController = TextEditingController(text: email) ;
                _contactController = TextEditingController(text: contact);
                _whatsAppController = TextEditingController(text: whatsApp);
                _employeeController = TextEditingController(text: employeeCode);
                _addressController = TextEditingController(text: address);
                _statusController = TextEditingController(text: status);
            });
//            Scaffold.of(context).showSnackBar(Constants().showSnackMessage("Login successfully"));
//            Navigator.of(context).push(new MaterialPageRoute(builder: (context) => BottomNavigation()));
          }else{
//            Scaffold.of(context).showSnackBar(Constants().showSnackMessage(response["message"]));
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

//  action=updateUserProfile&userId=1

  //Update profile
  Future<dynamic> updateProfile(BuildContext context) async{
    setState(() {
      _loading = true;
    });
    print("${Constants.BaseUrl}action=updateUserProfile&userId=${Constants.userId}&"
        "Username=$userName&Full_Name=${_fullNameController.text}&Contact_Number=${_contactController.text}&"
        "Email_address=${_emailController.text}&Whatsapp_Number=${_whatsAppController.text}&Address=${_addressController.text}&Emp_Code=$employeeCode&"
        "company=1&picture=$profilePhoto");
    try{
      await http.get("${Constants.BaseUrl}action=updateUserProfile&userId=${Constants.userId}&"
          "Username=$userName&Full_Name=${_fullNameController.text}&Contact_Number=${_contactController.text}&"
          "Email_address=${_emailController.text}&Whatsapp_Number=${_whatsAppController.text}&Address=${_addressController.text}&Emp_Code=$employeeCode&"
          "company=1&picture=$profilePhoto").then(( res) {
        print(res.body);
        var response = json.decode(res.body);
        final int statusCode = res.statusCode;
        print(statusCode);
        setState(() {
          _loading = false;
        });
        if (statusCode == 200) {
          print("its working 200");
          if(response["success"] == 1){
            print(response["Email_address"]);
            setState(() {
              email = response["Email_address"].toString();
              fullName = response["Username"].toString();
              _loading = false;
            });
//            Scaffold.of(context).showSnackBar(Constants().showSnackMessage("Login successfully"));
//            Navigator.of(context).push(new MaterialPageRoute(builder: (context) => BottomNavigation()));
          }else{
//            Scaffold.of(context).showSnackBar(Constants().showSnackMessage(response["message"]));
          }
        }else{
          setState(() {
            _loading = false;
          });
//          Scaffold.of(context).showSnackBar(Constants().showSnackMessage(response["Something went wrong !"]));
        }
      });}on SocketException catch (_) {
      print('not connected');
      Constants().noInternet(context);
    }catch (e) {
    }
  }


  void imageFromCamera()async{
    final pickedFile = await ImagePicker.pickImage(
        source: ImageSource.camera,
        maxHeight: 1000,
        maxWidth: 1200,
        imageQuality: 70);
      setState(() {
        profileImage = File(pickedFile.path);
        if(profileImage != null){
          _loading = true;
        }
      });
    MediaFilesUpload().uploadImage(profileImage, context).then((imageUrlPath){
      print(imageUrlPath);
      setState(() {
        _loading = false;
        profilePhoto = imageUrlPath;
      });
    });

  }

  void imageFromGallery()async{
    final pickedFile = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 1000,
        maxWidth: 1200,
        imageQuality: 70);
      setState(() {
        profileImage = File(pickedFile.path);
        _loading = true;
      });

    MediaFilesUpload().uploadImage(profileImage, context).then((imageUrlPath){
      print(imageUrlPath);
      setState(() {
        _loading = false;
        profilePhoto =Constants.ImageBaseUrl+ imageUrlPath;
        print(profilePhoto);
      });
    });
    }


  @override
    callBackInterface(String title) {
    switch(title){
      case "Submit":
        print("Submit button");
        print(email+userName);
        updateProfile(context);
        setState(() {
          _readOnly = true;
        });
        break;
      case "Camera":
        print("Camera");
        imageFromCamera();
        break;
      case "Gallery":
        print('Gallery');
        imageFromGallery();
    }
  }
}

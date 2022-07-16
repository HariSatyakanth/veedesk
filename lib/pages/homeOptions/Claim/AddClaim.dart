import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newproject/Interfaces/callBackWidget.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/Images_path.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/Utiles/strings.dart';
import 'package:newproject/pages/version_2_files/ImagePickerPath.dart';
import 'package:newproject/pages/version_2_files/MediaFileUploading.dart';

class AddClaim extends StatefulWidget {
  @override
  _AddClaimState createState() => _AddClaimState();
}

class _AddClaimState extends State<AddClaim> implements WidgetCallBack{
  final TextEditingController _claimTitleController = TextEditingController();
  final TextEditingController _claimAmountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime selectedDate ;
  DateTime selectedEndDate ;
  String roleDropdownValue;
  String categotyID;
  String leaveStartDate = "Select Date",leaveEndDate = "Select Date";
  List<MyClaimCategory> roleList = [];
  File _image;
  bool _loader = false;
  String uploadedImagePath;
  static var  imageController  = TextEditingController(text: "Related document(if any)");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getClaimCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarOptions(),
      body: _loader?Center(child: Constants().spinKit):SingleChildScrollView(
        child: Container(padding: EdgeInsets.fromLTRB(30.0, 25.0, 30.0, 20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(Img.deptImage,width: 20.0,color: Colors.grey,),
                  SizedBox(width: 10.0,),
                  Expanded(child: leaveListDropDown()),
                ],
              ),
              SizedBox(height: 10.0,),
              Row(
                children: [
                  Image.asset(Img.notesTitleImage,width: 20.0,color: Colors.grey,),
                  SizedBox(width: 10.0,),
                  Expanded(
                    child: Constants.commonEditTextFieldWithoutIcon( _claimTitleController, false,
                        "Claim Title", "", TextInputType.multiline),
                  ),
                ],
              ),SizedBox(height: 10.0,),
              Row(
                children: [
                  Image.asset(Img.amountImage,width: 20.0,color: Colors.grey,),
                  SizedBox(width: 10.0,),
                  Expanded(
                    child: Constants.commonEditTextFieldWithoutIcon(_claimAmountController, false,
                        "Amount", "", TextInputType.number),
                  ),
                ],
              ),
              SizedBox(height: 10.0,),
              uploadedImagePath == null?_ImagePicker(imageController, "Image upload", "message"):Row(
                children: [
                  Image.network(
                    Constants.ImageBaseUrl+uploadedImagePath,width: Constants().containerWidth(context)*0.2,),
                  Spacer(),
                  IconButton(
                    onPressed: (){
                      Constants.popUpFortwoOptions(context, S.deleteImage, "Are you sure?", this);

                    },icon: Icon(Icons.delete_forever,color: Colors.red),
                  )
                ],
              ),
              SizedBox(height: 10.0),
              Constants.descriptionField(context, "Add description", "", _descriptionController, null, null),
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
          title: Row(
            children: [SizedBox(width: 35.0),
              Image.asset(Img.myOfficeImage,width: 20.0),
              SizedBox(width: 10.0,),
              Text(
                "Apply claim",
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

  //Leave list
  Widget leaveListDropDown(){
    return DropdownButton<String>(
      hint: Text("Claim Type"),
      isExpanded: true,
      value: roleDropdownValue,
      onChanged: (String newValue) {
        setState(() {
          roleDropdownValue = newValue;
        });
      },
      items:roleList
          .map<DropdownMenuItem<String>>((MyClaimCategory category) {
        setState(() {
          categotyID = category.id;
        });
        return DropdownMenuItem<String>(
          value: category.id,
          child: Text(category.categoryName),
        );
      }).toList(),
    );
  }

  @override
  void callBackInterface(String title) {
    switch(title){
      case "Submit":
        print("${Constants.BaseUrl}action=claimInsert&userId= ${Constants.userId}&"
            "claimId=$roleDropdownValue&title=${_claimTitleController.text}&imageUrl=${uploadedImagePath}&status=1&"
            "claimDate=${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}&"
            "amount=${_claimAmountController.text}&description=${_descriptionController.text}");
        validation();
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

  Future<dynamic> addClaim(BuildContext context) async{
    setState(() {
      _loader= true;
    });
    //claimType statusd
    //1:Pending , 2:active,3:close
    try{
      await http.get("${Constants.BaseUrl}action=claimInsert&userId= ${Constants.userId}&"
          "claimId=$roleDropdownValue&title=${_claimTitleController.text}&imageUrl=${uploadedImagePath}&status=1&"
          "claimDate=${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}"
          "amount=${_claimAmountController.text}&description=${_descriptionController.text}"
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

  Future<dynamic> getClaimCategory() async{
    setState(() {
      _loader= true;
    });//&userId=5&claimId=3&title=sdhfs&amount=55&imageUrl=kk.jpg&audioUrl=pe.jpg&description=ghfjkh
    try{
      await http.get("${Constants.BaseUrl}action=claim_category"
      ).then(( res) {

        print(res.body);
        var response = json.decode(res.body);
        final int statusCode = res.statusCode;
        print(statusCode);
        if (statusCode == 200) {
          print("its working 200");
          if(response["success"] == "1"){
            print("in success");
            for(int i=0;i<response["listCategory"].length;i++){
              setState(() {
                roleList.add(MyClaimCategory(
                    id: response["listCategory"][i]["id"],
                    categoryName: response["listCategory"][i]["categoryName"]));
              });
            }
            setState(() {
              _loader= false;
            });
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

  validation() async {
    if(roleDropdownValue != null){
      if(_claimTitleController.text.isNotEmpty){
        if(_claimAmountController.text.isNotEmpty){
          if(_descriptionController.text.isNotEmpty){
            addClaim(context);
          }else{
            Constants.showToast("Please add proper description");

          }
        }else{
          Constants.showToast("Please add amount");

        }
      }else{
        Constants.showToast("Please add title");

      }
    }else{
      Constants.showToast("Please select claim type");

    }

  }
}

class MyClaimCategory {
  String id;
  String categoryName;


  MyClaimCategory({
    this.id,
    this.categoryName,
  });
}

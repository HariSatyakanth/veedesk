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
import 'package:newproject/common/ImagePreview.dart';
import 'package:newproject/pages/version_2_files/ImagePickerPath.dart';
import 'package:newproject/pages/version_2_files/MediaFileUploading.dart';

class AddInventory extends StatefulWidget {
  @override
  _AddInventoryState createState() => _AddInventoryState();
}

class _AddInventoryState extends State<AddInventory>implements WidgetCallBack {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime selectedDate ;
  DateTime selectedEndDate ;
  String inventoryDropdownValue;
  List<String> inventoryList = ["Stationary","General Store",
    "Medical Store","Inventory store 4 "];
  File _image;
  bool _loader = false;
  String uploadedImagePath;
  static var  imageController  = TextEditingController(text: "Related document(if any)");
  int inventoryCount = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarOptions(),
      body: _loader?Center(child: Constants().spinKit,):SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25.0),
                      bottomRight: Radius.circular(25.0),
                    ),
                    child: Container(
                      padding: EdgeInsets.only(top: Constants().containerHeight(context)*0.0),
                      height: Constants().containerHeight(context)/5.5,
                      width: Constants().containerWidth(context),
                      color: ColorsUsed.baseColor,
                    ),
                  ),
                  Container(padding: EdgeInsets.fromLTRB(25.0, Constants().containerHeight(context)*0.15,
                      25.0, 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image.asset(Img.inventoryListImage,width: 20.0,color: Colors.grey,),
                            SizedBox(width: 10.0,),
                            Expanded(child: stationaryDropDown()),
                          ],
                        ),
                        SizedBox(height: 10.0,),
                        Row(
                          children: [
                            Image.asset(Img.notesTitleImage,width: 20.0,color: Colors.grey,),
                            SizedBox(width: 10.0,),
                            Expanded(
                              child: Constants.commonEditTextFieldWithoutIcon( _itemNameController, false,
                                  "Item Name", "", TextInputType.multiline),
                            ),
                          ],
                        ),SizedBox(height: 10.0,),
                        SizedBox(height: 10.0,),
                        Row(
                          children: [
                            Image.asset(Img.inventoryCountImage,width: 20.0,color: Colors.grey,),
                            SizedBox(width: 10.0,),
                            Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0),
                              color: ColorsUsed.baseColor),
                              child:Row(
                                children: [
                                  IconButton(
                                    onPressed: (){
                                      setState(() {
                                        inventoryCount++;
                                      });
                                  },
                                   icon: Icon(Icons.add,color: Colors.white),),
                                  Container(height: 25.0,width: 2.0,color: Colors.white,),
                                  SizedBox(width: 10.0,),
                                  Text(inventoryCount.toString(),style: TextStyle(color: Colors.white),),
                                  SizedBox(width: 10.0,),
                                  Container(height: 25.0,width: 2.0,color: Colors.white,),
                                  IconButton(
                                    onPressed: (){
                                      if(inventoryCount>1){
                                        setState(() {
                                          inventoryCount--;
                                        });
                                      }
                                    },
                                    icon: Icon(Icons.remove,color: Colors.white),),
                                ],
                              )
                            ),
                          ],
                        ),SizedBox(height: 10.0,),
                        SizedBox(height: 10.0,),
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
                        SizedBox(height: Constants().containerWidth(context)*0.1),
                        Row(
                          children: [SizedBox(width: Constants().containerWidth(context)*0.1),
                            Expanded(child: Constants().buttonRaised(context, ColorsUsed.baseColor, S.submit, this)),
                            SizedBox(width: Constants().containerWidth(context)*0.1),],
                        )
                      ],
                    ),

                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment(0.0,-1.0),
              heightFactor: 0.1,
              child: Image.asset("Images/misc/inventory.png",
                width: Constants().containerHeight(context)*0.3,),
            )
          ],
        ),
      ),
    );
  }

  //AppBAr
  _appBarOptions() {
    return AppBar(
      backgroundColor: ColorsUsed.baseColor,
      centerTitle: true,elevation: 0.0,
      title: Row(
        children: [SizedBox(width: 25.0),
          Image.asset(Img.myOfficeImage,width: 20.0,),
          SizedBox(width: 10.0),
          Text("Update Inventory",
            style: Constants().txtStyleFont16(ColorsUsed.whiteColor,18.0),
          ),
        ],
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
        _loader = false;
        uploadedImagePath = value;
//          imageArrayList.add(value);
      });
    });
//      }
  }

  //Leave list
  Widget stationaryDropDown(){
    return DropdownButton<String>(
      hint: Text("Inventory Type"),
      isExpanded: true,
      value: inventoryDropdownValue,
      onChanged: (String newValue) {
        setState(() {
          inventoryDropdownValue = newValue;
        });
      },
      items:inventoryList
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


  Future<dynamic> updateInventory(BuildContext context) async{
    setState(() {
      _loader= true;
    });print("${Constants.BaseUrl}action=inventoryInsert&userId= ${Constants.userId}&"
        "categotyId=${inventoryDropdownValue}&categoryName=${inventoryDropdownValue}&itemName=${_itemNameController.text}&"
        "qty=$inventoryCount&status=1&imageUrl=${uploadedImagePath}&"
        "remark= ${_descriptionController.text}&inventoryDate=${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}");
    try{
      await http.get("${Constants.BaseUrl}action=inventoryInsert&userId= ${Constants.userId}&"
          "categotyId=${inventoryDropdownValue}&categoryName=${inventoryDropdownValue}&itemName=${_itemNameController.text}&"
          "qty=$inventoryCount&status=1&imageUrl=${uploadedImagePath}&"
          "remark= ${_descriptionController.text}&inventoryDate=${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}"
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
    if(inventoryDropdownValue != null){
      if(_itemNameController.text.isNotEmpty){
          if(_descriptionController.text.isNotEmpty){
            updateInventory(context);
          }else{
            Constants.showToast("Please add proper description");
          }
      }else{
        Constants.showToast("Please add item Name");
      }
    }else{
      Constants.showToast("Please select inventory type");
    }

  }

}

import 'dart:convert';
import 'dart:io';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newproject/Interfaces/callBackWidget.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/Images_path.dart';
import 'package:newproject/Utiles/LoadImage.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/Utiles/strings.dart';
import 'package:newproject/common/ImagePreview.dart';
import 'package:newproject/pages/version_2_files/MediaFileUploading.dart';

class TicketFollowUpAdd extends StatefulWidget {

  final taskId;

  const TicketFollowUpAdd({this.taskId});

  @override
  _FollowUpActionState createState() => _FollowUpActionState();
}

class _FollowUpActionState extends State<TicketFollowUpAdd>
    implements WidgetCallBack {
  TextEditingController _titleCtrl = TextEditingController();
  bool _isLoading = false;
  TextEditingController _descriptionCtrl = TextEditingController();
  List<NetworkImage> images;
  List imageArrayList = [];
  File _image;
  String _imgURL = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    images = new List<NetworkImage>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Row(
          children: [
            SizedBox(width: 20.0),
            Image.asset(
              Img.myOfficeImage,
              width: 20.0,
            ),
            SizedBox(width: 10.0),
            Text(
              "Add Follow Up",
              textAlign: TextAlign.center,
              style: Constants().txtStyleFont16(ColorsUsed.whiteColor, 21.0),
            ),
          ],
        ),
        backgroundColor: ColorsUsed.baseColor,
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 40.0),
              child: Column(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(35.0),
                      bottomRight: Radius.circular(35.0),
                    ),
                    child: Container(
                      height: Constants().containerHeight(context) / 5.5,
                      width: Constants().containerWidth(context),
                      color: ColorsUsed.baseColor,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        20.0,
                        Constants().containerHeight(context) / 7,
                        20.0,
                        20.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: [
                            Icon(
                              Img.emailIcon,
                              size: 20.0,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 10.0),
                            Expanded(
                                child: _enterEmail(
                                    "Title", false, _titleCtrl, "Title")),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            showImage(context, "My Lead"),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                                onTap: () {
                                  LoadImage().showPicker(context, this);
                                },
                                child: CircleAvatar(
                                  child: Icon(Icons.upload_outlined),
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            Image.asset(
                              Img.notesTitleImage,
                              width: 20.0,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 10.0),
                            Expanded(
                              child: _enterEmail("Subject", false,
                                  _descriptionCtrl, "Enter description"),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        _showCircularSubmit(),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment(0.8, -1.8),
              heightFactor: 0.1,
              child: Image.asset(
                "Images/forgotPassword/forgot.png",
                width: Constants().containerHeight(context) / 4.8,
              ),
            )
          ],
        ),
      ),
    );
  }

  //gallery method

  galleryMethod() async {
    if (_isLoading) {
      Constants.showToast(S.UPLOADING);
    } else {
      _image = await ImagePicker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 1000,
          maxWidth: 1200,
          imageQuality: 70);
      setState(() {
        _imgURL = _image.path
            .split('/')
            .last
            .substring(12); //.toString();
      });
      print(_imgURL);
      MediaFilesUpload().uploadImage(_image, context).then((value) {
        print(value);
        setState(() {
          imageArrayList.add(value);
          images.add(NetworkImage(Constants.ImageBaseUrl + value));
        });
      });
    }
  }

  //camera method
  cameraMethod() async {
    if (_isLoading) {
      Constants.showToast(S.UPLOADING);
    } else {
      _image = await ImagePicker.pickImage(
          source: ImageSource.camera,
          maxHeight: 1000,
          maxWidth: 1200,
          imageQuality: 70);
      setState(() {
        _imgURL = _image.toString();
      });
      print(_imgURL);
      MediaFilesUpload().uploadImage(_image, context).then((value) {
        print(value);
        setState(() {
          imageArrayList.add(value);
          images.add(NetworkImage(Constants.ImageBaseUrl + value));
        });
      });
    }
  }

  Widget _showCircularSubmit() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Row(
      children: <Widget>[
        Expanded(
            child: Constants()
                .buttonRaised(context, ColorsUsed.baseColor, S.submit, this))
      ],
    );
  }

  Widget _enterEmail(String _prefixText, bool _readValue,
      TextEditingController _controller, String hitText) {
    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
      child: TextField(
        controller: _controller,
        readOnly: _readValue,
        onChanged: (value) {},
        decoration: InputDecoration(
          labelText: _prefixText,
          hintText: hitText,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300], width: 2.0),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ColorsUsed.baseColor, width: 2.0),
          ),
//          prefixText: "$_prefixText  "
        ),
      ),
    );
  }

  //get Task lists
  var _response;

  Future<dynamic> _addFollowUp() async {

    //https://tasla.app/MyOffice/index.php?action=followuptickekInsert
    // &userId=8&ticketId=1&title=jkk&description=kk&followImage=img.jpg&status=1
    print("${Constants.BaseUrl}action=followuptickekInsert&userId=${Constants
        .userId}&ticketId=${widget.taskId}&"
        "title=${_titleCtrl.text}"
        "&description=${_descriptionCtrl
        .text}&followImage=$imageArrayList&status=0");
    try {
      await http.get("${Constants.BaseUrl}action=followuptickekInsert&userId=${Constants
          .userId}&ticketId=${widget.taskId}&"
          "title=${_titleCtrl.text}"
          "&description=${_descriptionCtrl
          .text}&followImage=$imageArrayList&status=0").then((res) {
        print(res.body);
        print("status${res.body}");
        setState(() {
          _response = json.decode(res.body);
        });
        final int statusCode = res.statusCode;
        print(statusCode);
        if (statusCode == 200) {
          print("check 200${_response["success"]}");
          if (_response["success"] == 1) {
            setState(() {
              _isLoading = false;
            });
            Navigator.pop(context, true);
          }
        }else{
          print("sdsdsdZds");
        }
      });
    } on SocketException catch (_) {
      print('not connected');
      Constants().noInternet(context);
    } catch (e) {
      print("SDS");
    }
  }

  Widget showImage(BuildContext context, String name) {
    if (images != null) {
      return images.length > 0
          ? new SizedBox(
          height: 100.0,
          width: 70.0,
          child: Carousel(
            images: images,
            dotSize: 4.0,
            dotSpacing: 15.0,
            dotColor: Colors.lightGreenAccent,
            indicatorBgPadding: 5.0,
            dotBgColor: Colors.brown.withOpacity(0.3),
            borderRadius: true,
            autoplay: false,
            onImageTap: (index) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ImagePreview(images[index].url, name)));
            },
          ))
          : new Container(
        height: 0.0,
      );
    } else {
      return Container();
    }
  }

  @override
  void callBackInterface(String title) {
    switch (title) {
      case S.submit:
        if (_titleCtrl.text.isNotEmpty) {
          if (imageArrayList.length != 0) {
            if (_descriptionCtrl.text.isNotEmpty) {
              setState(() {
                _isLoading = true;
              });
              _addFollowUp();
            } else {
              Constants.showToast("Add description");
            }
          } else {
            Constants.showToast("Add atleast one image");
          }
        } else {
          Constants.showToast("Add title");
        }
        break;
      case "Camera":
        cameraMethod();
        break;
      case "Gallery":
        galleryMethod();
    }
  }
}

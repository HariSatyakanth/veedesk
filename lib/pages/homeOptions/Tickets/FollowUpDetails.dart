import 'dart:convert';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:http/http.dart' as http;
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/common/ImagePreview.dart';
import 'package:newproject/pages/homeOptions/Tickets/TicketDetailPOJO.dart';

class FollowUpDetails extends StatefulWidget {
  final followUpInformation;
  final int screenCheck;

  FollowUpDetails(this.followUpInformation, this.screenCheck);

  @override
  _FollowUpDetailsState createState() => _FollowUpDetailsState();
}

class _FollowUpDetailsState extends State<FollowUpDetails> {
  Followuptickek followUp;
  bool _isOn = false;
  List<NetworkImage> images = new List<NetworkImage>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    followUp = widget.followUpInformation;
    print(followUp.status);
    if (followUp.status == "1") {
      _isOn = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ColorsUsed.baseColor,
        title: Text(followUp.title),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 20.0),
        child: new ListView(
          shrinkWrap: true,
          children: <Widget>[
            showImage(context),
            SizedBox(
              height: 20,
            ),
            Text(
              followUp.title,
              style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                  color: ColorsUsed.textBlueColor),
            ),
            SizedBox(height: 10.0),
            SizedBox(height: 10.0),
            Row(children: [
              Expanded(
                child: Text(
                  "Description",
                  style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                      color: ColorsUsed.textBlueColor),
                ),
              ),
              widget.screenCheck == 0
                  ? Switch(
                  value: _isOn,
                  onChanged: (val) {
                    if (_isOn) {
                      Constants.showToast(
                          "FollowUp is completed by you.Please contact admin to reset");
                    } else {

                      hitUpdateService();
                    }
                  })
                  : Container()
            ]),
            SizedBox(height: 10.0),
            Text(
              followUp.description,
//                _response["description"]==null?"Please wait...":_response["description"],
              style: Constants().txtStyleFont16(Colors.grey[500], 12.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget showImage(BuildContext context) {
    print(followUp.followImage);
    images = Constants.getImageArray(followUp.followImage);
    return new SizedBox(
        height: 220.0,
        width: 350.0,
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
            print(widget.screenCheck);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ImagePreview(images[index].url, followUp.title)));
          },
        ));
  }

  Future<dynamic> hitUpdateService() async {
    var loader= Constants.loader(context);
    await loader.show();
    print("${Constants.BaseUrl}action=followupTickekUpdate&id=${followUp.id}&status=1");
    try {
      await http
          .get(
          "${Constants.BaseUrl}action=followupTickekUpdate&id=${followUp.id}&status=1")
          .then((res) => setState(() {
        var _response = json.decode(res.body);
        _response["success"] == 1 ? _isOn = true : _isOn = false;
        _response["success"] == 1
            ? Constants.showToast(_response["message"])
            : Constants.showToast("Task not updated");
        loader.hide();
      }));
    } catch (e) {
      loader.hide();
      print(e);
    }
  }
}

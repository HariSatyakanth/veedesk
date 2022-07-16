import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:http/http.dart' as http;
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/common/ImagePreview.dart';
import 'package:newproject/pages/homeOptions/Leads/LeadDetailsPojo.dart';

class LeadFuDetails extends StatefulWidget {
  final followUpInformation;
  final int screenCheck;


  LeadFuDetails(this.followUpInformation, this.screenCheck);

  @override
  _FollowUpDetailsState createState() => _FollowUpDetailsState();
}

class _FollowUpDetailsState extends State<LeadFuDetails> {
  FollowupLeads followUp;
  bool _isOn = false,haveAudio=false,isPlaying = false;
  AudioPlayer _audioPlayer;
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
    _audioPlayer = AudioPlayer();
    if(followUp.audioUrl == "" || followUp.audioUrl == null){
      setState(() {
        haveAudio=false;
      });
    }else{
      setState(() {
        haveAudio=true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ColorsUsed.baseColor,
        title: Text(followUp.followupText),
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
              followUp.followupText,
              style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                  color: ColorsUsed.textBlueColor),
            ),
            SizedBox(height: 10.0),
            haveAudio?Row(
              children: [
                Text(
                  "Audio",
                  style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                      color: ColorsUsed.baseColor),
                ),
                SizedBox(width: 20.0),
                Container(
                  padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                  decoration: BoxDecoration(
                      color: ColorsUsed.baseColor,
                      borderRadius: BorderRadius.circular(10.0)),
                  height: 40,
                  width: Constants().containerWidth(context) * 0.5,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          isPlaying
                              ? pause()
                              : play(followUp.audioUrl);
                        },
                        child: CircleAvatar(
                          radius: 15.0,
                          backgroundColor: Colors.white,
                          child: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            color: ColorsUsed.baseColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ): Text(
              'No audio found',
//                _response["description"]==null?"Please wait...":_response["description"],
              style: Constants().txtStyleFont16(Colors.red, 12.0),
            ),
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
    print(followUp.attachment);
    images = Constants.getImageArray(followUp.attachment);
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
                        ImagePreview(images[index].url, followUp.followupText)));
          },
        ));
  }

  Future<dynamic> hitUpdateService() async {
    var loader= Constants.loader(context);
    await loader.show();
    print("${Constants.BaseUrl}action=followupLeadsUpdate&Id=${followUp.id}&Status=1");
    print("https://tasla.app/MyOffice/index.php?action=followupLeadsUpdate&Status=1&Id=1");
    try {
      await http
          .get(
              "${Constants.BaseUrl}action=followupLeadsUpdate&Id=${followUp.id}&Status=1")
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

  play(String audioUr) async {
    print(audioUr);
    int result = await _audioPlayer.play(Constants.ImageBaseUrl+audioUr);
    if (result == 1) {
      setState(() {
        isPlaying = true;
      });
      _audioPlayer.onPlayerCompletion.listen((event) {
        setState(() => isPlaying = false);
      });
    } else {
      Constants.showToast("No Audio Found");
    }
  }

  pause() async {
    await _audioPlayer.pause();
    setState(() {
      isPlaying = false;
    });
  }

}

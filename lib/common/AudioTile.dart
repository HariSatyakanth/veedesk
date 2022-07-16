import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/common/ImagePreview.dart';
class AudioBar extends StatefulWidget {
  final String audioUrl;
  final String sender;
  final String profilePic;
  final int timestamp;
  final bool sentByMe;

  AudioBar(
      {this.audioUrl,
        this.sender,
        this.profilePic,
        this.timestamp,
        this.sentByMe});

  @override
  _AudioBarState createState() => _AudioBarState();
}

class _AudioBarState extends State<AudioBar> {
  AudioPlayer _audioPlayer;
  bool isPlaying = false;
  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    var date = new DateTime.fromMicrosecondsSinceEpoch(widget.timestamp);

    return Container(padding: EdgeInsets.fromLTRB(5.0, 0, 0, 0),
      child: Column(
        crossAxisAlignment: widget.sentByMe ?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
           /*!sentByMe? CircleAvatar(radius: 15.0,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.network(profilePic,
                    fit: BoxFit.cover,)),) : SizedBox(height: 0,)*/
            Container(
              padding: EdgeInsets.only(
                  top: 4,
                  bottom: 4,
                  left: widget.sentByMe ? 0 : 24,
                  right: widget.sentByMe ? 24 : 0),
              alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Column(crossAxisAlignment: widget.sentByMe ?CrossAxisAlignment.end:CrossAxisAlignment.start,
                children: [
                  !widget.sentByMe ?Row(
                    children: [
                      CircleAvatar(radius: 15.0,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.network(widget.profilePic,
                              fit: BoxFit.cover,)),),
                      Text(widget.sender.toUpperCase()+", "+Constants.convertTimeStamp(widget.timestamp),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 11.0,
                              fontWeight: FontWeight.w500,
                              color: ColorsUsed.baseColor,
                              letterSpacing: -0.5)),
                    ],
                  ):Text(Constants.convertTimeStamp(widget.timestamp),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w500,
                          color: ColorsUsed.baseColor,
                          letterSpacing: -0.5)),
                  SizedBox(height: 7.0),
                  Container(
                    margin: widget.sentByMe
                        ? EdgeInsets.only(left: 30)
                        : EdgeInsets.only(right: 30),
                    padding:
                        EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
                    decoration: BoxDecoration(
                      borderRadius: widget.sentByMe
                          ? BorderRadius.only(
                              topLeft: Radius.circular(23),
                              topRight: Radius.circular(23),
                              bottomLeft: Radius.circular(23))
                          : BorderRadius.only(
                              bottomLeft: Radius.circular(23),
                              topRight: Radius.circular(23),
                              bottomRight: Radius.circular(23)),
                      color: widget.sentByMe ? Colors.blue[50] : Colors.white,
                    ),
                      child: InkWell(
                        onTap: () {
                          isPlaying
                              ? pause()
                              : play(widget.audioUrl);
                        },
                        child: CircleAvatar(radius: 15.0,
                          backgroundColor: Colors.white,
                          child: Icon(
                            isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: ColorsUsed.baseColor,
                          ),
                        ),
                      )
                    ,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
  play(String audioUr) async {
    int result = await _audioPlayer.play(audioUr);
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

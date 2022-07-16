import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/constants.dart';

class ViewMeet extends StatefulWidget {
  final MeetSeed;
  ViewMeet(this.MeetSeed);
  @override
  ViewMeetState createState() => ViewMeetState();
}

class ViewMeetState extends State<ViewMeet> {
  InAppWebViewController webView;
  String url = "";
  double progress = 0;

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: _appBarOptions(),
        body: Container(
            child: Column(children: <Widget>[
          Container(
              padding: EdgeInsets.all(10.0),
              child: progress < 1.0
                  ? LinearProgressIndicator(value: progress)
                  : Container()),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                  border: Border.all(color: ColorsUsed.baseColor)),
              child: InAppWebView(
                initialUrl: "https://meet.jit.si/${widget.MeetSeed}",
 /*               initialData: InAppWebViewInitialData(data: """
                <!DOCTYPE html>
                
                <html>
    <iframe allow="camera; microphone; fullscreen; display-capture" src="https://meet.jit.si/mtlbi" style="height: 100%; width: 100%; border: 0px;"></iframe>
</html>
    """),*/
                initialHeaders: {},
                initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                  debuggingEnabled: true,
                )),
                onWebViewCreated: (InAppWebViewController controller) {
                  webView = controller;
                },
                onLoadStart: (InAppWebViewController controller, String url) {
                  print("======Open======");
                  print(url);

                  setState(() {
                    this.url = url;
                  });
                },
                onLoadStop:
                    (InAppWebViewController controller, String url) async {
                  print("======close======");
                  print(url);
                  if(url=="https://meet.jit.si/${widget.MeetSeed}"){
                    Constants.showToast("To join meeting please click on Launch in web .");
                  }
                  else if (url.contains("close3.html")) {
                    Navigator.pop(context);
                    Constants.showToast("Thank for joining.");
                  }
                  setState(() {
                    this.url = url;
                  });
                },
                androidOnPermissionRequest: (InAppWebViewController controller,
                    String origin, List<String> resources) async {
                  return PermissionRequestResponse(
                      resources: resources,
                      action: PermissionRequestResponseAction.GRANT);
                },

                onProgressChanged:
                    (InAppWebViewController controller, int progress) {
                  setState(() {
                    this.progress = progress / 100;
                  });
                },
              ),
            ),
          ),
        ])),
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
          title: Text(
            "TrioSolve Meets",
            style: Constants().txtStyleFont16(ColorsUsed.whiteColor, 20.0),
          ),
        ),
      ),
      preferredSize:
          Size.fromHeight(Constants().containerHeight(context) * 0.08),
    );
  }
}

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';



class PushNotificationsManager {

  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance = PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;


  Future<void> init(BuildContext context) async {
    /*var sharedPreferenceValue = await Global.getUserDetails();
    userDetails = ProfileDetailsPojo.fromJson(jsonDecode(sharedPreferenceValue));*/
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions(
          IosNotificationSettings(sound: true,alert: true));
      _firebaseMessaging.onIosSettingsRegistered
          .listen((IosNotificationSettings settings) {
        print("Settings registered: $settings");
      });
      _firebaseMessaging.configure(
        // When the app is open and it receives a push notification
          onMessage: (message) async {
            print(message);
            showSimpleNotification(
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Constants.selectedFontWidget(
                        message["notification"]["title"].toString(),
                        Colors.orange, 16.0, FontWeight.bold),
                    Constants.selectedFontWidget(
                        message["notification"]["body"].toString(),
                        Colors.orange, 12.0, null),
                  ],
                ),
                duration: Duration(seconds: 3),
                slideDismiss: false,
                autoDismiss: true,
                background: Colors.white
            );
            FlutterRingtonePlayer.playNotification();
          /*  if (message["data"]["notificationType"] == Constant.FOR_APPROVAL_NOTIFICATION) {
              // for approve the  provider account notification

            }else if(message["data"]["notificationType"] == Constant.FOR_REQUEST_RECEIVE_NOTIFICATION){
              // this case is only for provider, who will receive the request from user
              popUpForAccept(context, message["notification"]["body"].toString(),
                  message["notification"]["title"],jsonDecode(message["data"]["message"].toString()));

            }else if(message["data"]["notificationType"] == Constant.FOR_ACCEPT_REJECT_NOTIFICATION){
              // this case is only for user who will got the response from provider regarding the booking request
              print(jsonDecode(message["data"]["message"].toString()));
              var response = jsonDecode(message["data"]["message"].toString());
              //0 is for cancel,1 is for accept , 2 is for reject, 3 is for complete , 4 is for start
              if(response["request_status"]==Constant.REQUEST_STATUS_ACCEPT){
//              notificationUpdateInterface.updateFromNotification(message,context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>TrackingPage(jsonDecode(message["data"]["message"]))));
              }else if(response["request_status"]==Constant.REQUEST_STATUS_REJECT){

                notificationUpdateInterface.updateFromNotification(message,context);
//              Navigator.pop(context);
                Global.okButtonPopup(context, "dasfas", "asdfasfas");
              }else if(response["request_status"]==Constant.REQUEST_STATUS_COMPLETED){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ManagePayment()));
              }else if(response["request_status"]==Constant.REQUEST_STATUS_START){
                Global.okButtonPopup(context, "dasfas", "asdfasfas");
              }else if(response["request_status"]==Constant.REQUEST_STATUS_CANCEL){
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                    builder: (context) => BottomNavigation()),ModalRoute.withName("/Bottom"));
              }
            }else{
              print("message$message");
            }*/
          },
          //  When the app is completely closed and opened directly from the push notification.
          onLaunch: (message) async{
            print("launch$message");
            FlutterRingtonePlayer.playNotification();

          },
          //  When the app is in the background and opened directly from the push notification.
          onResume: (message) async{
            print("resume$message");

          }
      );

      // For testing purposes print the Firebase Messaging token
      String token = await _firebaseMessaging.getToken();
      print("FirebaseMessaging token: $token");

      _initialized = true;
    }
  }

}
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/Images_path.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:newproject/common/FilePageAPi.dart';
import 'package:newproject/models/EventListPOJO.dart';
import 'package:newproject/pages/homeOptions/Events/AddEvent.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MyEvent extends StatefulWidget {
  @override
  _MyEventState createState() => _MyEventState();
}

class _MyEventState extends State<MyEvent> {
  List<Meeting> meetings;
  List meetingData = [];
  EventListPOJO eventListPOJO = EventListPOJO();
  var wishController = TextEditingController();
  bool _loader = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEventList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddEvent(),)).then((value){
            if(value){
              setState(() {
                _loader = true;
              });
              getEventList();
            }
          });
        },backgroundColor: ColorsUsed.baseColor,
        child: Icon(Icons.add,size: 35.0,),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25.0),
              bottomRight: Radius.circular(25.0),
          ),
          child: AppBar(centerTitle: true,elevation: 0.0,backgroundColor: ColorsUsed.baseColor,
            title:  Text("My Events",
              textAlign: TextAlign.center,
              style: Constants().txtStyleFont16(ColorsUsed.whiteColor,21.0),
            ),),
        ),
      ),
      body: _loader?Center(child: CircularProgressIndicator(),):Column(
        children: [
          Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
            )),
            margin: EdgeInsets.fromLTRB(0.0,20.0,0.0,20.0),
            child: Container(
              height: Constants().containerHeight(context)*0.5,
              child: new SfCalendar(
                onTap: (value) {
                  print("value${value.targetElement}");
                  for(int i=0;i<meetings.length;i++){
                    if(meetings[i].from == value.date){
                      print(meetings[i].from);
                      setState(() {
                        meetingData.add(value);
                      });
                    }
                  }
                },
                view: CalendarView.month,
                dataSource: MeetingDataSource(_getDataSource()),
                // by default the month appointment display mode set as Indicator, we can
                // change the display mode as appointment using the appointment display
                // mode property
                monthViewSettings: MonthViewSettings(
                  showAgenda: true,
                    appointmentDisplayMode: MonthAppointmentDisplayMode.indicator),
              ),
            ),
          ),
          showDateData()
//          ListView.builder(itemBuilder: (context, index) {
//            return  Container();
//          } ,)
        ],
      ),
    );

  }

  //get EventList from backend
  getEventList() async {
    try{
      var response = await FilePageApi().getRequest("eventsList&userId=${Constants.userId}", context);
      var responseList = await json.decode(response.body);
      print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.body);
        setState(() {
          _loader = false;
          eventListPOJO = EventListPOJO.fromJson(jsonDecode(response.body));
        });
        print("eventListPOJO${eventListPOJO.eventsList.length}");
      }
      else{

        Constants.showToast(responseList["error"]);
      }
    }on SocketException catch(e){
      Constants().noInternet(context);
    }
  }

  _addWishes(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("TeslaSoft Anniversary"),
            content: TextField(
              controller: wishController,
              decoration: InputDecoration(hintText: "Add wish"),
            ),
            actions: <Widget>[
              FlatButton(
                //Click on yes to perform operation according to use
                onPressed: () {
                  Navigator.pop(context);
                },
                child: new Text('Go Back',style: TextStyle(color: ColorsUsed.textBlueColor,fontWeight: FontWeight.w500),),
              ),
              RaisedButton(
                //Click on yes to perform operation according to use
                onPressed: () async{
                  wishController.clear();
                },color: ColorsUsed.baseColor,
                child: new Text('Send',style: TextStyle(color: ColorsUsed.whiteColor,fontWeight: FontWeight.w500),),
              ),
            ],
          );
        });
  }

  showDateData(){
    return  Column(
      children: [
        Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
          color: ColorsUsed.baseColor, elevation: 5.0,
          child: Container(
              width: Constants().containerWidth(context)*0.8,
              height: 40.0,
            child: Center(
              child: Text("Today's Anniversary",style: TextStyle(color:Colors.white,fontSize: 15.0),)
            )
          )
        ),
        Container(padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
          child: Row(
            children: [
              Container(height: 70.0, width: 70.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22.0),
                  color: ColorsUsed.grey200,),
                child: Center(
                    child: Image.asset(Img.myOfficeImage,width: 50.0,color: ColorsUsed.textBlueColor,)
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text("TeslaSoft", textAlign: TextAlign.start,
                              style: TextStyle(color: ColorsUsed.textBlueColor, fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                      ],
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("descr", textAlign: TextAlign.start,
                            style: TextStyle(color: Color(0xff808FA3), fontSize: 16,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ],
                ),
              ),
              RaisedButton(
                elevation: 5.0,
                onPressed: (){
                  _addWishes();
                },
                color: ColorsUsed.baseColor,
                child: Text("Send wishes!", textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.white, fontSize: 13,
                        fontWeight: FontWeight.w400)),
              )
            ],
          ),
        ),
      ],
    );
  }


  List<Meeting> _getDataSource() {
    meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime =
    DateTime(today.year, today.month, today.day, 0, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    /*meetings.add(Meeting(
        'Conference', startTime, endTime, const Color(0xFF0F8644), false));*/
    for(int i=0;i<eventListPOJO.eventsList.length;i++){
      DateTime date =  DateTime.parse(eventListPOJO.eventsList[i].startDate);
      print(date);
      meetings.add(Meeting(eventListPOJO.eventsList[i].title,
          DateTime(DateTime.parse(eventListPOJO.eventsList[i].startDate).year, DateTime.parse(eventListPOJO.eventsList[i].startDate).month,
              DateTime.parse(eventListPOJO.eventsList[i].startDate).day, 0, 0, 0),
          DateTime(DateTime.parse(eventListPOJO.eventsList[i].endDate).year, DateTime.parse(eventListPOJO.eventsList[i].endDate).month,
              DateTime.parse(eventListPOJO.eventsList[i].endDate).day, 0, 0, 0), const Color(0xFFE38888), true));

    }
    return meetings;
  }
}
class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }
}

class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}
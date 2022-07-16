import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/Images_path.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/Utiles/strings.dart';
import 'package:newproject/models/DashboardModal.dart';
import 'package:newproject/pages/homeOptions/Add_Notes/MyNotes.dart';
import 'package:newproject/pages/homeOptions/Claim/ClaimList.dart';
import 'package:newproject/pages/homeOptions/Graphs.dart';
import 'package:newproject/pages/homeOptions/Inventory/InventoryList.dart';
import 'package:newproject/pages/homeOptions/LeaderBoard/LeaderBoard.dart';
import 'package:newproject/pages/homeOptions/MyContacts/MyContactList.dart';
import 'package:newproject/pages/homeOptions/MyContacts/chat.dart';
import 'package:newproject/pages/homeOptions/MyLeaves/LeaveList.dart';
import 'package:newproject/pages/homeOptions/PaySlip/MyPaySlip.dart';
import 'package:newproject/pages/homeOptions/Queries/recieved_query.dart';
import 'package:newproject/pages/homeOptions/Tickets/TicketList.dart';
import 'package:newproject/pages/homeOptions/WorkLog/WorkLogList.dart';
import 'package:newproject/pages/homeOptions/attendanceModule/UseFriendAttendance.dart';
import 'package:newproject/pages/homeOptions/queryDirectory/my_queries.dart';
import 'package:newproject/pages/myProfile.dart';
import 'package:text_tools/text_tools.dart';

import 'homeOptions/Events/MyEvent.dart';
import 'homeOptions/ExpenseTracker/AddExpense.dart';
import 'homeOptions/Files/My_Files.dart';
import 'homeOptions/groupChat.dart';
import 'homeOptions/log_me_in.dart';
import 'homeOptions/Leads/my_leads.dart';
import 'homeOptions/Tasks/my_tasks.dart';

class DashboardSreach extends StatefulWidget {
  @override
  _DashboardSreachState createState() => _DashboardSreachState();
}

class _DashboardSreachState extends State<DashboardSreach> {
  TextEditingController searchController = TextEditingController();
  List<DashboardModal> documentList;
  List<DashboardModal> filteredList;
  String searchStr = "";
  String textNoData = "Search List is empty";

  @override
  void initState() {
    documentList = new List();
    filteredList = new List();
    setState(() {
      documentList.add(DashboardModal(1, S.ATTENDANCE, Img.newAttendanceImage));
      documentList.add(DashboardModal(2, S.use_friend, Img.newAttendanceImage));
      documentList.add(DashboardModal(3, S.TASK, Constants.taskImage));
      documentList.add(DashboardModal(4, S.LEAD, Constants.leadImage));
      documentList.add(DashboardModal(5, S.WorkLog, Img.workLogImage));
      documentList.add(DashboardModal(6, S.inventory, Img.inventoryImage));
      documentList.add(DashboardModal(7, S.queries, Constants.queryImage));
      documentList.add(DashboardModal(8, S.expense, Constants.queryImage));
      documentList.add(DashboardModal(9, S.reminder, Img.reminderImage));
      documentList.add(DashboardModal(10, S.ticket, Img.ticketImage));
      documentList.add(DashboardModal(11, S.workTag, Img.workTagImage));
      documentList.add(DashboardModal(12, S.paySlip, Img.payImage));
      documentList.add(DashboardModal(13, S.knowedgeBase, Img.knowledgeImage));
      documentList
          .add(DashboardModal(14, S.VIDEO_CONF, Img.videoConferenceImage));
      documentList
          .add(DashboardModal(15, S.LEADER_BOARD, Img.leaderBoardImage));
      documentList.add(DashboardModal(16, S.ANALYTICS, Img.analyticsImage));
      documentList.add(DashboardModal(17, S.KPI, Img.kpiImage));
      documentList.add(DashboardModal(18, S.CALENDAR, Img.calendarImage));
      documentList.add(DashboardModal(19, S.CHAT, Img.chatImage));
      documentList.add(DashboardModal(20, S.File, Img.fileImage));
      documentList.add(DashboardModal(21, S.contact, Img.contactBookImage));
      documentList.add(DashboardModal(22, S.MyClaims, Img.claimImage));
      documentList.add(DashboardModal(23, S.MyLeaves, Img.leaveImage));
      documentList.add(DashboardModal(24, S.profile, Img.profileUser));
      filteredList.addAll(documentList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsUsed.baseColor,
        title: Text("Search"),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 20.0),
        child: Column(
          children: [
            _searchBar(),
            SizedBox(height: 50.0),
            showSearchList(),
          ],
        ),
      ),
    );
  }

  _searchBar() {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xFFCFD8DC),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          contentPadding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
          hintText: "Search...",
          prefixIcon: Icon(Icons.search)),
      onChanged: (value) {
        searchStr = searchController.text;
        searchStr = TextTools.toUppercaseFirstLetter(text: searchStr);
        if (searchStr.isNotEmpty) {
          print("xs: " + searchStr);
          getData(searchStr);
        }
      },
    );
  }

  // String capitalize() {
  //   return "${this[0].toUpperCase()}${this.substring(1)}";
  // }
  Widget showSearchList() {
    if (filteredList.length > 0) {
      return Expanded(
        child: ListView.builder(
//            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: filteredList.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  _clickOperations(filteredList[index].id);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Ink(
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                          gradient: Constants().baseColorGradient,
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            filteredList[index].pic,
                            width: 60.0,
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            filteredList[index].name,
                            textAlign: TextAlign.start,
                            style: Constants()
                                .txtStyleFont16(ColorsUsed.baseColor, 14.0),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    )
                  ],
                ),
              );
            }),
      );
    } else {
      return Center(
          child: Text(
        textNoData,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30.0),
      ));
    }
  }

  void getData(String searchName) {
    setState(() {
      filteredList.clear();
    });
    for (int i = 0; i < documentList.length; i++) {
      if (documentList[i].name.contains(new RegExp(r'' + searchName, caseSensitive: false))) {
        //filteredList
        setState(() {
          filteredList.add(documentList[i]);
        });
      }
    }
  }

  void _clickOperations(int id) {
    switch (id) {
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => EmployeeLoggedIn()));
        break;
      case 2:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => UseFriendAttendance()));
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyTasks()));
        break;
      case 4:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyLeads()));
        break;
      case 5:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => WorkLogList()));
        break;
      case 6:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => InventoryList()));
        break;

      case 7:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyQuery()));

        break;
      case 8:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddExpense()));
        break;
      case 9:
        Constants.showToast("Coming soon..!");
        break;
      case 10:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => TicketList()));
        break;
      case 11:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyNotes()));
        break;
      case 12:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyPaySlip()));
        break;
      case 13:
        Constants.showToast("Coming soon..!");
        break;

      case 14:
        Constants.showToast("Coming soon..!");
        break;
      case 15:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LeaderBoard()));
        break;
      case 16:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Graphs()));
        break;
      case 17:
        Constants.showToast("Coming soon..!");
        break;
      case 18:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyEvent()));
        break;
      case 19:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Chat()));
        break;
      case 20:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyFiles()));
        break;
      case 21:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyContact()));
        break;
      case 22:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ClaimList()));
        break;
      case 23:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LeaveList()));
        break;
      case 24:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Profile(0)));
        break;
    }
  }
}

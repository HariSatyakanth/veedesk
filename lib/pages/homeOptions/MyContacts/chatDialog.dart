import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/Images_path.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/Utiles/database.dart';
import 'package:newproject/pages/homeOptions/MyContacts/MyContactList.dart';
import 'package:newproject/pages/homeOptions/MyContacts/chat.dart';
import 'package:newproject/pages/homeOptions/groupChat.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Stream chatRooms;
  var searchController = TextEditingController();

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Expanded(
              child: ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return ChatRoomsTile(
                      userName: snapshot.data.documents[index].data['chatRoomId']
                          .toString()
                          .replaceAll("_", "")
                          .replaceAll(Constants.userName, "")
                          .replaceAll('.', " "),
                      chatRoomId:
                          snapshot.data.documents[index].data["chatRoomId"],
                    );
                  }),
            )
            : Container();
      },
    );
  }

  _appBarOptions() {
    return PreferredSize(
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(30.0),
          bottomLeft: Radius.circular(30.0),
        ),
        child: AppBar(backgroundColor: ColorsUsed.baseColor,
          leading: Constants().backButton(context),
          centerTitle: true,
          title: Text("Messaging",
            style: Constants().txtStyleFont16(ColorsUsed.whiteColor,20.0),),
        ),
      ),
      preferredSize: Size.fromHeight(Constants().containerHeight(context)*0.08),
    );
  }

  _searchBar() {
    return Padding(
      padding: EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 20.0),
      child: Card(elevation: 5.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: TextField(
          controller: searchController,
          readOnly: true,
          onTap: (){
//        Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchPage(0)));
          },
          decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xFFF2F2F2
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none),
              contentPadding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
              disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none),
              hintText: "Search...",
              prefixIcon: IconButton(icon: Icon(Icons.search,color: Colors.grey,),onPressed: (){},)
          ),
          onChanged: (value){
            print(searchController.text);
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
  }

  getUserInfogetChats() async {
    DatabaseMethods().getUserChats(Constants.userName).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms} this is name  ${Constants.userName}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarOptions(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => MyContact(),));
        },backgroundColor: ColorsUsed.baseColor,
        child: Icon(Icons.add,size: 35.0,),
      ),
      body: Container(
        child: Column(
          children: [
            _searchBar(),
            Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(15,15.0,15.0,0.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage()));
                    },
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
                                    child: Text("Team Talk", textAlign: TextAlign.start,
                                        style: TextStyle(color: ColorsUsed.textBlueColor, fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Text("time", textAlign: TextAlign.start,
                                      style: TextStyle(color: Color(0xff808FA3), fontSize: 16,
                                          fontWeight: FontWeight.w400)),
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
                        )
                      ],
                    ),
                  ),
                  Divider(color: Color(0xff2C2929),)
                ],
              ),
            ),
            chatRoomsList(),
          ],
        ) ,
      //  child: chatRoomsList(),
      ),
    );
  }


}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomsTile({this.userName, @required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    print(this.userName);
    print(this.chatRoomId);
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Chat(
                      chatRoomId: chatRoomId,
                    )));
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(15,15.0,15.0,0.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(height: 70.0, width: 70.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22.0),
                    color: ColorsUsed.grey200,),
                  child: Center(
                    child: Text(userName.substring(0, 1).toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: ColorsUsed.textBlueColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
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
                            child: Text(userName, textAlign: TextAlign.start,
                                style: TextStyle(color: ColorsUsed.textBlueColor, fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text("time", textAlign: TextAlign.start,
                              style: TextStyle(color: Color(0xff808FA3), fontSize: 16,
                                  fontWeight: FontWeight.w400)),
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
                )
              ],
            ),
            Divider(color: Color(0xff2C2929),)
          ],
        ),
      ),
    );
  }

}

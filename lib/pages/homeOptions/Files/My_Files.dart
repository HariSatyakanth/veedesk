import 'package:flutter/material.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/Images_path.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/common/FilePageAPi.dart';
import 'package:newproject/models/FolderListPojo.dart';
import 'package:newproject/pages/homeOptions/Files/FolderDetails.dart';
import 'package:newproject/pages/version_2_files/CreateFolder.dart';

class MyFiles extends StatefulWidget {
  @override
  _MyFilesState createState() => _MyFilesState();
}

class _MyFilesState extends State<MyFiles> {
  int _colorId = 0;
  var folderController = TextEditingController();
  FolderListPojo folderListPojo = FolderListPojo();
  FolderListPojo mainFolderListPojo = FolderListPojo();
  bool _loader =  true;

  @override
  void initState() {
    super.initState();
    _folderList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarOptions(),
      body:  _loader?Center(child: Constants().spinKit,):Container(
        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.0),topLeft: Radius.circular(20.0)
        ),color: Colors.grey[300]
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Constants.selectedFontWidget("Folders", Color(0xff7A8499),
                    17.0, FontWeight.bold)),
                RaisedButton(
                  onPressed: () {
                    _addFolderName();
                  },color: ColorsUsed.baseColor,elevation: 5.0,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  child: Text("+ Create folder",style: Constants().txtStyleFont16(ColorsUsed.whiteColor, 16.0),),
                )
              ],
            ),
            SizedBox(height: 25.0,),
            searchTab(),
            folderListPojo.folderList==null?Text("No folders to show"):Expanded(
              child: ListView.builder(
                 itemCount: folderListPojo.folderList.length,
//                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, i) {
                    return Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder:
                                (context) => FolderDetails(folderListPojo.folderList[i].folderName,folderListPojo.folderList[i].id)));
                          },
                          child: SingleChildScrollView(
                            child: Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),),
                              color: Colors.white,
                              child: Container(padding: EdgeInsets.fromLTRB(30.0,15.0,30.0,0.0),
                                width: Constants().containerWidth(context)*0.55,
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Card(elevation: 10.0,child: Image.asset(Img.folderImage)),
                                    SizedBox(height: 20.0),
                                    Constants.selectedFontWidget(folderListPojo.folderList[i].folderName, ColorsUsed.textBlueColor,
                                        15.0, FontWeight.bold),
                                    SizedBox(height: 10.0),
                                    Constants.selectedFontWidget("Created: "+folderListPojo.folderList[i].createdAt.substring(0,10),
                                        Color(0xff7A8499), 10.0, FontWeight.w500),
                                  ],
                                ),),
                            ),
                          ),
                        ),
                        SizedBox(height: 15.0),
                      ],
                    );
                  },),
            ),

          ],
        ),
      ),
    );
  }

  //AppBAr
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
          title: Text("My Files Interface",
            style: Constants().txtStyleFont16(ColorsUsed.whiteColor,20.0),),
          actions: [
            InkWell(
              onTap: (){

              },
              child: CircleAvatar(radius: 15.0,
                backgroundImage: NetworkImage(Constants.imageUrl == "null"?Constants.USER_IMAGE:Constants.imageUrl,
                ),
              ),
            )
            ,SizedBox(width: 20.0,)
          ],
        ),
      ),
      preferredSize: Size.fromHeight(Constants().containerHeight(context)*0.08),
    );
  }

  //search

  //button
  _button(String title,int id){
    return SizedBox(height: Constants().containerHeight(context)/16,
      child: RaisedButton(
        onPressed: (){
          _clickOperation(title);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        elevation: 0.0,
        color: _colorId == id?ColorsUsed.baseColor:ColorsUsed.whiteColor,
        child: Text(title,
            style: TextStyle(fontSize:16.0,color: _colorId == id?ColorsUsed.whiteColor:Colors.black,
                fontFamily: "Montserrat",fontWeight: FontWeight.w500)),
      ),
    );
  }

  _addFolderName(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Add Folder"),
            content: TextField(
              controller: folderController,maxLength: 10,
              decoration: InputDecoration(hintText: "Add folder name"),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  if(folderController.text.isNotEmpty){
                    folderController.clear();
                  }
                  Navigator.pop(context);
                },
                child: new Text('Go Back',style: TextStyle(color: ColorsUsed.textBlueColor,fontWeight: FontWeight.w500),),
              ),
              RaisedButton(
                //Click on Submit to perform operation according to use
                onPressed: () {
                  _submitData();
                },color: ColorsUsed.baseColor,
                child: new Text('Submit',style: TextStyle(color: ColorsUsed.whiteColor,fontWeight: FontWeight.w500),),
              ),
            ],
          );
        });
  }

  _clickOperation(String title){
    switch(title){
      case "Active":
        setState(() {
          _colorId = 0;
        });
        break;
      case "Closed":
        setState(() {
          _colorId = 1;
        });
    }
  }
//Buttons Ui
  _cardWithButton() {
    return Card(elevation: 5.0,margin: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      child: Row(
        children: [
          Expanded(
              child: _button("Sent",0)
          ),
          Expanded(
              child: _button("Received",1)
          )
        ],
      ),
    );
  }

   _submitData() async{
    if(folderController.text.isNotEmpty){
      if(folderController.text.length<11){
        FilePageApi().createNewFolder(Constants.userId,folderController.text, context).then((value){
          Navigator.pop(context);
          _loader =  true;
          folderController.clear();
          //folderListPojo.folderList.clear();
          _folderList();
        });
//        String folderInAppDocDir = await CreateFolder.createFolderInAppDocDir(folderController.text);
//        print("folderInAppDocDir$folderInAppDocDir");

      }else{
        Constants.showToast("Folder name contain maximum 10 words");
      }
    }else{
      Constants.showToast("Enter folder name");
    }
   }

   _folderList() {
     FilePageApi().getFolderList(Constants.userId, context).then((folderDetails){
       if(folderDetails != null) {
         setState(() {
           _loader = false;
           folderListPojo = folderDetails;
           mainFolderListPojo = folderDetails;

         });
         print("folder${mainFolderListPojo.folderList.length}");
       }else{
         setState(() {
           _loader = false;
         });
       }
     });
   }


  searchTab() {
    return TextField(
      decoration: InputDecoration(

          filled: true,
          fillColor: Color(0xFFCFD8DC),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          contentPadding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
          hintText: "Search...",
          prefixIcon: Icon(Icons.search)
      ),
      onChanged: (value){

        print(mainFolderListPojo.toJson());
        if(value.length>0) {
          setState(() {
            folderListPojo.folderList=null;
            _searchactiveTaskLists(value);
          });


        }else{
          print("empy");
          setState(() {
            folderListPojo.folderList=null;
            folderListPojo =FolderListPojo.fromJson(mainFolderListPojo.toJson());
          });
        }
      },
    );
  }

  void _searchactiveTaskLists(String value) {
    folderListPojo.folderList=mainFolderListPojo.folderList.where((c) => c.folderName.contains(new RegExp(r'' + value, caseSensitive: false))).toList();
  }

}

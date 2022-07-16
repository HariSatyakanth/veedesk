import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/common/FilePageAPi.dart';
import 'package:newproject/models/GetFileListPOjo.dart';
import 'package:newproject/pages/homeOptions/Files/My_Files.dart';
import 'package:file_picker/file_picker.dart';
import 'package:newproject/pages/version_2_files/MediaFileUploading.dart';
import 'package:url_launcher/url_launcher.dart';

class FolderDetails extends StatefulWidget {
  final folderName,id;
  FolderDetails(this.folderName,this.id);
  @override
  _FolderDetailsState createState() => _FolderDetailsState();
}

class _FolderDetailsState extends State<FolderDetails> {
  var folderController = TextEditingController();
  GetFileListPOJO getFileListPOJO = GetFileListPOJO();
  String _fileName;
  int _fileType = 0;
//  List<PlatformFile> _paths;
  FilePickerResult _paths;
  String _directoryPath;
  String _extension;
  bool _loader = true;
  bool _multiPick = false;
  FileType _pickingType;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    getFilesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarOptions(),
      body: _loader?Center(child: Constants().spinKit,):Container(
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _typeOfFiles(),
                /*RaisedButton(
                  onPressed: () {
                    _addFiles();
                  },color: ColorsUsed.baseColor,elevation: 5.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  child: Text("+ Add files",style: Constants().txtStyleFont16(ColorsUsed.whiteColor, 16.0),),
                ),*/
                SizedBox(width: 10.0),
              ],
            ),
            _listFiles()
          ],
        ),
      ),
    );
  }

  void _openFileExplorer(FileType pickType) async{
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        type: pickType,/*_pickingType,*/
//        allowMultiple: _multiPick,
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '')?.split(',')
            : null,
      ))
          ;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    catch (ex) {
      print(ex);
    }
    if(_paths!=null){
      print("hello${_paths.paths}");
      MediaFilesUpload().uploadFiles(_paths.paths.first, context).then((uploadedFileUrl){
        print("uploadedFileUrl$uploadedFileUrl");
        FilePageApi().addFile(context: context,fileUrl: uploadedFileUrl,fileName: _paths.names[0],fileType: _fileType,
        folderID: widget.id,userID: Constants.userId).then((value){
          print("uploadedFileUrluploadedFileUrl$value");
//            getFileListPOJO.fileList.clear();
          getFilesList();
        });

      });
    }else{
      print("no");
    }
    if (!mounted) return;
    print("value1${_paths}");
    setState(() {
      _fileName = _paths != null ? _paths/*.map((e) => e.name)*/.toString() : '...';
    });
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
          title: Text(widget.folderName,
            style: Constants().txtStyleFont16(ColorsUsed.whiteColor,20.0),),
          actions: [
            popUpMenuList(),
            SizedBox(width: 20.0,)
          ],
        ),
      ),
      preferredSize: Size.fromHeight(Constants().containerHeight(context)*0.08),
    );
  }

  getFilesList(){
    FilePageApi().getFileList(context: context,folderID: widget.id).then((fileList){
      if(fileList !=null){
        setState(() {
          _loader = false;
          getFileListPOJO = fileList;
        });
      }else{
        setState(() {
          _loader = false;
        });
      }
    });
  }

  Widget popUpMenuList(){
    return PopupMenuButton(
      itemBuilder: (context) {
        var list = List<PopupMenuEntry<Object>>();
        list.addAll([
          PopupMenuItem(
            child: InkWell(
                onTap: (){
                  _renameFolderName();
                },
                child: Text("Rename Folder")),
            value: 1,
          ),
          PopupMenuItem(
            child: InkWell(
                onTap: (){
                 _deleteFolderConfirmation();
                },
                child: Text("Delete Folder")),
            value: 2,
          ),
          ]
        );
        return list;
      },
      icon: Icon(
        Icons.more_vert,
        color: Colors.white,
      ),
    );
  }

  _renameFolderName(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Rename"),
            content: TextField(
              controller: folderController,maxLength: 10,
              decoration: InputDecoration(hintText: "Rename folder name"),
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


  _deleteFolderConfirmation(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Do you want to delete folder"),

            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: new Text('No',style: TextStyle(color: ColorsUsed.textBlueColor,fontWeight: FontWeight.w500),),
              ),
              FlatButton(
                //Click on Submit to perform operation according to use
                onPressed: () {
                  FilePageApi().deleteFolder(widget.id, context).then((value){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyFiles()));
                  });
                },
                child: new Text('Yes',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
              ),
            ],
          );
        });
  }

  _deleteFileConfirmation(int index){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Do you want to remove this file"),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: new Text('No',style: TextStyle(color: ColorsUsed.textBlueColor,fontWeight: FontWeight.w500),),
              ),
              FlatButton(
                //Click on Submit to perform operation according to use
                onPressed: () {
                  FilePageApi().deleteFile(getFileListPOJO.fileList[index].id, context).then((value){
                    Navigator.pop(context);
                    getFilesList();
                  });
                },
                child: new Text('Yes',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
              ),
            ],
          );
        });
  }

  _addFiles(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Upload File"),
            content: Container(
              height: Constants().containerWidth(context)*0.4,
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _typeOfFiles(),
                 /* RaisedButton(
                    onPressed: () => _openFileExplorer(),
                    color: ColorsUsed.baseColor,
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    child: Text("Select File",style: Constants().txtStyleFont16(ColorsUsed.whiteColor, 16.0),),
                  ),*/
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: new Text('Go Back',style: TextStyle(color: ColorsUsed.textBlueColor,fontWeight: FontWeight.w500),),
              ),
            ],
          );
        });
  }

  _typeOfFiles(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
      child: Card(//color: ColorsUsed.baseColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 10,
        child: Container(//color: ColorsUsed.baseColor,
          padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
                style: Constants().txtStyleFont16(ColorsUsed.whiteColor, 16.0),
                hint: Text('Load file from',style: Constants().txtStyleFont16(Colors.black, 13.0),),
                iconDisabledColor: ColorsUsed.whiteColor,
                value: _pickingType,
                items: <DropdownMenuItem>[
                 // filetype 1-Image,2-Video, 3-Audio,4- PDF
                  DropdownMenuItem(
                    child: Text('FROM AUDIO',style: Constants().txtStyleFont16(ColorsUsed.textBlueColor, 13.0)),
                    value: FileType.audio,
                    onTap: (){
                      _fileType = 3;
                      print(_fileType);
                    },
                  ),
                  DropdownMenuItem(
                    child: Text('FROM IMAGE',style: Constants().txtStyleFont16(ColorsUsed.textBlueColor, 13.0)),
                    value: FileType.image,
                    onTap: (){
                      _fileType = 1;
                      print(_fileType);
                    },
                  ),
                  DropdownMenuItem(
                    child: Text('FROM VIDEO',style: Constants().txtStyleFont16(ColorsUsed.textBlueColor, 13.0)),
                    value: FileType.video,
                    onTap: (){
                      _fileType = 2;
                      print(_fileType);
                    },
                  ),
                  DropdownMenuItem(
                    child: Text('Other',style: Constants().txtStyleFont16(ColorsUsed.textBlueColor, 13.0)),
                    value: FileType.custom,
                    onTap: (){
                      setState(() {
                        _extension = "pdf";
                      });
                      _fileType = 4;
                      print(_fileType);
                    },
                  ),
                ],
                onChanged: (value) => setState(() {
                  _pickingType = value;
                  _openFileExplorer(value);
                  if (_pickingType != FileType.custom) {
                    _controller.text = _extension = '';
                  }
                })),
          ),
        ),
      ),
    );
  }



  _submitData() async{
    if(folderController.text.isNotEmpty){
      if(folderController.text.length<11){
        FilePageApi().renameFolder(widget.id,folderController.text, context).then((value){
          Navigator.pop(context);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyFiles()));
          folderController.clear();
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

  _listFiles() {
    if(getFileListPOJO.fileList != null){
      return Expanded(
          child: ListView.builder(
              itemCount: getFileListPOJO.fileList.length,
              itemBuilder: (context, i) {
                return Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: (){
                        launch(Constants.ImageBaseUrl+getFileListPOJO.fileList[i].url);
                      },
                      child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                          child: Container(
                            width: Constants().containerWidth(context),
                            padding: EdgeInsets.all(15.0),
                            child: Row(
                              children: [
                                Expanded(child: Text(getFileListPOJO.fileList[i].fileName),),
                                SizedBox(width: 20.0),
                                IconButton(icon: Icon(Icons.close),onPressed: (){
                                  _deleteFileConfirmation(i);
                                },)
                              ],
                            ),
                          )),
                    ),
                    SizedBox(height: 10.0),
                  ],
                );
              }));
    }else{
      return Text("Folder is Empty");
    }

  }

}

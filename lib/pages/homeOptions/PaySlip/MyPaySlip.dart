import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:newproject/Interfaces/callBackWidget.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/Images_path.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/Utiles/strings.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';

class MyPaySlip extends StatefulWidget {
  @override
  _MyPaySlipState createState() => _MyPaySlipState();
}

class _MyPaySlipState extends State<MyPaySlip> implements WidgetCallBack{
  String year;String month;
  int monthId;
  List<String> monthList = ["January","February", "March","April","May","June",
    "July","August", "September","October","November","December"];
  List<String> yearList = ["2019","2020","2021"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarOptions(),
      body: Stack(
        children: [
          Container(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25.0),
                    bottomRight: Radius.circular(25.0),
                  ),
                  child: Container(
                    padding: EdgeInsets.only(top: Constants().containerHeight(context)*0.0),
                    height: Constants().containerHeight(context)/5.5,
                    width: Constants().containerWidth(context),
                    color: ColorsUsed.baseColor,
                  ),
                ),
               Container(padding: EdgeInsets.fromLTRB(25.0, Constants().containerHeight(context)*0.15,
                   25.0, 10),
                 child: Column(
                   children: [
                     Row(
                       children: [
                         Image.asset(Img.calendarImagepay), SizedBox(width: 15.0,),
                         Expanded(child: monthDropDown()),
                         SizedBox(width: 15.0,),
                         Text("-"),
                         SizedBox(width: 15.0,),
                         Image.asset(Img.calendarImagepay),
                         SizedBox(width: 15.0,),
                         Expanded(child: yearDropDown())
                       ],
                     ),
                     SizedBox(height: Constants().containerWidth(context)*0.1),
                     Row(
                       children: [SizedBox(width: Constants().containerWidth(context)*0.1),
                         Expanded(child: Constants().buttonRaised(context, ColorsUsed.baseColor, S.download, this)),
                         SizedBox(width: Constants().containerWidth(context)*0.1),],
                     )
                   ],
                 ),

               )
              ],
            ),
          ),
          Align(
            alignment: Alignment(0.0,-1.0),
            heightFactor: 0.1,
            child: Image.asset("Images/payslipLogo.png",
              width: Constants().containerHeight(context)*0.3,),
          )
        ],
      ),
    );
  }

  //AppBAr
  _appBarOptions() {
    return AppBar(
      backgroundColor: ColorsUsed.baseColor,
      centerTitle: true,elevation: 0.0,
      title: Row(
        children: [SizedBox(width: 35.0),
          Image.asset(Img.myOfficeImage,width: 20.0,),
          SizedBox(width: 10.0),
          Text("My Pay slip",
            style: Constants().txtStyleFont16(ColorsUsed.whiteColor,18.0),
          ),
        ],
      ),
    );
  }

  //month list
  Widget monthDropDown(){
    return DropdownButton<String>(
      hint: Text("Month"),
      isExpanded: false,
      value: month,
      onChanged: (String newValue) {
        setState(() {
          month = newValue;
        });
        _convertMonth(newValue);
      },
      items:monthList
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  //yesrList
  Widget yearDropDown(){
    return DropdownButton<String>(
      hint: Text("Year"),
      isExpanded: false,
      value: year,
      onChanged: (String newValue) {
        setState(() {
          year = newValue;
        });
      },
      items:yearList
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  @override
  void callBackInterface(String title) {
    switch(title){
      case S.download:
        if(month!=null){
          if(year!=null){
            _getPaySlip();
          }else{
            Constants.showToast("Enter year");
          }
        }else{
          Constants.showToast("Enter month");
        }
        break;
    }
  }

  _convertMonth(String _month){
    switch(_month){
      case "January":
        setState(() {
          monthId = 1;
        });
        break;
      case "February":
        setState(() {
          monthId = 2;
        });
        break;
      case "March":
        setState(() {
          monthId = 3;
        });
        break;
        case "April":
        setState(() {
          monthId = 4;
        });
        break;
      case "May":
        setState(() {
          monthId = 5;
        });
        break;
      case "June":
        setState(() {
          monthId = 6;
        });
        break;
      case "July":
        setState(() {
          monthId = 7;
        });
        break;
      case "August":
        setState(() {
          monthId = 8;
        });
        break;
      case "September":
        setState(() {
          monthId = 9;
        });
        break;
      case "October":
        setState(() {
          monthId = 10;
        });
        break;
      case "November":
        setState(() {
          monthId = 11;
        });
        break;
      case "December":
        setState(() {
          monthId = 12;
        });
        break;
    }
  }

  Future<dynamic> _getPaySlip() async{
    var loader = Constants.loader(context);
    await loader.show();
    var _response;
    print("${Constants.BaseUrl}action=paySlip&userId=${Constants.userId}&"
        "year=$year&month=$monthId");
    try{
      await http.get("${Constants.BaseUrl}action=paySlip&userId=${Constants.userId}&"
          "year=$year&month=$monthId").then((res){
        print(res.body);
        print("status${res.body}");
        setState(() {

           _response = json.decode(res.body);
//          responseList = _response["task"];

        });
        final int statusCode = res.statusCode;
        print(statusCode);
        if (statusCode == 200) {
          print("check 200${_response["pdfLink"]}");
          loader.hide();
          if(_response["success"]==1){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ViewPdf(_response["pdfLink"]),));
          }else{
            Constants.showToast("No related data Found");
          }
          }else{
//            Scaffold.of(context).showSnackBar(Constants().showSnackMessage(response["message"]));
          }
      });}on SocketException catch (_) {
      print('not connected');
      Constants().noInternet(context);
    }catch (e) {
    }
  }



}

class ViewPdf extends StatefulWidget {
  final doc;
  const ViewPdf(this.doc);
  @override
  _ViewPdfState createState() => _ViewPdfState();
}

class _ViewPdfState extends State<ViewPdf> {
  PDFDocument document;
  @override
  void initState() {
    // TODO: implement initState
    _msm();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: document == null?Center(child: CircularProgressIndicator(),):
      PDFViewer(document: document,
      zoomSteps: 1,),);
  }

  _msm()  async{
    var dd = await PDFDocument.fromURL(
      widget.doc,
    );
   setState(() {
     document = dd;
   });
   return document;
  }
}


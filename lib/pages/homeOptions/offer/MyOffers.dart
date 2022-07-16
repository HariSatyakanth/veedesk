import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/Images_path.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/Utiles/strings.dart';
import 'package:newproject/common/FilePageAPi.dart';
import 'package:newproject/models/MyOffersPojo.dart';
import 'package:url_launcher/url_launcher.dart';

class MyOffers extends StatefulWidget {
  @override
  _MyOffersState createState() => _MyOffersState();
}

class _MyOffersState extends State<MyOffers> {
  int _colorId = 0;
  bool _loader = false;
  MyoffersPojo myoffersPojo = MyoffersPojo();
  List<MyoffersList> _openOffersList  = List<MyoffersList>();
  List<MyoffersList> _usedOffersList  = List<MyoffersList>();
  List<MyoffersList> _expiredOffersList  = List<MyoffersList>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOffersList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Constants().containerHeight(context)*0.4),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft:Radius.circular(35.0),bottomRight: Radius.circular(35.0),
              ),
              child: AppBar(elevation: 0.0,
                leading: IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.chevron_left,size: 30.0,color: Colors.black,),
                ),
                title: Row(
                  children: [SizedBox(width: 35.0),
                    CircleAvatar(child: Image.asset(Img.myOfficeImage,width: 20.0,),radius: 15.0,
                      backgroundColor: Colors.black,),
                    SizedBox(width: 10.0),
                    Text(S.myOffers,
                      style: Constants().txtStyleFont16(Colors.black,20.0),),
                  ],
                ),
                centerTitle: true,
                flexibleSpace:  Container(
                  decoration:
                  BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(Img.platformImage),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0.0, 0.2),
              child: Image.asset(Img.giftImage,width: Constants().containerWidth(context)*0.4,),
            ),
          ],
        ),
      ),
      body: Container(padding: EdgeInsets.fromLTRB(10.0,10.0,10.0,0.0,),
        child: Column(
          children: [
            _cardWithButton(),
            SizedBox(height: 30.0),
            _listOfOffers()

          ],
        ),
      )
    );
  }

  _cardWithButton() {
    return Container(
      child: Row(
        children: [
          Expanded(child: _button(S.OPEN, 0)),
          Expanded(child: _button(S.CLOSED, 1)),
          Expanded(child: _button(S.EXPIRED, 2)),
        ],
      ),
    );
  }

  _button(String title, int id) {
    return SizedBox(
      height: Constants().containerHeight(context) / 16,
      child: RaisedButton(
        onPressed: () {
          _clickOperation(title);
        },
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        elevation: 0.0,
        color: _colorId == id ? Colors.green : Colors.transparent,
        child: Text(title,
            style: TextStyle(
                fontSize: 16.0,
                color: _colorId == id ? ColorsUsed.whiteColor : Colors.black,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w500)),
      ),
    );
  }

  _clickOperation(String title) {
    switch (title) {
      case S.OPEN:
        _loader = true;
        Timer(Duration(seconds: 2), () {
          setState(() {
            _loader = false;
          });
        });
        setState(() {
          _colorId = 0;
        });
        break;
      case S.CLOSED:
        _loader = true;
        Timer(Duration(seconds: 2), () {
          setState(() {
            _loader = false;
          });
        });
        setState(() {
          _colorId = 1;
        });
        break;
      case S.EXPIRED:
        _loader = true;
        Timer(Duration(seconds: 2), () {
          setState(() {
            _loader = false;
          });
        });
        setState(() {
          _colorId = 2;
        });
        break;
    }
  }

  getOffersList() async{
    var loader = Constants.loader(context);
    await loader.show();
    try{
      var response = await FilePageApi().getRequest("myoffersList&userId=${Constants.userId}",context);
      var responseList = await json.decode(response.body);
      print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.body);
        loader.hide();
        setState((){
          myoffersPojo = MyoffersPojo.fromJson(json.decode(response.body));
        });

        for(int i=0;i<myoffersPojo.myoffersList.length;i++){
          print("Offer ${myoffersPojo.myoffersList.length}");
          if(myoffersPojo.myoffersList[i].cupponStatus==S.OPEN_OFFERS){
            setState(() {
              _openOffersList.add(myoffersPojo.myoffersList[i]);
            });
          }else if(myoffersPojo.myoffersList[i].cupponStatus==S.USED_OFFERS){
            setState(() {
              _usedOffersList.add(myoffersPojo.myoffersList[i]);
            });
          }else if(myoffersPojo.myoffersList[i].cupponStatus==S.EXPIRED_OFFERS){
            setState(() {
              _expiredOffersList.add(myoffersPojo.myoffersList[i]);
            });
          }
        }
      }

      else{
        Constants.showToast(responseList["error"]);
      }
    }on SocketException {
      Constants().noInternet(context);
    }
  }

  _listOfOffers() {
    switch(_colorId){
      //0 is open, 1 is used, 2 is expired
      case 0:
        if(_openOffersList.length!=0){
          return Expanded(
            child: GridView.builder(
                itemCount: _openOffersList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemBuilder: (BuildContext context, int i) {
                  return InkWell(
                    onTap: (){
                      _showOfferDetails(i);
                    },
                    child: Card(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                      child: Column(
                        children: [
                          SizedBox(height: 3.0,),
                          _openOffersList[i].cupponImage==null?Image.asset(Img.offerImage,height: Constants().containerWidth(context)*0.2):
                          Image.network(_openOffersList[i].cupponImage,height: Constants().containerWidth(context)*0.2,),
                          SizedBox(height: 10.0),
                          SizedBox(width: 15.0),
                          Text(_openOffersList[i].offerName,style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(width: 15.0),
                          Row(
                            children: [SizedBox(width: 15.0),
                              Text("valid till: "+_openOffersList[i].cupponDate,style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey),),
                              SizedBox(width: 15.0),],
                          ),
                        ],
                      ),
                    ),
                  );
                }
            ),
          );
        }else{
          return Center(child: Text("No coupons"),);
        }
        break;
      case 1:
        if(_usedOffersList.length!=0){
          return Expanded(
            child: GridView.builder(
                itemCount:  _usedOffersList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemBuilder: (BuildContext context, int i) {
                  return InkWell(
                    onTap: (){
                      Constants.showToast("This coupon is already used");
                    },
                    child: Card(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                      child: Column(
                        children: [
                          SizedBox(height: 3.0,),
                          _usedOffersList[i].cupponImage==null?Image.asset(Img.offerImage,height: Constants().containerWidth(context)*0.2):
                          Image.network(_usedOffersList[i].cupponImage,height: Constants().containerWidth(context)*0.2,),
                          SizedBox(height: 10.0),
                          SizedBox(width: 15.0),
                          Text(_usedOffersList[i].offerName,style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(width: 15.0),
                          Row(
                            children: [SizedBox(width: 15.0),
                              Text("Used on: "+_usedOffersList[i].cupponDate,style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey),),
                              SizedBox(width: 15.0),],
                          ),
                        ],
                      ),
                    ),
                  );
                }
            ),
          );
        }else{
          return Center(child: Text("No coupons"),);
        }
        break;
      case 2:
        if(_expiredOffersList.length!=0){
          return Expanded(
            child: GridView.builder(
                itemCount: _expiredOffersList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemBuilder: (BuildContext context, int i) {
                  return InkWell(
                    onTap: (){
                      Constants.showToast("This coupon is expired");
                    },
                    child:Card(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                      child: Column(
                        children: [
                          SizedBox(height: 3.0,),
                          _expiredOffersList[i].cupponImage==null?Image.asset(Img.offerImage,height: Constants().containerWidth(context)*0.2):
                          Image.network(_expiredOffersList[i].cupponImage,height: Constants().containerWidth(context)*0.2,),
                          SizedBox(height: 10.0),
                          SizedBox(width: 15.0),
                          Text(_expiredOffersList[i].offerName,style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(width: 15.0),
                          Row(
                            children: [SizedBox(width: 15.0),
                              Text("Expired : "+_expiredOffersList[i].cupponDate,style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey),),
                              SizedBox(width: 15.0),],
                          ),
                        ],
                      ),
                    ),
                  );
                }
            ),
          );
        }else{
          return Center(child: Text("No coupons"),);
        }

        break;
    }
  }

   _showOfferDetails(int i) {
    return  showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Offer Details"),
            content: Container(
              height: Constants().containerWidth(context)*0.5,
              decoration: BoxDecoration(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Constants.selectedFontWidget(_openOffersList[i].offerName, ColorsUsed.textBlueColor,
                      16.0, FontWeight.bold),
                  Constants.selectedFontWidget("valid till: "+_openOffersList[i].cupponDate, ColorsUsed.textBlueColor,
                      16.0, FontWeight.bold),
                  InkWell(
                    onTap: (){
                      launch(_openOffersList[i].cupponSite);
                    },
                    child: RichText(
                      text: TextSpan(text: "To avail offer visit: ",
                          style: Constants().txtStyleFont16(ColorsUsed.textBlueColor, 16.0),
                          children: [
                            TextSpan(text: _openOffersList[i].cupponSite,style: Constants().txtStyleFont16(Colors.blue, 13.0))
                          ]  ),
                    ),
                  ),
                  Row(
                    children: [
                      Constants.selectedFontWidget(_openOffersList[i].cupponCode, ColorsUsed.textBlueColor,
                          16.0, FontWeight.bold),
                      SizedBox(width: 10.0),
                      IconButton(
                          icon: Icon(Icons.copy_outlined),
                          onPressed: (){
                            FlutterClipboard.copy(_openOffersList[i].cupponCode).then((value) {
                              Constants.showToast("Copied to clipboard");
                              Navigator.pop(context);
                            });
                          })
                    ],
                  )
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                //Click on yes to perform operation according to use
                onPressed: () {
                  Navigator.pop(context);
                },
                child: new Text('Go Back',style: TextStyle(color: ColorsUsed.textBlueColor,fontWeight: FontWeight.w500),),
              ),
            ],
          );
        });
   }


}

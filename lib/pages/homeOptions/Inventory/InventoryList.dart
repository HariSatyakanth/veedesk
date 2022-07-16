import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:newproject/Interfaces/callBackWidget.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/Images_path.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/Utiles/strings.dart';
import 'package:newproject/pages/homeOptions/Inventory/AddInventory.dart';
import 'package:newproject/models/InventoryPojo.dart';

class InventoryList extends StatefulWidget {
  @override
  _InventoryListState createState() => _InventoryListState();
}

class _InventoryListState extends State<InventoryList> implements WidgetCallBack{
  bool _loader = false;
  int selectedList = -1;
  var searchController = TextEditingController();
  var responseList;
  bool editInventory = false;
  int inventoryCount;
  TextEditingController inventoryCountController;
  InventoryPojo inventoryPojo = InventoryPojo();
  InventoryPojo mainInventoryPojo = InventoryPojo();
  String categoryName,itemName,qty,status,imageUrl,inventoryDate,remark,inventoryId;

  @override
  void initState(){
    super.initState();
    inventoryList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddInventory())).then((value) => inventoryList());
        },
        child: Icon(Icons.add),
      ),
      appBar: _appBarOptions(),
      body: /*inventoryPojo.inventoryList==null*/_loader?Center(child: CircularProgressIndicator(),):Stack(
        children: [
          Container(padding: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 20.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*_searchBar(),
                SizedBox(height: 20.0,),*/
             Constants.selectedFontWidget("Transactions", ColorsUsed.textBlueColor,
                 20.0, FontWeight.bold),


                SizedBox(height: 20.0,),
                searchTab(),
                Expanded(
                  child: ListView.builder(
                    itemCount: inventoryPojo.inventoryList.length,
                    itemBuilder: (context,i){
                      return InkWell(
                        onTap: () {
                          if(selectedList == i) {
                            setState(() {
                              editInventory = false;
                              selectedList = -1;
                            });
                          }else{
                            setState(() {
                              editInventory = false;
                              selectedList = i;
                            });
                          }
                        },
                        child: Container(padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                          margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                          decoration: BoxDecoration(color: selectedList == i?Color(0xffF0EFFF):Color(0xffFFFFFF),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Row(
                            children: [
                              Container(padding: EdgeInsets.all(5.0),
                                height:50.0,
                                width:50.0,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(color: Colors.grey)),
                                child: inventoryPojo.inventoryList[i].imageUrl=="null"?
                                Image.asset(Img.noImage,width: 40.0,):Image.network(Constants.ImageBaseUrl+inventoryPojo.inventoryList[i].imageUrl),
                              ),
                              SizedBox(width: 20.0),
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Constants.selectedFontWidget(inventoryPojo.inventoryList[i].categoryName, ColorsUsed.textBlueColor,
                                            15.0, FontWeight.bold),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Constants.selectedFontWidget(inventoryPojo.inventoryList[i].inventoryDate, Colors.grey,
                                            15.0, FontWeight.w400),
                                      ],
                                    ),
                                    selectedList == i?
                                    Row(
                                      children: [
                                        _inventoryDetails(i)
                                      ],
                                    ):Container(),
                                    SizedBox(width: 20.0),
                                  ],
                                ),
                              ),
                              Constants.selectedFontWidget(inventoryPojo.inventoryList[i].qty, Colors.red,
                                  15.0, FontWeight.w500)
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
          /*Align(
            alignment: Alignment(0.89,0.7),
            child: FloatingActionButton(
              //heroTag is used to differentiate between two FAB
              heroTag: "1",
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddInventory()));
              },backgroundColor: Colors.red,
              child: Icon(Icons.remove),
            ),
          )*/
        ],
      )
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
          title: Row(
            children: [SizedBox(width: 35.0),
              Image.asset(Img.myOfficeImage,width: 20.0,),
              SizedBox(width: 10.0),
              Text("My Inventory",
                style: Constants().txtStyleFont16(ColorsUsed.whiteColor,20.0),),
            ],
          ),
        ),
      ),
      preferredSize: Size.fromHeight(Constants().containerHeight(context)*0.08),
    );
  }

  _searchBar() {
    return Card(elevation: 5.0,
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
    );
  }

  Future<dynamic> inventoryList() async{
    setState(() {
      _loader= true;
    });
    try{
      await http.get("${Constants.BaseUrl}action=inventoryList"
      ).then(( res) {
        print("hello");
        print(res.body);
        var response = json.decode(res.body);
        final int statusCode = res.statusCode;
        print(statusCode);
        if (statusCode == 200) {
          print("its working 200");
          if(response["success"] == "1"){
            print("in success");
            setState(() {
              _loader= false;
              inventoryPojo = InventoryPojo.fromJson(response);
              mainInventoryPojo = InventoryPojo.fromJson(response);
            });print("responseList${inventoryPojo.inventoryList[0].imageUrl}");
          }else{
            setState(() {
              _loader= false;
            });
            Constants.showToast(response["message"]);
          }
        }else{
          Scaffold.of(context).showSnackBar(Constants().showSnackMessage(response["Something went wrong !"]));

        }
      });}on SocketException catch (_) {
      print('not connected');
      Constants().noInternet(context);
    }catch (e) {
    }
  }

  _inventoryDetails(int i) {
    categoryName = inventoryPojo.inventoryList[i].categoryName;
    itemName = inventoryPojo.inventoryList[i].itemName;
    qty = inventoryPojo.inventoryList[i].qty;
    imageUrl = inventoryPojo.inventoryList[i].imageUrl;
    inventoryDate = inventoryPojo.inventoryList[i].inventoryDate;
    inventoryId = inventoryPojo.inventoryList[i].id;
    remark = inventoryPojo.inventoryList[i].remark;

    inventoryCountController = TextEditingController(text: inventoryPojo.inventoryList[i].qty);
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [SizedBox(height: 10.0,),
     Constants.selectedFontWidget("Item Name", ColorsUsed.textBlueColor,
        15.0, FontWeight.bold),
        Constants.selectedFontWidget(inventoryPojo.inventoryList[i].itemName, Colors.grey,
            15.0, FontWeight.w400),
        SizedBox(height: 10.0,),
        Constants.selectedFontWidget("Description", ColorsUsed.textBlueColor,
            15.0, FontWeight.bold),
        Row(
          children: [
            Container(
              width: Constants().containerWidth(context)*0.5,
              child: Constants.selectedFontWidget(inventoryPojo.inventoryList[i].remark, Colors.grey,
                  15.0, FontWeight.w400),
            ),
          ],
        ),
        Divider(color: ColorsUsed.textBlueColor,),
        SizedBox(height: 10.0,),
        editInventory?updateInventory(i):Row(
          children: [
            IconButton(
                icon: Icon(Icons.edit),
                color: ColorsUsed.baseColor,
                onPressed: (){
                  setState(() {
                    editInventory = true;
                  });
                }),
            IconButton(
                icon: Icon(Icons.delete),
                color: ColorsUsed.googleButton,
                onPressed: (){
                  Constants.popUpFortwoOptions(context,
                      S.DELETE_INVENTORY, "Alert!", this);

                }),

          ],
        ),
        SizedBox(height: 10.0),
        editInventory?Row(
          children: [
            InkWell(child: Constants.selectedFontWidget("Update", Colors.green,
                15.0, FontWeight.bold),
                onTap: (){
              if(inventoryCountController.text.isNotEmpty){
                updateInventoryApi(context);
              }else{
                Constants.showToast("Enter quantity");
              }
                }),SizedBox(width: 10.0),
            InkWell(child: Constants.selectedFontWidget("Cancel", Colors.red,
                15.0, FontWeight.bold),
                onTap: (){
              setState(() {
                editInventory = false;
              });
                })
          ],
        ):Container()

      ],
    );
  }

  updateInventory(int i){
    return Container(
      height: 50,width: 150,
        /*decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0),
            color: ColorsUsed.baseColor),*/
        child:/*Row(
          children: [
            IconButton(
              onPressed: (){
                setState(() {
                  inventoryCount++;
                });
              },
              icon: Icon(Icons.add,color: Colors.white),),
            Container(height: 25.0,width: 2.0,color: Colors.white,),
            SizedBox(width: 10.0,),
            Text(inventoryCount.toString()*//*inventoryPojo.inventoryList[i].qty*//*,style: TextStyle(color: Colors.white),),
            SizedBox(width: 10.0,),
            Container(height: 25.0,width: 2.0,color: Colors.white,),
            IconButton(
              onPressed: (){
                if(inventoryCount>1){
                  setState(() {
                    inventoryCount--;
                  });
                }
              },
              icon: Icon(Icons.remove,color: Colors.white),),
          ],
        )*/
        TextField(
          controller: inventoryCountController,
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(
                color:Colors.grey[300],width: 2.0),),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(
                color:ColorsUsed.baseColor,width: 2.0),),
            hintText: 'Enter qunatity',
//              isCollapsed: true,
          ),
          keyboardType: TextInputType.number,

        )
    );
  }

  Future<dynamic> updateInventoryApi(BuildContext context) async{
    setState(() {
      _loader= true;
    });print("${Constants.BaseUrl}action=inventoryUpdate&categoryName=${categoryName}&"
        "itemName=${itemName}&"
        "qty=$qty&status=1&imageUrl=${imageUrl}&id=$inventoryId"
        "remark= ${remark}&inventoryDate=${inventoryDate}");
    try{
      await http.get("${Constants.BaseUrl}action=inventoryUpdate&categoryName=${categoryName}&"
          "itemName=${itemName}&"
          "qty=${inventoryCountController.text}&status=1&imageUrl=${imageUrl}&id=$inventoryId"
          "remark= ${remark}&inventoryDate=${inventoryDate}"
      ).then(( res) {
        print("hello");
        print(res.body);
        var response = json.decode(res.body);
        final int statusCode = res.statusCode;
        print(statusCode);
        if (statusCode == 200) {
          print("its working 200");
          if(response["success"] == 1){
            print("in success");
            setState(() {
              _loader= false;
            });
            Constants.showToast(response["message"]);
            Navigator.pop(context,true);
          }else{
            setState(() {
              _loader= false;
            });
            Constants.showToast(response["message"]);
          }
        }else{
          Scaffold.of(context).showSnackBar(Constants().showSnackMessage(response["Something went wrong !"]));

        }
      });}on SocketException catch (_) {
      print('not connected');
      Constants().noInternet(context);
    }catch (e) {
    }
  }

  Future<dynamic> deleteInventoryApi() async{
    setState(() {
      _loader= true;
    });print("${Constants.BaseUrl}action=inventoryDelete&id=$inventoryId");
     try{
        await http.get("${Constants.BaseUrl}action=inventoryDelete&id=$inventoryId").then(( res) {
        print("hello");
        print(res.body);
        var response = json.decode(res.body);
        final int statusCode = res.statusCode;
        print(statusCode);
        if (statusCode == 200) {
          print("its working 200");
          if(response["success"] == 1){
            print("in success");
            setState(() {
              _loader= false;
            });
            Constants.showToast(response["message"]);
            Navigator.pop(context,true);
          }else{
            setState(() {
              _loader= false;
            });
            Constants.showToast(response["message"]);
          }
        }else{
          Scaffold.of(context).showSnackBar(Constants().showSnackMessage(response["Something went wrong !"]));

        }
      });}on SocketException catch (_) {
      print('not connected');
      Constants().noInternet(context);
    }catch (e) {
    }
  }

  @override
  void callBackInterface(String title) {
    switch(title){
      case S.DELETE_INVENTORY:
        deleteInventoryApi();
        break;
    }
  }

  searchTab() {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xFFCFD8DC),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          contentPadding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
          hintText: "Search...",
          prefixIcon: Icon(Icons.search)
      ),
      onChanged: (value){
        print(value);
        if(value.length>0) {
          setState(() {
            inventoryPojo.inventoryList=null;
            _searchactiveTaskLists(value);
          });


        }else{
          print("empy");
          setState(() {
            inventoryPojo.inventoryList=null;
            inventoryPojo =InventoryPojo.fromJson(mainInventoryPojo.toJson());
            // expensePOJO.expenseTrackerList.addAll(mainExpensePOJO.expenseTrackerList);
          });
        }
      },
    );
  }

  void _searchactiveTaskLists(String value) {
    inventoryPojo.inventoryList=mainInventoryPojo.inventoryList.where((c) => c.categoryName.contains(new RegExp(r'' + value, caseSensitive: false))).toList();
  }

}

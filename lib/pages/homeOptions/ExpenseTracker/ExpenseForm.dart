import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/Images_path.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/Utiles/util.dart';
import 'package:newproject/pages/homeOptions/ExpenseTracker/AddExpense.dart';
import 'package:newproject/pages/homeOptions/ExpenseTracker/ExpensePOJO.dart';

class ExpenseForm extends StatefulWidget {
  @override
  _ExpenseFormState createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  bool _loader = false;
  int selectedList = -1;
  var searchController = TextEditingController();
  ExpensePOJO expensePOJO = ExpensePOJO();
  ExpensePOJO mainExpensePOJO = ExpensePOJO();
  @override
  void initState() {
    super.initState();
    expenseList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddExpense())).then((value) => expenseList());
          },
          child: Icon(Icons.add),
        ),
        appBar: _appBarOptions(),
        body: _loader?Center(child: CircularProgressIndicator(),):Stack(
          children: [
            Container(padding: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 20.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            //      _searchBar(),
                SizedBox(height: 20.0,),
                  Constants.selectedFontWidget("Transactions", ColorsUsed.textBlueColor,
                      20.0, FontWeight.bold),
                  SizedBox(height: 20.0,),
                  searchTab(),
                  list()
                ],
              ),
            ),
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
              Text("Expense Tracker",
                style: Constants().txtStyleFont16(ColorsUsed.whiteColor,20.0),),
            ],
          ),
        ),
      ),
      preferredSize: Size.fromHeight(Constants().containerHeight(context)*0.08),
    );
  }

  Future<dynamic> expenseList() async{
    setState(() {
      _loader= true;
    });print("${Constants.BaseUrl}action=expenseTrackerList&userId=${Constants.userId}");
    try{
      await http.get("${Constants.BaseUrl}action=expenseTrackerList&userId=${Constants.userId}"
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
              expensePOJO = ExpensePOJO.fromJson(response);
              mainExpensePOJO = ExpensePOJO.fromJson(response);
            });print("responseList${expensePOJO.expenseTrackerList}");
          }else{
            setState(() {
              _loader= false;
            });
            expensePOJO.expenseTrackerList = null;
            Constants.showToast("No data found!");
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

  list() {
    if(expensePOJO.expenseTrackerList!=null){
      return Expanded(
        child: ListView.builder(
          itemCount: expensePOJO.expenseTrackerList.length,
          itemBuilder: (context,i){
            return InkWell(
              onTap: () {
                if(selectedList == i) {
                  setState(() {
                    selectedList = -1;
                  });
                }else{
                  setState(() {
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
                        child: Image.asset(Img.noImage,width: 40.0,)
                    ),
                    SizedBox(width: 20.0),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Constants.selectedFontWidget(expensePOJO.expenseTrackerList[i].productName, ColorsUsed.textBlueColor,
                                  15.0, FontWeight.bold),
                            ],
                          ),
                          Row(
                            children: [
                              Constants.selectedFontWidget(Util.changeDateToFormetted(expensePOJO.expenseTrackerList[i].dateTime), Colors.grey,
                                  15.0, FontWeight.w400),
                            ],
                          ),
                          selectedList == i?
                          Row(
                            children: [
//                                          _inventoryDetails(i)
                            ],
                          ):Container(),
                          SizedBox(width: 20.0),
                        ],
                      ),
                    ),
                    Constants.selectedFontWidget("\$"+expensePOJO.expenseTrackerList[i].amount, Colors.red,
                        15.0, FontWeight.w500)
                  ],
                ),
              ),
            );
          },
        ),
      );
    }else{
      return Center(child: Text("Data not found"));
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
            expensePOJO.expenseTrackerList=null;
            _searchactiveTaskLists(value);
          });


        }else{
          print("empy");
          setState(() {
            expensePOJO.expenseTrackerList=null;
            expensePOJO =ExpensePOJO.fromJson(mainExpensePOJO.toJson());
           // expensePOJO.expenseTrackerList.addAll(mainExpensePOJO.expenseTrackerList);
          });
        }
      },
    );
  }

  void _searchactiveTaskLists(String value) {
    expensePOJO.expenseTrackerList=mainExpensePOJO.expenseTrackerList.where((c) => c.productType.contains(new RegExp(r'' + value, caseSensitive: false))).toList();
  }
}

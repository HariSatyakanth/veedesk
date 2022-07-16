import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:newproject/Interfaces/callBackWidget.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/Images_path.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/Utiles/strings.dart';
import 'package:newproject/models/RolePojo.dart';

class AddExpense extends StatefulWidget {
  @override
  _AddExpenseState createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> implements WidgetCallBack {
  final TextEditingController _AmountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime selectedDate;

  DateTime selectedEndDate;

  String inventoryDropdownValue="0";
  String productName="";
  File _image;
  List<Role> roleList;
  Role roleDropdownValue;
  bool _loader = true;
  String uploadedImagePath;
  static var imageController =
      TextEditingController(text: "Related document(if any)");
  int inventoryCount = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    roleList = new List<Role>();
    getRole(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarOptions(),
      body: _loader
          ? Center(
              child: Constants().spinKit,
            )
          : SingleChildScrollView(
              child: Stack(
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
                            padding: EdgeInsets.only(
                                top:
                                    Constants().containerHeight(context) * 0.0),
                            height: Constants().containerHeight(context) / 5.5,
                            width: Constants().containerWidth(context),
                            color: ColorsUsed.baseColor,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(
                              25.0,
                              Constants().containerHeight(context) * 0.15,
                              25.0,
                              10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    Img.inventoryListImage,
                                    width: 20.0,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Expanded(child: stationaryDropDown()),
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    Img.amountImage,
                                    width: 20.0,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Expanded(
                                    child: Constants
                                        .commonEditTextFieldWithoutIcon(
                                            _AmountController,
                                            false,
                                            "Amount",
                                            "",
                                            TextInputType.number),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.0),
                              Constants.descriptionField(
                                  context,
                                  "Add description",
                                  "",
                                  _descriptionController,
                                  null,
                                  null),
                              SizedBox(
                                  height: Constants().containerWidth(context) *
                                      0.1),
                              Row(
                                children: [
                                  SizedBox(
                                      width:
                                          Constants().containerWidth(context) *
                                              0.1),
                                  Expanded(
                                      child: Constants().buttonRaised(
                                          context,
                                          ColorsUsed.baseColor,
                                          S.submit,
                                          this)),
                                  SizedBox(
                                      width:
                                          Constants().containerWidth(context) *
                                              0.1),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment(0.0, -1.0),
                    heightFactor: 0.1,
                    child: Image.asset(
                      Img.addExpense,
                      width: Constants().containerHeight(context) * 0.3,
                    ),
                  )
                ],
              ),
            ),
    );
  }

  //AppBAr
  _appBarOptions() {
    return AppBar(
      backgroundColor: ColorsUsed.baseColor,
      centerTitle: true,
      elevation: 0.0,
      title: Row(
        children: [
          SizedBox(width: 25.0),
          Image.asset(
            Img.myOfficeImage,
            width: 20.0,
          ),
          SizedBox(width: 10.0),
          Text(
            "Expense Form",
            style: Constants().txtStyleFont16(ColorsUsed.whiteColor, 18.0),
          ),
        ],
      ),
    );
  }

  // list
  Widget stationaryDropDown() {
    return DropdownButton<Role>(
      hint: Text("Inventory Type"),
      isExpanded: true,
      value: roleDropdownValue,
      onChanged: (Role newValue) {
        setState(() {
          inventoryDropdownValue = newValue.id;
          productName=newValue.role;
          roleDropdownValue = newValue;

        });
      },
      items: roleList.map<DropdownMenuItem<Role>>((Role value) {
        return DropdownMenuItem<Role>(
          value: value,
          child: Text(value.role),
        );
      }).toList(),
    );
  }

  @override
  void callBackInterface(String title) {
    switch (title) {
      case "Submit":
        validation();
        break;
    }
  }

  Future<dynamic> updateInventory(BuildContext context) async {
    setState(() {
      _loader = true;
    });
    print(
        "${Constants.BaseUrl}action=inventoryInsert&userId= ${Constants.userId}&"
        "categotyId=${inventoryDropdownValue}&categoryName=${inventoryDropdownValue}&itemName=${_AmountController.text}&"
        "qty=$inventoryCount&productName=$productName&status=1&imageUrl=${uploadedImagePath}&"
        "remark= ${_descriptionController.text}&inventoryDate=${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}");
    try {
      //&userId=8&productType=HJHKH&amount=898&description=JJJLJ&date_time=2021-01-03%2023:35:00
      await http
          .get(
              "${Constants.BaseUrl}action=expenseTrackerInsert&userId= ${Constants.userId}&"
              "productType=$inventoryDropdownValue&productName=$productName&status=1&amount=${_AmountController.text}&"
              "description= ${_descriptionController.text}&date_time=${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}")
          .then((res) {
        print("hello");
        print(res.body);
        var response = json.decode(res.body);
        final int statusCode = res.statusCode;
        print(statusCode);
        if (statusCode == 200) {
          print("its working 200");
          if (response["success"] == 1) {
            print("in success");
            setState(() {
              _loader = false;
            });
            Constants.showToast(response["message"]);
            Navigator.pop(context, true);
          } else {
            setState(() {
              _loader = false;
            });
            Constants.showToast(response["message"]);
          }
        } else {
          Scaffold.of(context).showSnackBar(
              Constants().showSnackMessage(response["Something went wrong !"]));
        }
      });
    } on SocketException catch (_) {
      print('not connected');
      Constants().noInternet(context);
    } catch (e) {}
  }

  validation() async {
    if (inventoryDropdownValue != null) {
      if (_AmountController.text.isNotEmpty) {
        if (_descriptionController.text.isNotEmpty) {
          if(inventoryDropdownValue != "0") {
            updateInventory(context);
          }else{
            Constants.showToast("Please add category");
          }
        } else {
          Constants.showToast("Please add proper description");
        }
      } else {
        Constants.showToast("Please add amount");
      }
    } else {
      Constants.showToast("Please select inventory type");
    }
  }

  //get Role details
  Future<dynamic> getRole(BuildContext context) async {
    Role role = Role(id: "0", role: "----Select category-----*");
    setState(() {
      roleDropdownValue = role;
      roleList.add(role);
    });
    try {
      await http
          .get("${Constants.BaseUrl}action=expenseCategoryList")
          .then((res) {
        print(res.body);
        var response = json.decode(res.body);
        final int statusCode = res.statusCode;
        print(statusCode);
        if (statusCode == 200) {
          loaderOnOff(false);
          print("its working 200");
          if (response["success"] == "1") {
            /*Role rolePojo= Role.fromJson(json.decode(res.body));*/
            for (int i = 0; i < response["expenseCategoryList"].length; i++) {
              Role role = Role(
                  id: response["expenseCategoryList"][i]["id"],
                  role: response["expenseCategoryList"][i]["expenseName"]);
              setState(() {
                roleList.add(role);
              });
            }
          }
        } else {
          loaderOnOff(false);
//          Scaffold.of(context).showSnackBar(Constants().showSnackMessage(response["Something went wrong !"]));
        }
      });
    } on SocketException catch (_) {
      print('not connected');
      loaderOnOff(false);
      Constants().noInternet(context);
    } catch (e) {
      loaderOnOff(false);
    }
  }
  loaderOnOff(bool value){
    setState(() {
      _loader=value;
    });
  }
}

import 'package:flutter/material.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/Images_path.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/Utiles/util.dart';
import 'package:newproject/common/GraphPageApis.dart';

class KPICharts extends StatefulWidget {
  @override
  _KPIChartsState createState() => _KPIChartsState();
}

class _KPIChartsState extends State<KPICharts> {
  List _optionList = ["Claims","Worklog","Expenses","Tickets","Leaves"];
  int _colorId = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(Util.formatDate(DateTime.now()));
//    Util.convertCompleteDate(DateTime.parse("2031-01-20"));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarOptions(),
        body: SingleChildScrollView(
          child: Container(padding: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 20.0),
            child: Column(
              children: [
                Container(height: 45.0,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _optionList.length,
                      itemBuilder: (ctx,i){
                        return Row(
                          children: [SizedBox(width: 20.0),
                            SizedBox(height: 30.0,
                              child: RaisedButton(
                                onPressed: (){
                                  setState(() {
                                    _colorId = i;
                                  });
                                },color: _colorId == i?ColorsUsed.baseColor:Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                child: Text(_optionList[i],
                                  style: Constants().txtStyleFont16(_colorId == i?Colors.white:
                                  ColorsUsed.baseColor, 13.0),),
                              ),
                            ),
                          ],
                        );
                      }),
                ),
                _graphDetailsForSpecificOption()
              ],
            ),
          ),
        )
    );
  }

  //this contains the data which graph page w have to show
  _graphDetailsForSpecificOption() {
    switch(_colorId){
    //0 is the id for claims graphs
      case 0:
//        return attendanceGraphs();
        return Container();
        break;
    //1 is the id for worklog graphs
      case 1:
        GraphPageApis().workLogGraph(userID: Constants.userId,context: context,date: Util.formatDate(DateTime.now()));
//        return taskGraphs();
        return Container();
        break;
    //2 is the id for expenses graphs
      case 2:
//        GraphPageApis().leadsGraph(context: context,userID: Constants.userId,month: "10");
//        return leadGraphs();
        return Container();
        break;
    //3 is the id for tickets graphs
      case 3:
//        return queriesGraphs();
        return Container();
        break;
    //4 is the id for leaves graphs
      case 4:
//        return fileGraphs();
        return Container();
        break;
      default:
        return Container();
    }
  }


  _appBarOptions() {
    return PreferredSize(
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(40.0),
          bottomLeft: Radius.circular(40.0),
        ),
        child: AppBar(backgroundColor: ColorsUsed.baseColor,
//           leading: Constants().backButton(context),
          centerTitle: true,
          title: Row(
            children: [SizedBox(width: 35.0),
              Image.asset(Img.myOfficeImage,width: 20.0),
              SizedBox(width: 10.0,),
              Text(
                "My Graphs",
                style: Constants().txtStyleFont16(ColorsUsed.whiteColor, 20.0),
              ),
            ],
          ),
        ),
      ),
      preferredSize: Size.fromHeight(Constants().containerHeight(context)*0.08),
    );
  }
}

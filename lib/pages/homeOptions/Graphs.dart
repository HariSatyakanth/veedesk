import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/Utiles/Images_path.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:newproject/common/GraphPageApis.dart';
import 'package:http/http.dart' as http;
import 'package:newproject/models/CommonGraphModel.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Graphs extends StatefulWidget {
  @override
  _GraphsState createState() => _GraphsState();
}

class _GraphsState extends State<Graphs> {
  List<charts.Series> seriesList;
  bool animate;
  List _optionList = ["Attendance", "Task", "Lead", "Queries", "My Files"];
  int _colorId = 0;
  bool _loading = false;
  static int presentCount = 2, absentCount = 3, leaveCount = 1;
  List<CommonGraphModel> chartData = <CommonGraphModel>[
    CommonGraphModel(
        x: 'Present days', y: presentCount, pointColor: const Color.fromRGBO(177, 186, 43, 1)),

  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      chartData = <CommonGraphModel>[
        CommonGraphModel(
            x: 'Present days', y: presentCount, pointColor: const Color.fromRGBO(177, 186, 43, 1)),

      ];
    });

    getRole(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarOptions(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 20.0),
          child: Column(
            children: [
              Container(
                height: 45.0,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _optionList.length,
                    itemBuilder: (ctx, i) {
                      return Row(
                        children: [
                          SizedBox(width: 20.0),
                          SizedBox(
                            height: 30.0,
                            child: RaisedButton(
                              onPressed: () {
                                setState(() {
                                  _colorId = i;
                                });
                              },
                              color: _colorId == i
                                  ? ColorsUsed.baseColor
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              child: Text(
                                _optionList[i],
                                style: Constants().txtStyleFont16(
                                    _colorId == i
                                        ? Colors.white
                                        : ColorsUsed.baseColor,
                                    13.0),
                              ),
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
      ),
    );
  }

  // Create numeric graph data for attendance.
  static List<charts.Series<LinearSales, int>> numberLineAttendanceData() {
    final desktopSalesData = [
      new LinearSales(0, 5),
      new LinearSales(1, 25),
      new LinearSales(2, 100),
      new LinearSales(3, 75),
    ];

    final tableSalesData = [
      new LinearSales(0, 10),
      new LinearSales(1, 50),
      new LinearSales(2, 200),
      new LinearSales(3, 150),
    ];

    final mobileSalesData = [
      new LinearSales(0, 10),
      new LinearSales(1, 50),
      new LinearSales(2, 200),
      new LinearSales(3, 150),
    ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'Desktop',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: desktopSalesData,
      ),
      new charts.Series<LinearSales, int>(
        id: 'Tablet',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: tableSalesData,
      ),
      new charts.Series<LinearSales, int>(
          id: 'Mobile',
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
          domainFn: (LinearSales sales, _) => sales.year,
          measureFn: (LinearSales sales, _) => sales.sales,
          data: mobileSalesData)
        // Configure our custom point renderer for this series.
        ..setAttribute(charts.rendererIdKey, 'customPoint'),
    ];
  }

  static List<charts.Series<OrdinalSales, String>> leadBarChartData() {
    final desktopSalesData = [
      new OrdinalSales('2014', 5),
      new OrdinalSales('2015', 25),
      new OrdinalSales('2016', 100),
      new OrdinalSales('2017', 75),
    ];

    final tableSalesData = [
      new OrdinalSales('2014', 25),
      new OrdinalSales('2015', 50),
      new OrdinalSales('2016', 10),
      new OrdinalSales('2017', 20),
    ];

    final mobileSalesData = [
      new OrdinalSales('2014', 10),
      new OrdinalSales('2015', 50),
      new OrdinalSales('2016', 50),
      new OrdinalSales('2017', 45),
    ];

    return [
      // Blue bars with a lighter center color.
      new charts.Series<OrdinalSales, String>(
        id: 'Desktop',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: desktopSalesData,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        fillColorFn: (_, __) =>
            charts.MaterialPalette.blue.shadeDefault.lighter,
      ),
      // Solid red bars. Fill color will default to the series color if no
      // fillColorFn is configured.
      new charts.Series<OrdinalSales, String>(
        id: 'Tablet',
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: tableSalesData,
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
      ),
      // Hollow green bars.
      new charts.Series<OrdinalSales, String>(
        id: 'Mobile',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: mobileSalesData,
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        fillColorFn: (_, __) => charts.MaterialPalette.transparent,
      ),
    ];
  }

  _appBarOptions() {
    return PreferredSize(
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(40.0),
          bottomLeft: Radius.circular(40.0),
        ),
        child: AppBar(
          backgroundColor: ColorsUsed.baseColor,
//           leading: Constants().backButton(context),
          centerTitle: true,
          title: Row(
            children: [
              SizedBox(width: 35.0),
              Image.asset(Img.myOfficeImage, width: 20.0),
              SizedBox(
                width: 10.0,
              ),
              Text(
                "My Graphs",
                style: Constants().txtStyleFont16(ColorsUsed.whiteColor, 20.0),
              ),
            ],
          ),
        ),
      ),
      preferredSize:
          Size.fromHeight(Constants().containerHeight(context) * 0.08),
    );
  }

  //this contains the data which graph page w have to show
  _graphDetailsForSpecificOption() {
    switch (_colorId) {
      //0 is the id for attendance graphs
      case 0:
        return attendanceGraphs();
        break;
      //1 is the id for task graphs
      case 1:
        return queriesGraphs();
        break;
      //2 is the id for leads graphs
      case 2:
        GraphPageApis().leadsGraph(
            context: context, userID: Constants.userId, month: "10");
        return queriesGraphs();
        break;
      //3 is the id for queries graphs
      case 3:
        return queriesGraphs();
        break;
      //4 is the id for file graphs
      case 4:
        return queriesGraphs();
        break;
      default:
        return Container();
    }
  }

  //Graph for attendance page
  attendanceGraphs() {
    if (!_loading) {
      return Column(
        children: [
          Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            child: Column(
              children: [
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(width: 15.0),
                    Text(
                      "Show: ",
                      style: Constants().txtStyleFont16(Colors.grey[500], 13.0),
                    ),
                    Text(
                      "This month",
                      style: Constants()
                          .txtStyleFont16(ColorsUsed.baseColor, 13.0),
                    ),
                    SizedBox(width: 15.0),
                  ],
                ),
                Container(
                    height: 150.0,
                    child: SfCircularChart(
                      annotations: <CircularChartAnnotation>[
                        CircularChartAnnotation(
                            widget: Container(
                                child: const Text('90%',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 25))))
                      ],
                      title: ChartTitle(text: 'Software development cycle'),
                      series: _getDoughnutCustomizationSeries(),
                    )),
                SizedBox(height: 15.0),
              ],
            ),
          ),
          Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            child: Column(
              children: [
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(width: 15.0),
                    Text(
                      "Show: ",
                      style: Constants().txtStyleFont16(Colors.grey[500], 13.0),
                    ),
                    Text(
                      "This month",
                      style: Constants()
                          .txtStyleFont16(ColorsUsed.baseColor, 13.0),
                    ),
                    SizedBox(width: 15.0),
                  ],
                ),
                Container(
                    height: 150.0,
                    child: charts.NumericComboChart(numberLineAttendanceData(),
                        animate: animate,
                        // Configure the default renderer as a line renderer. This will be used
                        // for any series that does not define a rendererIdKey.
                        defaultRenderer: new charts.LineRendererConfig(),
                        // Custom renderer configuration for the point series.
                        customSeriesRenderers: [
                          new charts.PointRendererConfig(
                              // ID used to link series to this renderer.
                              customRendererId: 'customPoint')
                        ])),
                SizedBox(height: 15.0),
              ],
            ),
          )
        ],
      );
    } else {
      return Center(
        child: Text("Loading..."),
      );
    }
  }

  Future<dynamic> getRole(BuildContext context) async {
    loaderOnOff(true);
    try {
      await http
          .get(
              "${Constants.BaseUrl}action=attendanceTotalCount&userId=8&month=2021-01-05")
          .then((res) {
        print(res.body);
        var response = json.decode(res.body);
        final int statusCode = res.statusCode;
        print(statusCode);
        if (statusCode == 200) {
          loaderOnOff(false);
          print("its working 200");
          if (response["success"] == 1) {
            print(response);
print("asdjasn");
            setState(() {
              presentCount = int.parse(response["statusabsent"]);
              leaveCount = int.parse(response["statusleave"]);
              absentCount = int.parse(response["totalattendance"]);
              chartData = <CommonGraphModel>[
                CommonGraphModel(
                    x: 'Absent days', y:absentCount , pointColor: const Color(0xFFD32F2F)),
                CommonGraphModel(
                    x: 'Leave days', y: leaveCount, pointColor: const Color.fromRGBO(251, 188, 2, 1)),
                CommonGraphModel(
                    x: 'Present days', y: presentCount, pointColor: const Color.fromRGBO(177, 186, 43, 1)),

              ];
            });
            loaderOnOff(false);
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

  loaderOnOff(bool value) {
    setState(() {
      _loading = value;
    });
  }

  //Graph for queries page
  queriesGraphs() {
    return Column(
      children: [
        Card(
          elevation: 5.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Column(
            children: [
              SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(width: 15.0),
                  Text(
                    "Show: ",
                    style: Constants().txtStyleFont16(Colors.grey[500], 13.0),
                  ),
                  Text(
                    "This month",
                    style:
                        Constants().txtStyleFont16(ColorsUsed.baseColor, 13.0),
                  ),
                  SizedBox(width: 15.0),
                ],
              ),
              Container(
                  height: 150.0,
                  child: charts.BarChart(
                    leadBarChartData(),
                    animate: animate,
                    barGroupingType: charts.BarGroupingType.grouped,
                    // Add the legend behavior to the chart to turn on legends.
                    // This example shows how to change the position and justification of
                    // the legend, in addition to altering the max rows and padding.
                    behaviors: [
                      new charts.SeriesLegend(
                        // Positions for "start" and "end" will be left and right respectively
                        // for widgets with a build context that has directionality ltr.
                        // For rtl, "start" and "end" will be right and left respectively.
                        // Since this example has directionality of ltr, the legend is
                        // positioned on the right side of the chart.
                        position: charts.BehaviorPosition.end,
                        // For a legend that is positioned on the left or right of the chart,
                        // setting the justification for [endDrawArea] is aligned to the
                        // bottom of the chart draw area.
                        outsideJustification:
                            charts.OutsideJustification.endDrawArea,
                        // By default, if the position of the chart is on the left or right of
                        // the chart, [horizontalFirst] is set to false. This means that the
                        // legend entries will grow as new rows first instead of a new column.
                        horizontalFirst: false,
                        // By setting this value to 2, the legend entries will grow up to two
                        // rows before adding a new column.
                        desiredMaxRows: 2,
                        // This defines the padding around each legend entry.
                        cellPadding:
                            new EdgeInsets.only(right: 4.0, bottom: 4.0),
                        // Render the legend entry text with custom styles.
                        entryTextStyle: charts.TextStyleSpec(
                            color: charts.Color(r: 127, g: 63, b: 191),
                            fontFamily: 'Georgia',
                            fontSize: 11),
                      )
                    ],
                  )),
              SizedBox(height: 15.0),
            ],
          ),
        ),
      ],
    );
  }

  List<DoughnutSeries<CommonGraphModel, String>>
      _getDoughnutCustomizationSeries() {
    return <DoughnutSeries<CommonGraphModel, String>>[
      DoughnutSeries<CommonGraphModel, String>(
        dataSource: chartData,
        radius: '100%',
        strokeWidth: 2,
        xValueMapper: (CommonGraphModel data, _) => data.x,
        yValueMapper: (CommonGraphModel data, _) => data.y,

        /// The property used to apply the color for each douchnut series.
        pointColorMapper: (CommonGraphModel data, _) => data.pointColor,
        dataLabelMapper: (CommonGraphModel data, _) => data.x,
      ),
    ];
  }
}

/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}

class LeadGraph {
  final int total;
  final int activeStatus;
  final int closedStatus;

  LeadGraph(this.total, this.activeStatus, this.closedStatus);
}

class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}

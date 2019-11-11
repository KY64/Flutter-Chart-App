import 'dart:math' show Random;
import 'dart:async' show Timer;

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() {
  OneSignal.shared.init("91dad7d5-27b9-42a9-b9ad-1654e02aa661", iOSSettings: {
    OSiOSSettings.autoPrompt: false,
    OSiOSSettings.inAppLaunchUrl: true
  });
  OneSignal.shared
      .setInFocusDisplayType(OSNotificationDisplayType.notification);

  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class VoltageData {
  final int year;
  int clicks = 0;
  final charts.Color color;
  Timer timer;

  VoltageData(this.year, this.clicks, Color color)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class _MyHomePageState extends State<MyHomePage> {
  Timer timer;
  int counter = 0, voltage;
  bool start = false;
  List<VoltageData> data = [];

  @override
  void initState() {
    data = [
      VoltageData(
          -15, Random().nextInt(100), Color.fromRGBO(255, 255, 255, 1.0)),
      VoltageData(
          -14, Random().nextInt(100), Color.fromRGBO(255, 255, 255, 1.0)),
      VoltageData(
          -13, Random().nextInt(100), Color.fromRGBO(255, 255, 255, 1.0)),
      VoltageData(
          -12, Random().nextInt(100), Color.fromRGBO(255, 255, 255, 1.0)),
      VoltageData(
          -11, Random().nextInt(100), Color.fromRGBO(255, 255, 255, 1.0)),
      VoltageData(
          -10, Random().nextInt(100), Color.fromRGBO(255, 255, 255, 1.0)),
      VoltageData(
          -9, Random().nextInt(100), Color.fromRGBO(255, 255, 255, 1.0)),
      VoltageData(
          -8, Random().nextInt(100), Color.fromRGBO(255, 255, 255, 1.0)),
      VoltageData(
          -7, Random().nextInt(100), Color.fromRGBO(255, 255, 255, 1.0)),
      VoltageData(
          -6, Random().nextInt(100), Color.fromRGBO(255, 255, 255, 1.0)),
      VoltageData(
          -5, Random().nextInt(100), Color.fromRGBO(255, 255, 255, 1.0)),
      VoltageData(
          -4, Random().nextInt(100), Color.fromRGBO(255, 255, 255, 1.0)),
      VoltageData(
          -3, Random().nextInt(100), Color.fromRGBO(255, 255, 255, 1.0)),
      VoltageData(
          -2, Random().nextInt(100), Color.fromRGBO(255, 255, 255, 1.0)),
      VoltageData(
          -1, Random().nextInt(100), Color.fromRGBO(255, 255, 255, 1.0)),
    ];
    super.initState();
  }

  IconData isStart(bool st) {
    if (st)
      return Icons.stop;
    else
      return Icons.play_arrow;
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<VoltageData, num>> series = [
      new charts.Series(
        domainFn: (VoltageData clickData, _) => clickData.year,
        measureFn: (VoltageData clickData, _) => clickData.clicks,
        colorFn: (VoltageData clickData, _) => clickData.color,
        id: 'Volt',
        data: data,
      )
    ];
    var chart = new charts.LineChart(
      series,
      animate: true,
      primaryMeasureAxis: charts.NumericAxisSpec(
          renderSpec: charts.GridlineRendererSpec(
              labelStyle: charts.TextStyleSpec(
                  fontSize: 10, color: charts.MaterialPalette.white),
              lineStyle: charts.LineStyleSpec(
                thickness: 0,
                color: charts.MaterialPalette.white,
              ))),
      domainAxis: new charts.NumericAxisSpec(
          renderSpec: charts.GridlineRendererSpec(
              axisLineStyle: charts.LineStyleSpec(
                color: charts.MaterialPalette
                    .transparent, // this also doesn't change the Y axis labels
              ),
              labelStyle: new charts.TextStyleSpec(
                fontSize: 10,
                color: charts.MaterialPalette.white,
              ),
              lineStyle: charts.LineStyleSpec(
                thickness: 0,
                color: charts.MaterialPalette.transparent,
              )),
          viewport: new charts.NumericExtents(counter - 15, counter)),
      // Optionally add a pan or pan and zoom behavior.
      // If pan/zoom is not added, the viewport specified remains the viewport.
      behaviors: [new charts.PanAndZoomBehavior()],
    );

    var chartWidget = new Padding(
      padding: new EdgeInsets.all(32.0),
      child: new SizedBox(
        height: 230.0,
        child: chart,
      ),
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Container(
          child: Column(
        children: <Widget>[
          chartWidget,
          Text(
            '$voltage',
            style: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 1), fontSize: 42),
          )
        ],
      )),
      backgroundColor: Colors.deepPurple,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(30, 0, 0, 50),
            child: FloatingActionButton(
              onPressed: () {
                if (!start) {
                  start = true;
                  timer = Timer.periodic(Duration(seconds: 1), (timer) {
                    setState(() {
                      voltage = Random().nextInt(100);
                      counter++;
                      data.add(VoltageData(counter, voltage,
                          Color.fromRGBO(255, 255, 255, 1.0)));
                      if (data.length > 90) data.removeRange(0, 70);

                      if (voltage < 20) {
                        var playerId = "5507cedb-1f79-46c2-8fa2-e97f2fad2dbc";
                        if (voltage < 20) {
                          OneSignal.shared.postNotification(
                              OSCreateNotification(
                                  playerIds: [playerId],
                                  content:
                                      "Warning! Voltage level is below normal",
                                  heading: "Low Voltage",
                                  buttons: [
                                    OSActionButton(text: "Check", id: "id1"),
                                    OSActionButton(text: "Hide", id: "id2")
                                  ]));
                        }
                      }
                    });
                  });
                } else {
                  setState(() {
                    start = false;
                    timer.cancel();
                  });
                }
              },
              child: Icon(
                isStart(start),
              ),
              backgroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

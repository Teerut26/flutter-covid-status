import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:screenshot/screenshot.dart';
import 'dart:io' as Io;
import 'package:intl/intl.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'ClassCovid.dart';
import 'ClassCovidDaily.dart';
import 'package:badges/badges.dart';

void main() {
  runApp(MyApp());
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   statusBarColor: Colors.green,
  // ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Covid Status',
      home: MyHomePage(title: 'Covid Status'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ClassCovid? _dataCovid;
  ClassCovidDaily? _dataCovidDaily;

  void initState() {
    super.initState();
    getData();
    getLinkApiLast();
  }

  String formatterNumber(String value) {
    var formatter = NumberFormat('###,000');
    return formatter.format(int.parse(value)).toString();
  }

  Future<void> getLinkApiLast() async {
    var file_name = await DateTime.now().millisecondsSinceEpoch.toString();
    var res = await get(Uri.parse(
        "https://s.isanook.com/an/0/covid-19/static/data/thailand/daily/latest.json?${file_name}"));
    getDataDaily(jsonDecode(res.body)["url"].toString());
  }

  Future<void> getData() async {
    var file_name = DateTime.now().millisecondsSinceEpoch.toString();
    var res = await get(Uri.parse(
        "https://s.isanook.com/sh/0/covid_2019/data.json?${file_name}"));
    var data = await classCovidFromJson(res.body);
    setState(() {
      _dataCovid = data;
    });
  }

  Future<void> getDataDaily(String url) async {
    var file_name = DateTime.now().millisecondsSinceEpoch.toString();
    var res = await get(Uri.parse(url));
    var data = await classCovidDailyFromJson(res.body);
    setState(() {
      _dataCovidDaily = data;
    });
    // final DateFormat formatter = DateFormat('yyyy-MM-dd');
  }

  String formatterDate(DateTime value) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(value).toString();
  }

  Future<void> capture() async {
    Uint8List? image = await screenshotController.capture();
    var pngBytes = await image!.buffer.asUint8List();
    var file_name = DateTime.now().millisecondsSinceEpoch.toString();
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(pngBytes),
        quality: 100,
        name: file_name);
    print(result);
    Share.shareFiles(['/storage/emulated/0/Pictures/${file_name}.jpg'],
        text: 'Great picture');
    // print(image.runtimeType);
  }

  Future<String> getPathData() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();

    Directory directory =
        await new Directory(appDocDirectory.path + '/' + 'dir')
            .create(recursive: true);
    return directory.path.toString();
  }

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [Icon(Icons.coronavirus), Text(" Covid Status")],
                ),
                Row(
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      onPressed: () {
                        print("Share");
                        capture();
                      },
                      child: Icon(Icons.save),
                    ),
                     TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      onPressed: () {
                        Share.share('ติดเชื้อ : ${_dataCovid!.thai.newCases}');
                      },
                      child: Icon(Icons.share),
                    ),
                  ],
                )
              ],
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[Colors.green, Colors.lime])),
            )),
        body: Screenshot(
          controller: screenshotController,
          child: Container(
            
            decoration: BoxDecoration(color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  
                  Text(_dataCovidDaily != null
                      ? "ข้อมูลอัปเดตล่าสุด : ${formatterDate(_dataCovidDaily!.lastUpdated)}"
                      : ""),
                  Text("Dev By : Teerut"),
                  Card1(),
                  Card2(),
                  Card3(),
                  Card4()
                  
                ],
              ),
            ),
          ),
        )
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  Widget Card1() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "ติดเชื้อเพิ่มขึ้น",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  "${_dataCovid != null ? formatterNumber(_dataCovid!.thai.totalCases) : ""} คน",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  "+${_dataCovid != null ? formatterNumber(_dataCovid!.thai.newCases) : ""} คน",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
          width: 500,
          height: 130,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 8,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Colors.red, Colors.orange])),
        )
      ],
    );
  }

  Widget Card2() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "รักษาตัวในร.พ.",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  "${_dataCovid != null ? formatterNumber(_dataCovid!.thai.activeCases) : ""} คน",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                // Text(
                //   "+6,686 คน",
                //   style: TextStyle(
                //       fontSize: 20,
                //       fontWeight: FontWeight.bold,
                //       color: Colors.white),
                // ),
              ],
            ),
          ),
          width: 500,
          height: 130,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 8,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Colors.blue, Colors.deepPurple])),
        )
      ],
    );
  }

  Widget Card3() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "เสียชีวิตเพิ่มขึ้น",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  "${_dataCovid != null ? formatterNumber(_dataCovid!.thai.deaths) : ""} คน",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  "+${_dataCovidDaily != null ? formatterNumber((_dataCovidDaily!.data[_dataCovidDaily!.data.length - 1].deaths - _dataCovidDaily!.data[_dataCovidDaily!.data.length - 2].deaths).toString()) : ""} คน",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
          width: 500,
          height: 130,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 8,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Colors.grey, Colors.black87])),
        )
      ],
    );
  }

  Widget Card4() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "หายแล้วเพิ่มขึ้น",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  "${_dataCovid != null ? formatterNumber(_dataCovid!.thai.recovered) : ""} คน",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  "+${_dataCovidDaily != null ? formatterNumber((_dataCovidDaily!.data[_dataCovidDaily!.data.length - 1].recovered - _dataCovidDaily!.data[_dataCovidDaily!.data.length - 2].recovered).toString()) : ""} คน",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
          width: 500,
          height: 130,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 8,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Colors.green, Colors.yellowAccent])),
        )
      ],
    );
  }
}

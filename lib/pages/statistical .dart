import 'package:TunCoinWallet/pages/home.dart';
import 'package:TunCoinWallet/pages/login.dart';
import 'package:TunCoinWallet/pages/menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';

import 'dart:async';

import 'package:flutter/services.dart';

class SatisticalPage extends StatefulWidget {
  @override
  _SatisticalPageState createState() => _SatisticalPageState();
}

class _SatisticalPageState extends State<SatisticalPage> {
//Pie chart

  List<PieChartSectionData> _sections = List<PieChartSectionData>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    PieChartSectionData _item2 = PieChartSectionData(
      color: Colors.amber,
      value: 20,
      title: 'bitCoin',
      radius: 70,
      titleStyle: TextStyle(color: Colors.white, fontSize: 24),
    );
    PieChartSectionData _item3 = PieChartSectionData(
      color: Colors.red,
      value: 30,
      title: 'Etherum',
      radius: 70,
      titleStyle: TextStyle(color: Colors.white, fontSize: 24),
    );
    PieChartSectionData _item1 = PieChartSectionData(
      color: Colors.blueAccent,
      value: 40,
      title: 'TunCoin',
      radius: 50,
      titleStyle: TextStyle(color: Colors.white, fontSize: 24),
    );
    PieChartSectionData _item4 = PieChartSectionData(
      color: Colors.deepPurple,
      value: 10,
      title: 'seCoin',
      radius: 70,
      titleStyle: TextStyle(color: Colors.white, fontSize: 24),
    );

    _sections = [_item1, _item2, _item3, _item4];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff001a33),
        appBar: AppBar(
          title: Text("Satistical"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Color(0xff001a33),
            ),
            onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Menu())),
          ),
          backgroundColor: Color(0xff13f4ef),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.trending_down),
              color: Color(0xff001a33),
              onPressed: () {
                print("wessssssssssss....");
              },
            ),
          ],
        ),
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Card(
              color: Color(0xff113768),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50.0))),
              elevation: 10.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
                  Center(
                    child: Text(
                      'Welcome Back!',
                      style: TextStyle(
                          color: Color(0xff13f4ef),
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'),
                    ),
                  ),
                  // Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
                  Container(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: FlChart(
                        chart: PieChart(PieChartData(
                          sections: _sections,
                          borderData: FlBorderData(show: false),
                          centerSpaceRadius: 60,
                          sectionsSpace: 0,
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}

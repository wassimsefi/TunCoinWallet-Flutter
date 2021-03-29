import 'package:TunCoinWallet/pages/home.dart';
import 'package:TunCoinWallet/pages/login.dart';
import 'package:TunCoinWallet/pages/menu.dart';
import 'package:TunCoinWallet/widgets/line_chart.dart';
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
          onPressed: () => Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) => Menu())),
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
      body: Padding(
        padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.03),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                children: <Widget>[
                  InfoCard(
                    title: "Send",
                    effecteNum: 1259,
                  ),
                  InfoCard(
                    title: "Buy",
                    effecteNum: 1259,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 14,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0),
              child: Column(
                children: [
                  Text(
                    "Balance :",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Wrap(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: RichText(
                                      text: TextSpan(
                                    style: TextStyle(color: Colors.black),
                                    children: [
                                      TextSpan(
                                        text: "1258.5 \n",
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                      TextSpan(
                                        text: "TNC",
                                        style: TextStyle(
                                            fontSize: 15,
                                            height: 2,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ],
                                  )),
                                ),
                                Expanded(
                                  child: LineReportChartBalance(),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Text(
                    "Cryptocurrency :",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Wrap(
                    children: <Widget>[
                      Container(
                        height: 300,
                        decoration: BoxDecoration(
                          color: Color(0xff001a33),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(30.0),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: PieReportChart(),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final int effecteNum;
  const InfoCard({Key key, this.title, this.effecteNum}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth / 2 - 10,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Color(0xFFFF9C00).withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        'assets/logo2.png',
                        fit: BoxFit.contain,
                        height: 12,
                        width: 12,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: RichText(
                          text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: "$effecteNum \n",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: "TNC",
                            style: TextStyle(fontSize: 12, height: 2),
                          ),
                        ],
                      )),
                    ),
                    Expanded(
                      child: LineReportChart(),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class PieReportChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AspectRatio(
        aspectRatio: 2.2,
        child: PieChart(PieChartData(
          sections: getCoin(),
          borderData: FlBorderData(show: false),
          centerSpaceRadius: 60,
          sectionsSpace: 0,
        )),
      ),
    );
  }

  List<PieChartSectionData> getCoin() {
    List<PieChartSectionData> _sections = List<PieChartSectionData>();

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

    return _sections;
  }
}

class LineReportChartBalance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AspectRatio(
        aspectRatio: 2.2,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: getSports(),
                isCurved: true,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(show: false),
                colors: [Color(0xff13f4ef)],
                barWidth: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<FlSpot> getSports() {
    return [
      FlSpot(0, 0),
      FlSpot(1, .5),
      FlSpot(2, 1.5),
      FlSpot(3, 1.5),
      FlSpot(4, 1.7),
      FlSpot(5, 2),
      FlSpot(6, 1.5),
      FlSpot(7, 1.7),
      FlSpot(8, .1),
      FlSpot(9, 2.8),
      FlSpot(10, 2.5),
      FlSpot(11, 2.4),
    ];
  }
}

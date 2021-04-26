import 'package:TunCoinWallet/Model/user_model.dart';
import 'package:TunCoinWallet/pages/home.dart';
import 'package:TunCoinWallet/pages/login.dart';
import 'package:TunCoinWallet/pages/menu.dart';
import 'package:TunCoinWallet/pages/splash_content.dart';
import 'package:TunCoinWallet/widgets/line_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SatisticalPage extends StatefulWidget {
  @override
  _SatisticalPageState createState() => _SatisticalPageState();
}

const kAnimationDuration = Duration(milliseconds: 200);

class _SatisticalPageState extends State<SatisticalPage> {
  String id = "";
  User _user;

  Future getId() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id');
    print("home : " + id);

    //get User

    final User user = await getUser(id);
    setState(() {
      _user = user;
    });
  }

  Future<User> getUser(String id) async {
    final String apiUrl = "https://tuncoin.herokuapp.com/loggedUser/$id";

    final Response = await http.get(apiUrl);

    final String responseString = Response.body;

    return userFromJson(responseString);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getId();

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

//Pie chart

  List<PieChartSectionData> _sections = List<PieChartSectionData>();

  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "text":
          "We help people conect with store \naround United State of America",
      "type": "Buy",
      "price": "18970"
    },
    {
      "text": "We show the easy way to shop. \nJust stay at home with us",
      "type": "Send",
      "price": "142"
    },
  ];

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
      body: FutureBuilder(
        future: getUser(id),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (snapshot.hasData) {
            return SafeArea(
              child: SizedBox(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 9,
                          ),
                          Text(
                            "BALONCE",
                            style: TextStyle(
                              fontSize: 36,
                              color: Color(0xff13f4ef),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            ' text text text text text text text text \n text text text text text text ',
                            textAlign: TextAlign.center,
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
                                            style:
                                                TextStyle(color: Colors.black),
                                            children: [
                                              TextSpan(
                                                text: _user.balance.toString() +
                                                    "\n",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white),
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
                    Expanded(
                      flex: 6,
                      child: PageView.builder(
                        onPageChanged: (value) {
                          setState(() {
                            currentPage = value;
                          });
                        },
                        itemCount: splashData.length,
                        itemBuilder: (context, index) => SplashContent(
                          type: splashData[index]["type"],
                          text: splashData[index]['text'],
                          price: splashData[index]['price'],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: <Widget>[
                            Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                splashData.length,
                                (index) => buildDot(index: index),
                              ),
                            ),
                            Spacer(flex: 12),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      // Container(
      //   height: 160,
      //   width: double.infinity,
      //   decoration: BoxDecoration(
      //     color: Colors.green.withOpacity(0.03),
      //     borderRadius: BorderRadius.only(
      //       bottomLeft: Radius.circular(50),
      //       bottomRight: Radius.circular(50),
      //     ),
      //   ),
      //   child: Wrap(
      //     spacing: 20,
      //     runSpacing: 20,
      //     children: <Widget>[
      //       InfoCard(
      //         title: "Send",
      //         effecteNum: 1259,
      //       ),
      //       InfoCard(
      //         title: "Buy",
      //         effecteNum: 2584,
      //       ),
      //     ],
      //   ),
      // ),

      //new new

      //   Padding(
      //     padding: const EdgeInsets.symmetric(vertical: 20),
      //     child: Column(
      //       children: [
      //         Text(
      //           "Cryptocurrency :",
      //           style: TextStyle(
      //             fontWeight: FontWeight.bold,
      //             fontSize: 20,
      //           ),
      //         ),
      //         Wrap(
      //           children: <Widget>[
      //             Container(
      //               height: 300,
      //               decoration: BoxDecoration(
      //                 color: Color(0xff001a33),
      //                 borderRadius: BorderRadius.circular(8),
      //               ),
      //               child: Column(
      //                 children: <Widget>[
      //                   Padding(
      //                     padding: const EdgeInsets.all(30.0),
      //                   ),
      //                   Row(
      //                     crossAxisAlignment: CrossAxisAlignment.center,
      //                     children: <Widget>[
      //                       Expanded(
      //                         child: PieReportChart(),
      //                       ),
      //                     ],
      //                   )
      //                 ],
      //               ),
      //             )
      //           ],
      //         ),
      //       ],
      //     ),
      //   ),
    );
  }

  AnimatedContainer buildDot({int index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? Color(0xff13f4ef) : Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
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

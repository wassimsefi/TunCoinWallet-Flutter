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

  List<Transaction> transactionsList = new List();

  Future getId() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id');
    print("home : " + id);

    //get User

    final User user = await getUser(id);
    setState(() {
      _user = user;

      for (var i = 0; i < _user.transaction.length; i++) {
        transactionsList.insert(0, _user.transaction[i]);
      }
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
      "price": "17840"
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
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) => Menu())),
        ),
        backgroundColor: Color(0xff001a33),
      ),
      body: transactionsList.length == 0
          ? new FutureBuilder(
              future: getUser(id),
              builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    child: new Center(
                      child: Text(
                        "no transaction !!!",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            )
          : new FutureBuilder(
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
                                  "BALANCE",
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
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: Row(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: RichText(
                                                    text: TextSpan(
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                  children: [
                                                    TextSpan(
                                                      text: _user.balance
                                                              .toString() +
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
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                  "TRANDACTIONS",
                                  style: TextStyle(
                                    fontSize: 36,
                                    color: Color(0xff13f4ef),
                                    fontWeight: FontWeight.bold,
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Expanded(
                                                child: PieReportChart(
                                                  user: _user,
                                                ),
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

                          //   Expanded(
                          //     flex: 6,
                          //     child: PageView.builder(
                          //       onPageChanged: (value) {
                          //         setState(() {
                          //           currentPage = value;
                          //         });
                          //       },
                          //       itemCount: splashData.length,
                          //       itemBuilder: (context, index) => SplashContent(
                          //         type: splashData[index]["type"],
                          //         text: splashData[index]['text'],
                          //         price: splashData[index]['price'],
                          //       ),
                          //     ),
                          //   ),
                          //   Expanded(
                          //     flex: 1,
                          //     child: Padding(
                          //       padding: EdgeInsets.symmetric(horizontal: 10),
                          //       child: Column(
                          //         children: <Widget>[
                          //           Spacer(),
                          //           Row(
                          //             mainAxisAlignment: MainAxisAlignment.center,
                          //             children: List.generate(
                          //               splashData.length,
                          //               (index) => buildDot(index: index),
                          //             ),
                          //           ),
                          //           Spacer(flex: 12),
                          //           Spacer(),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
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

class PieReportChart extends StatefulWidget {
  final User user;

  const PieReportChart({Key key, this.user}) : super(key: key);
  @override
  _PieReportChartState createState() => _PieReportChartState();
}

class _PieReportChartState extends State<PieReportChart> {
  User _user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _user = widget.user;
  }

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

    int sValues = 0;
    int bCalues = 0;
    print('transaction length 04789 ' + (_user.transaction.length).toString());
    print(transactionToJson(_user.transaction[1]));
    for (var i = 0; i < _user.transaction.length; i++) {
      if (_user.transaction[i].typeTransaction == "Buying") {
        bCalues = bCalues + _user.transaction[i].amount;
      } else {
        sValues = sValues + _user.transaction[i].amount;
      }
    }

    print('transaction length  222222 ' + (bCalues).toString());
    PieChartSectionData _item2 = PieChartSectionData(
      color: Colors.green,
      value: bCalues.toDouble(),
      title: 'Send',
      radius: 70,
      titleStyle: TextStyle(color: Colors.white, fontSize: 24),
    );

    PieChartSectionData _item1 = PieChartSectionData(
      color: Colors.orange,
      value: sValues.toDouble(),
      titlePositionPercentageOffset: 0.5,
      title: 'Receive',
      radius: 70,
      titleStyle: TextStyle(color: Colors.white, fontSize: 24),
    );

    _sections = [
      _item2,
      _item1,
    ];

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
      FlSpot(1, 1000),
      FlSpot(2, 800),
      FlSpot(3, 500),
      FlSpot(4, 1500),
      FlSpot(5, 3000),
      FlSpot(6, 2000),
      FlSpot(7, 1900),
      FlSpot(8, 1800),
      FlSpot(9, 1500),
      FlSpot(10, 1000),
      FlSpot(11, 600),
      FlSpot(12, 610),
      FlSpot(13, 660),
      FlSpot(14, 1600),
      FlSpot(15, 1900),
      FlSpot(16, 2200),
      FlSpot(17, 2000),
      FlSpot(18, 1990),
      FlSpot(19, 1970),
      FlSpot(20, 1500),
      FlSpot(21, 1600),
      FlSpot(22, 1400),
      FlSpot(23, 1130),
    ];
  }
}

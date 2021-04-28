import 'dart:ffi';
import 'package:TunCoinWallet/widgets/generate.dart';
import 'package:TunCoinWallet/widgets/line_chart.dart';
import 'package:TunCoinWallet/widgets/line_chart2.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({
    Key key,
    this.text,
    this.type,
    this.price,
  }) : super(key: key);
  final String text, type, price;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Column(
      children: <Widget>[
        Spacer(),
        Text(
          type,
          style: TextStyle(
            fontSize: 36,
            color: Color(0xff13f4ef),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          text,
          textAlign: TextAlign.center,
        ),
        Spacer(flex: 2),
        Container(
          width: width,
          height: height / 3,
          margin: EdgeInsets.all(10),
          child: Wrap(
            spacing: 20,
            runSpacing: 20,
            children: <Widget>[
              InfoCard(
                title: type,
                effecteNum: int.parse(price),
              ),
            ],
          ),
        ),
      ],
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
        return Center(
          child: Container(
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
                        child: title == "Buy"
                            ? LineReportChart()
                            : LineReportChart2(),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

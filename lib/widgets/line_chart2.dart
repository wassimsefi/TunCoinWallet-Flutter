import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineReportChart2 extends StatefulWidget {
  @override
  _LineReportChart2State createState() => _LineReportChart2State();
}

class _LineReportChart2State extends State<LineReportChart2> {
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
                //  curveSmoothness: 00.1,
                shadow: Shadow(blurRadius: 30, color: Colors.red),

                dotData: FlDotData(show: true),
                belowBarData: BarAreaData(show: false),
                colors: [Colors.red],
                barWidth: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<FlSpot> getSports() {
    return [
      FlSpot(0, 100),
      FlSpot(1, 10),
      FlSpot(2, 10),
      FlSpot(3, 20),
      FlSpot(4, 60),
      FlSpot(5, 150),
      FlSpot(6, 90),
      FlSpot(7, 80),
      FlSpot(8, 70),
      FlSpot(9, 40),
      FlSpot(10, 20),
      FlSpot(11, 20),
      FlSpot(12, 120),
      FlSpot(13, 60),
      FlSpot(14, 100),
      FlSpot(15, 10),
    ];
  }
}

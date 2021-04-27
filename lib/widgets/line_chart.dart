import 'package:TunCoinWallet/Model/user_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LineReportChart extends StatefulWidget {
  @override
  _LineReportChartState createState() => _LineReportChartState();
}

class _LineReportChartState extends State<LineReportChart> {
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
  }

  @override
  Widget build(BuildContext context) {
    List<int> yValues = new List();
    print('transaction length ' + (_user.transaction.length).toString());
    print(transactionToJson(_user.transaction[1]));
    for (var i = 0; i < _user.transaction.length; i++) {
      if (_user.transaction[i].typeTransaction == "Buying") {
        print("yes \i");
        print(_user.transaction[i].amount);
        yValues.add(_user.transaction[i].amount);
      }
    }

    List<FlSpot> spots = yValues.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.toDouble());
    }).toList();

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
                spots: spots,
                isCurved: true,
                //  curveSmoothness: 00.1,
                shadow: Shadow(blurRadius: 30, color: Colors.green),

                dotData: FlDotData(show: true),
                belowBarData: BarAreaData(show: false),
                colors: [Colors.green],
                barWidth: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

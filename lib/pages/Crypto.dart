import 'dart:convert';

import 'package:TunCoinWallet/Model/cryptocurrency_model.dart';
import 'package:TunCoinWallet/Model/user_model.dart';
import 'package:TunCoinWallet/pages/accueil.dart';
import 'package:TunCoinWallet/pages/home.dart';
import 'package:TunCoinWallet/pages/menu.dart';
import 'package:TunCoinWallet/pages/send.dart';
import 'package:TunCoinWallet/pages/sign_up.dart';
import 'package:TunCoinWallet/pages/statistical%20.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import 'buy.dart';
import 'notification.dart';

class Cryptopage extends StatefulWidget {
  @override
  _CryptopageState createState() => _CryptopageState();
}

class _CryptopageState extends State<Cryptopage> {
  String id = "";
  User _user;
  var logoCrypto = ['imageBitcoin.png', 'logoEth.png', 'logoXrp.png'];

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

  Future logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('id');
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Accueilpage()));
  }

  Future<User> getUser(String id) async {
    final String apiUrl = "https://tuncoin.herokuapp.com/loggedUser/$id";

    final Response = await http.get(apiUrl);

    final String responseString = Response.body;

    return userFromJson(responseString);
  }

  Future<List<Value>> getCryptocurrency() async {
    final String apiUrl = "https://tuncoin.herokuapp.com/cryptocurrency/values";
    final Response = await http.get(apiUrl);

    if (Response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(Response.body);

      List<dynamic> body = json['values'];

      List<Value> values =
          body.map((dynamic item) => Value.fromJson(item)).toList();
      return values;
    } else {
      throw ("Can't get the value");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getId();
    getCryptocurrency();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff001a33),
      appBar: AppBar(
        title: Text("CryptoCurrency"),
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

      body: FutureBuilder(
        future: getCryptocurrency(),
        builder: (BuildContext context, AsyncSnapshot<List<Value>> snapshot) {
          if (snapshot.hasData) {
            List<Value> values = snapshot.data;
            return Container(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Color(0xff2B445C),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Row(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Color(0xff2B445C),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/logo2.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "TNC",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey[900]),
                                ),
                                Text(
                                  "Tuncoin",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey[500]),
                                ),
                                Text(
                                  "Rank : 99",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey[500]),
                                ),
                                Text(
                                  "date : 2021/3",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey[500]),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                " £ 0.125",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.redAccent),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child: Icon(
                                        Icons.arrow_circle_up_sharp,
                                        size: 18,
                                        color: Colors.green,
                                      ),
                                    ),
                                    TextSpan(
                                      text: " 1.28%",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.green),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    ListView.builder(
                      padding: EdgeInsets.all(0),
                      controller: ScrollController(keepScrollOffset: false),
                      itemCount: values.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var taux = double.parse(
                                values[index].the1D.marketCapChangePct) *
                            100;
                        return Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 10),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: Color(0xff2B445C),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: Color(0xff2B445C),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/' + logoCrypto[index],
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      values[index].currency,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.grey[900]),
                                    ),
                                    Text(
                                      values[index].name,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.grey[500]),
                                    ),
                                    Text(
                                      "Rank : " + values[index].rank,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.grey[500]),
                                    ),
                                    Text(
                                      "date : " +
                                          values[index]
                                              .firstCandle
                                              .year
                                              .toString() +
                                          "/" +
                                          values[index]
                                              .firstCandle
                                              .month
                                              .toString(),
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.grey[500]),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    " £ " + values[index].price,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.redAccent),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        WidgetSpan(
                                          child: Icon(
                                            Icons.arrow_circle_up_sharp,
                                            size: 18,
                                            color: Colors.green,
                                          ),
                                        ),
                                        TextSpan(
                                          text: " " + taux.toString() + "%",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.green),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    //now expense
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

      //draggable sheet
    );
  }
}

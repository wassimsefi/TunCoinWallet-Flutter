import 'dart:convert';

import 'package:TunCoinWallet/Model/cryptocurrency_model.dart';
import 'package:TunCoinWallet/Model/user_model.dart';
import 'package:TunCoinWallet/pages/Crypto.dart';
import 'package:TunCoinWallet/pages/accueil.dart';
import 'package:TunCoinWallet/pages/news.dart';
import 'package:TunCoinWallet/pages/send.dart';
import 'package:TunCoinWallet/pages/sign_up.dart';
import 'package:TunCoinWallet/pages/statistical%20.dart';
import 'package:flutter/material.dart';
import 'package:TunCoinWallet/pages/menu.dart';
import 'package:barcode_scan/barcode_scan.dart';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import 'buy.dart';
import 'notification.dart';

class SendPage extends StatefulWidget {
  @override
  _SendPageState createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  String id = "";
  User _user;
  String qrResult = "Not yet Scanned";

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController _amount = TextEditingController();

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

  Future SendAmount(String id, String amount, String idReciver) async {
    final String apiUrl = "https://tuncoin.herokuapp.com/transaction";
    // double amount1 = double.parse(amount);
    final Response = await http.post(apiUrl, body: {
      "idSender": id,
      "idReciver": "60632225786f2f0004f11119",
      "amount": amount
    });

    if (Response.statusCode == 200) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('It is OK'),
          content: Text(
            'Buy succes !! ',
            style: TextStyle(fontSize: 20.0, color: Colors.red),
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Menu())),
                child: Text('OK'))
          ],
        ),
      );
    } else {
      throw Exception(showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Log In Error'),
          content: Text(
            'Account is not activated! ou not found! ',
            style: TextStyle(fontSize: 20.0, color: Colors.red),
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: Text('OK'))
          ],
        ),
      ));
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
    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          //Container for top data
          FutureBuilder(
            future: getUser(id),
            builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
              if (snapshot.hasData) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 32, vertical: 60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            _user.balance.toString() + " TNC",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.w700),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                InkWell(
                                  child: Container(
                                    child: Icon(
                                      Icons.notifications,
                                      color: Colors.lightBlue[100],
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NotificationPage()));
                                  },
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.white,
                                  child: ClipOval(
                                    child: Image.asset(
                                      'assets/logo2.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      Text(
                        "Available Balance",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.blue[100]),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          InkWell(
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(243, 245, 248, 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(18))),
                                    child: Icon(
                                      Icons.send_rounded,
                                      color: Colors.blue[900],
                                      size: 30,
                                    ),
                                    padding: EdgeInsets.all(12),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "News",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color: Colors.blue[100]),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () async {
                              print("object : " + id);
                              print("home mail " + _user.email);

                              print("length transaction  " +
                                  _user.transaction.length.toString());

                              print("balance mail " + _user.balance.toString());

                              print("user : " + userToJson(_user));
                              //  final Transaction _transaction =  userToJson(_user)[]

                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => NewsPage()));
                            },
                          ),
                          InkWell(
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(243, 245, 248, 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(18))),
                                    child: Icon(
                                      Icons.get_app_rounded,
                                      color: Colors.blue[900],
                                      size: 30,
                                    ),
                                    padding: EdgeInsets.all(12),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "Cryptocurrency",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color: Colors.blue[100]),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => Cryptopage()));
                            },
                          ),
                          InkWell(
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(243, 245, 248, 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(18))),
                                    child: Icon(
                                      Icons.stacked_bar_chart,
                                      color: Colors.blue[900],
                                      size: 30,
                                    ),
                                    padding: EdgeInsets.all(12),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "Statistical",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color: Colors.blue[100]),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => SatisticalPage()));
                            },
                          ),
                          InkWell(
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(243, 245, 248, 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(18))),
                                    child: Icon(
                                      Icons.logout,
                                      color: Colors.blue[900],
                                      size: 30,
                                    ),
                                    padding: EdgeInsets.all(12),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "LogOut",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color: Colors.blue[100]),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              logOut();
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),

          DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(245, 245, 245, 1),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Send TunCoin",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 24,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.white,
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
                                    "TunCoin",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey[900]),
                                  ),
                                  Text(
                                    "1 TunCoin = \$ 0.1247",
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
                                  "1 TunCoin = \$ 0.1247",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey[500]),
                                ),
                                Text(
                                  " \$ 0.1247",
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

                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 1.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.0)),
                            Text(
                              "From \n   My TuunCoin Wallet \nTo",
                              style: TextStyle(
                                  fontWeight: FontWeight.w200,
                                  fontSize: 24,
                                  color: Colors.black),
                            ),
                            FlatButton(
                              padding: EdgeInsets.symmetric(horizontal: 40),
                              onPressed: () async {
                                String scaning = await BarcodeScanner.scan();

                                setState(() {
                                  this.qrResult = scaning;
                                });
                              },
                              child: Text('SCAN QR CODE',
                                  style: TextStyle(
                                    fontSize: 16,
                                    letterSpacing: 2.2,
                                    color: Color(0xff001a33),
                                  )),
                              textColor: Color(0xff001a33),
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Color(0xff001a33),
                                      width: 1,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                            Text(
                              qrResult,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18.0, color: Color(0xff001a33)),
                            ),
                            Form(
                              key: _formkey,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          style: TextStyle(
                                            color: Color(0xff001a33),
                                          ),
                                          controller: _amount,
                                          decoration: InputDecoration(
                                            hintText: '0.00',
                                            hintStyle: TextStyle(
                                                fontFamily: 'Montserrat',
                                                color: Color(0xff001a33)),
                                            filled: true,
                                            contentPadding:
                                                EdgeInsets.all(16.0),
                                            prefixIcon: Icon(Icons.euro),
                                          ),
                                          keyboardType: TextInputType.number,
                                          validator: (String value) {
                                            if (value.isEmpty) {
                                              return "Please entre Amount ";
                                            }

                                            return null;
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          "TNC",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 24,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0)),
                            Container(
                              width: 350.0,
                              height: 43.0,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  stops: [0.1, 0.9],
                                  colors: [
                                    Color(0xff1d83ab),
                                    //Color.fromRGBO(19, 244, 239, 1),
                                    Color(0xff13f4ef),
                                  ],
                                ),
                              ),
                              child: FlatButton(
                                child: Text(
                                  'Send',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w900,
                                    fontSize: 24,
                                  ),
                                ),
                                //textColor: Colors.white,
                                color: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                                onPressed: () async {
                                  if (_formkey.currentState.validate()) {
                                    print("hello ");

                                    String amount = _amount.text;

                                    String id = _user.id;

                                    print("id!!!! : " + id);
                                    print("buy!!!! : " + amount.toString());

                                    await SendAmount(id, amount, qrResult);
                                  } else {
                                    return;
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      )

                      //now expense
                    ],
                  ),
                  controller: scrollController,
                ),
              );
            },
            initialChildSize: 0.65,
            minChildSize: 0.65,
            maxChildSize: 1,
          ),

          //draggable sheet
        ],
      ),
    );
  }
}

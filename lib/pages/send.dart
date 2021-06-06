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
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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

  TextEditingController _amount = TextEditingController();
  String _valueTND = "0";
  String _devis = 'TND';
  String _converted = '';

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

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
        builder: (BuildContext context) => Dialog(
          backgroundColor: Color(0xff001a33),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
          child: Stack(
            overflow: Overflow.visible,
            alignment: Alignment.topCenter,
            children: [
              Container(
                height: 300,
                width: 350,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
                  child: Column(
                    children: [
                      Text(
                        'Success !!!',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Your transaction has been successfully done! \n -' +
                            amount +
                            ' TNC',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      RaisedButton(
                        onPressed: () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => Menu())),
                        color: Colors.green,
                        child: Text(
                          'Okay',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                  top: -60,
                  child: CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: 60,
                    child: Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 50,
                    ),
                  )),
            ],
          ),
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

  FlutterLocalNotificationsPlugin localNotification;

  Future _showNotification(String amount) async {
    var android = new AndroidNotificationDetails(
        "channelID", "Local Notification ", "description",
        importance: Importance.high);
    var iOS = IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await localNotification.show(
        0, 'Send TunCoin', 'Send TunCoin balonce - ' + amount, platform);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getId();
    getCryptocurrency();
    var androidInitialize =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosInitialize = IOSInitializationSettings();
    var initSetttings =
        InitializationSettings(android: androidInitialize, iOS: iosInitialize);
    localNotification = new FlutterLocalNotificationsPlugin();

    localNotification.initialize(initSetttings);
  }

  @override
  Widget build(BuildContext context) {
    // convertion
    if (_valueTND == "") {
      _converted = "0.0";
      _valueTND = "0.0";
    } else {
      switch (_devis) {
        case 'TND':
          _converted = ((double.parse(_valueTND)) / 10).toString();
          print("hhhhhh" + _devis);

          break;
        case 'EUR':
          _converted = ((double.parse(_valueTND)) / 2).toString();
          print("hhhhhh22222" + _devis);

          break;
        default:
      }
    }

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
                          Row(
                            children: [
                              Text(
                                _user.balance.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                " TNC",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 16,
                                ),
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Color(0xff001a33),
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
                                      Icons.article_rounded,
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
                                        fontSize: 12,
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
                                      Icons.euro_rounded,
                                      color: Colors.blue[900],
                                      size: 30,
                                    ),
                                    padding: EdgeInsets.all(12),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "Crypto",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
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
                                        fontSize: 12,
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
                                      Icons.notification_important,
                                      color: Colors.blue[900],
                                      size: 30,
                                    ),
                                    padding: EdgeInsets.all(12),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "Notification",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                        color: Colors.blue[100]),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              //logOut();
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
                            SizedBox(
                              height: 10,
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
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              qrResult,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18.0, color: Color(0xff001a33)),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Form(
                              key: _formkey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          style: TextStyle(
                                            color: Color(0xff001a33),
                                          ),
                                          onChanged: (String str) {
                                            setState(() {
                                              _valueTND = str;
                                            });
                                          },
                                          controller: _amount,
                                          decoration: InputDecoration(
                                            hintText: '0.00',
                                            hintStyle: TextStyle(
                                                fontFamily: 'Montserrat',
                                                color: Color(0xff001a33)),
                                            filled: true,
                                            contentPadding:
                                                EdgeInsets.all(16.0),
                                            prefixIcon:
                                                Icon(Icons.title_rounded),
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
                                margin: EdgeInsets.only(top: 25),
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Radio(
                                          activeColor: Colors.black,
                                          onChanged: (v) {
                                            setState(() {
                                              _devis = v;
                                            });
                                          },
                                          groupValue: _devis,
                                          value: 'TND',
                                        ),
                                        Text(
                                          'TND',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Radio(
                                          activeColor: Colors.black,
                                          onChanged: (v) {
                                            setState(() {
                                              _devis = v;
                                            });
                                          },
                                          groupValue: _devis,
                                          value: 'EUR',
                                        ),
                                        Text(
                                          'EUR',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ],
                                )),
                            Row(
                              children: [
                                Container(
                                  width: ((MediaQuery.of(context).size.width) -
                                          80) /
                                      3,
                                  margin: EdgeInsets.only(top: 25),
                                  child: Text(
                                    '$_valueTND TNC',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                Container(
                                  height: 30,
                                  width: ((MediaQuery.of(context).size.width) -
                                          80) /
                                      3,
                                  child: Icon(
                                    Icons.double_arrow_outlined,
                                    size: 50,
                                    color: Colors.black,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 25),
                                  width: ((MediaQuery.of(context).size.width) -
                                          80) /
                                      3,
                                  child: Text(
                                    '$_converted $_devis',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0)),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 43.0,
                              child: FlatButton(
                                child: Text(
                                  'Send',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w900,
                                    fontSize: 24,
                                  ),
                                ),
                                color: Color(0xff0069CC),
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Color(0xff0069CC),
                                        width: 1,
                                        style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(5)),
                                onPressed: () async {
                                  if (_formkey.currentState.validate()) {
                                    print("hello ");

                                    String amount = _amount.text;

                                    String id = _user.id;

                                    print("id!!!! : " + id);
                                    print("buy!!!! : " + amount.toString());

                                    await SendAmount(id, amount, qrResult);
                                    _showNotification(amount);
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

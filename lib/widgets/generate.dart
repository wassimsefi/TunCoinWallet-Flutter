import 'package:TunCoinWallet/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:TunCoinWallet/pages/menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:TunCoinWallet/Model/user_model.dart';

class Generate extends StatefulWidget {
  @override
  _GenerateState createState() => _GenerateState();
}

class _GenerateState extends State<Generate> {
  String id = "";
  User _user;

  String qrCode = 'Unknown';

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
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Generate"),
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
            icon: Icon(Icons.qr_code_rounded),
            color: Color(0xff001a33),
            onPressed: () {
              print("wessssssssssss....");
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(50.0),
        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Text(
                "QR CODE WALLET :",
                style: TextStyle(
                  color: Color(0xff001a33),
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            Center(
              child: QrImage(
                data: _user.id,
                size: 150,
              ),
            ),

            // Text(
            //   "Get your data to QR CODE",
            //   style: TextStyle(
            //     color: Color(0xff001a33),
            //   ),
            // ),
            SizedBox(
              height: 10.0,
            ),
            // TextField(
            //   controller: qrText,
            //   decoration: InputDecoration(
            //     hintText: 'Enter the data',
            //     fillColor: Color(0xff001a33),
            //     hintStyle: TextStyle(
            //       fontFamily: 'Montserrat',
            //       color: Colors.grey[200],
            //     ),
            //     filled: true,
            //     contentPadding: EdgeInsets.all(16.0),
            //     prefixIcon: Icon(
            //       Icons.qr_code,
            //     ),
            //   ),
            // ),
            SizedBox(
              height: 10.0,
            ),
            // FlatButton(
            //   padding: EdgeInsets.symmetric(horizontal: 40),
            //   onPressed: () {
            //     if (qrText.text.isEmpty) {
            //       setState(() {
            //         qrData = "https://flutter.dev";
            //       });
            //     } else {
            //       setState(() {
            //         qrData = qrText.text;
            //       });
            //     }
            //   },
            //   child: Text('GENERATE QR CODE',
            //       style: TextStyle(
            //         fontSize: 16,
            //         letterSpacing: 2.2,
            //         color: Color(0xff001a33),
            //       )),
            //   textColor: Color(0xff001a33),
            //   shape: RoundedRectangleBorder(
            //       side: BorderSide(
            //           color: Color(0xff001a33),
            //           width: 1,
            //           style: BorderStyle.solid),
            //       borderRadius: BorderRadius.circular(50)),
            // ),
          ],
        ),
      ),
    );
  }

  final qrText = TextEditingController();
}

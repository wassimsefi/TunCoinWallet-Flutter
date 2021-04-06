import 'package:TunCoinWallet/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:TunCoinWallet/pages/menu.dart';

class Generate extends StatefulWidget {
  @override
  _GenerateState createState() => _GenerateState();
}

class _GenerateState extends State<Generate> {
  String qrData = "https://github.com/wass";
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
        padding: EdgeInsets.all(20.0),
        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: QrImage(
                data: qrData,
                size: 200,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              "Get your data to QR CODE",
              style: TextStyle(
                color: Color(0xff001a33),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextField(
              controller: qrText,
              decoration: InputDecoration(
                hintText: 'Enter the data',
                fillColor: Color(0xff001a33),
                hintStyle: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.grey[200],
                ),
                filled: true,
                contentPadding: EdgeInsets.all(16.0),
                prefixIcon: Icon(
                  Icons.qr_code,
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            FlatButton(
              padding: EdgeInsets.symmetric(horizontal: 40),
              onPressed: () {
                if (qrText.text.isEmpty) {
                  setState(() {
                    qrData = "https://flutter.dev";
                  });
                } else {
                  setState(() {
                    qrData = qrText.text;
                  });
                }
              },
              child: Text('GENERATE QR CODE',
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
          ],
        ),
      ),
    );
  }

  final qrText = TextEditingController();
}

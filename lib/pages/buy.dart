import 'package:TunCoinWallet/pages/home.dart';
import 'package:TunCoinWallet/pages/login.dart';
import 'package:TunCoinWallet/pages/menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'dart:async';

import 'package:flutter/services.dart';

class BuyPage extends StatefulWidget {
  @override
  _BuyPageState createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff001a33),
      appBar: AppBar(
        title: Text("Buy"),
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
            icon: Icon(Icons.get_app_rounded),
            color: Color(0xff001a33),
            onPressed: () {
              print("wessssssssssss....");
            },
          ),
        ],
      ),
    );
  }
}

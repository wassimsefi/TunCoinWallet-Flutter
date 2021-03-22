import 'package:TunCoinWallet/pages/accueil.dart';
import 'package:TunCoinWallet/pages/menu.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{};

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TunCoin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
        bottomAppBarColor: Colors.white,
        bottomAppBarTheme: BottomAppBarTheme(color: Colors.white),
        brightness: Brightness.dark,
        hintColor: Colors.white,
      ),
      home: SplashScreen(),
      routes: routes,
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String id = "";

  Future getId() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id');
    // print("acceuil : " + id);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
    getId();
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 6), onDoneLoading);
  }

  onDoneLoading() async {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => id == null ? Accueilpage() : Menu()));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Color(0xff001a33),
        body: Column(
          children: <Widget>[
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 200),
                child: new Image.asset('assets/logo1.png',
                    width: 350, height: 350),
              ),
              // child: new Image.asset('assets/LogoApp.png'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
              child: Container(
                child: CircularProgressIndicator(),
              ),
            )
          ],
        ));
  }
}

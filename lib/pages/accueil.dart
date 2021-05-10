import 'package:TunCoinWallet/pages/login.dart';
import 'package:TunCoinWallet/pages/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'menu.dart';

class Accueilpage extends StatefulWidget {
  @override
  _AccueilpageState createState() => _AccueilpageState();
}

class _AccueilpageState extends State<Accueilpage> {
  @override
  Widget build(BuildContext context) {
    double d = MediaQuery.of(context).size.height;

    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xff001a33),
      body: new ListView(
        padding: new EdgeInsets.symmetric(vertical: 20.0),
        children: <Widget>[
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  Image.asset('assets/photo1.png', width: 350, height: 400),
                ],
              ),
            ),
          ),
          SizedBox(height: 80),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Column(
                children: [
                  Container(
                    width: 300.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        stops: [0.1, 0.9],
                        colors: [
                          Color(0xff1d83ab),
                          Color(0xff13f4ef),
                          //Color.fromRGBO(19, 244, 239, 1),
                        ],
                      ),
                    ),
                    child: FlatButton(
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      textColor: Colors.white,
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => LoginPage()));

                        // } else {

                        //Navigator.pushNamed(context, HomePage.tag);

                        // }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Column(
                children: [
                  Container(
                    width: 300.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
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
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 17.0,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Color(0xff001a33),
                        ),
                      ),
                      textColor: Colors.white,
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => SignupPage()));

                        // } else {

                        //Navigator.pushNamed(context, HomePage.tag);

                        // }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:TunCoinWallet/Model/user_model.dart';
import 'package:TunCoinWallet/pages/home.dart';
import 'package:TunCoinWallet/pages/login.dart';
import 'package:TunCoinWallet/pages/menu.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'dart:async';

import 'package:flutter/services.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool hidePassword = true;
  bool hidePassword2 = true;
  UserModel _user;
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmpas = TextEditingController();

  Future<UserModel> createUser(String email, String password) async {
    final String apiUrl = "http://tuncoin.herokuapp.com/signup";
    final Response =
        await http.post(apiUrl, body: {"email": email, "password": password});

    if (Response.statusCode == 200) {
      final String responseString = Response.body;
      return userModelFromJson(responseString);
    } else if (Response.statusCode == 401) {
      throw Exception(showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Sigup Up In Error'),
          content: Text(
            'Mail Exists',
            style: TextStyle(fontSize: 20.0, color: Colors.red),
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: Text('OK'))
          ],
        ),
      ));

      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff001a33),
        body: ListView(
          children: <Widget>[
            Column(
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                SafeArea(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(top: 10.0)),
                        Image.asset('assets/logo1.png',
                            width: 350, height: 250),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 1.0),
                    child: Card(
                      color: Color(0xff113768),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(50.0))),
                      elevation: 10.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                          Row(
                            //    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              SizedBox(width: 20),
                              Container(
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
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Blockchain Wallet",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          Text(
                            "Be Your Own Bank",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                color: Colors.blue[100]),
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
                          Form(
                            key: _formkey,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: TextFormField(
                                    controller: _email,
                                    decoration: InputDecoration(
                                      hintText: 'Email',
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0))),
                                      hintStyle:
                                          TextStyle(fontFamily: 'Montserrat'),
                                      filled: true,
                                      contentPadding: EdgeInsets.all(16.0),
                                      prefixIcon:
                                          Icon(Icons.person_outline_outlined),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return "Please entre email ";
                                      }
                                      if (!RegExp(
                                              "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}")
                                          .hasMatch(value)) {
                                        return "email invalide ";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: TextFormField(
                                    controller: _password,
                                    decoration: InputDecoration(
                                      hintText: 'Password',
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0))),
                                      hintStyle:
                                          TextStyle(fontFamily: 'Montserrat'),
                                      filled: true,
                                      contentPadding: EdgeInsets.all(16.0),
                                      prefixIcon: Icon(Icons.lock_outline),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            hidePassword = !hidePassword;
                                          });
                                        },
                                        icon: Icon(hidePassword
                                            ? Icons.visibility_off
                                            : Icons.visibility),
                                      ),
                                    ),
                                    keyboardType: TextInputType.text,
                                    obscureText: hidePassword,
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return "Please entre Password ";
                                      }
                                      if (value.length < 8) {
                                        return "min 8 caractères ";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: TextFormField(
                                    controller: _confirmpas,
                                    decoration: InputDecoration(
                                      hintText: 'Confirm Password',
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0))),
                                      hintStyle:
                                          TextStyle(fontFamily: 'Montserrat'),
                                      filled: true,
                                      contentPadding: EdgeInsets.all(16.0),
                                      prefixIcon: Icon(Icons.lock_outline),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            hidePassword2 = !hidePassword2;
                                          });
                                        },
                                        icon: Icon(hidePassword2
                                            ? Icons.visibility_off
                                            : Icons.visibility),
                                      ),
                                    ),
                                    keyboardType: TextInputType.text,
                                    obscureText: hidePassword,
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return "Please entre Password ";
                                      }
                                      if (_password.text != _confirmpas.text) {
                                        return "error confirm password ";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
                          Container(
                            width: 330.0,
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
                                'Create wallet',
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
                              onPressed: () async {
                                if (_formkey.currentState.validate()) {
                                  print("hello ");

                                  final String email = _email.text;
                                  final String password = _password.text;
                                  final UserModel user =
                                      await createUser(email, password);

                                  setState(() {
                                    _user = user;
                                  });
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()));
                                } else {
                                  return;
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()));
                                },
                                child: Text(
                                  "New Account TunCoin",
                                  style: TextStyle(color: Colors.grey),
                                )),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ],
        ));
  }
}

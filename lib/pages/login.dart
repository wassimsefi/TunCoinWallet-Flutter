import 'package:TunCoinWallet/Model/user_model.dart';
import 'package:TunCoinWallet/pages/home.dart';
import 'package:TunCoinWallet/pages/menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var id = prefs.getString('id');
  print("login iddd : " + id);
  runApp(MaterialApp(home: id == "" ? LoginPage() : Menu()));
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool hidePassword = true;
  UserModel _user;
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

// FingerPrint

  LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometric;
  List<BiometricType> _availableBiometric;
  String autherized = "Not autherized";

  Future<void> _checkBiometric() async {
    bool canCheckBiometric;
    try {
      canCheckBiometric = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometric;
    try {
      availableBiometric = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _availableBiometric = availableBiometric;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticateWithBiometrics(
        localizedReason: "Scan your finger print to authenticate",
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      return showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Log In Error'),
          content: Text(
            'Account not found please try again',
            style: TextStyle(fontSize: 20.0, color: Colors.red),
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: Text('OK'))
          ],
        ),
      );
    }
    if (!mounted) return;

    setState(() {
      autherized =
          authenticated ? "Autherized success" : "Failed to authenticate";
    });

    print('wwwwwwwww : ' + authenticated.toString());
    if (authenticated) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Menu()));
      print('wassim wassim true........ ');
    } else {
      print('wassim wassim false........ ');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _checkBiometric();
    _getAvailableBiometrics();
  }

  Future<UserModel> loginUser(String email, String password) async {
    final String apiUrl = "https://tuncoin.herokuapp.com/login";
    final Response =
        await http.post(apiUrl, body: {"email": email, "password": password});

    if (Response.statusCode == 200) {
      final String responseString = Response.body;
      return userModelFromJson(responseString);
    } else if (Response.statusCode == 401) {
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
                SizedBox(height: 50),
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
                          Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0)),
                          Center(
                            child: Text(
                              'Welcome Back!',
                              style: TextStyle(
                                  color: Color(0xff13f4ef),
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'),
                            ),
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
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

                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
                          Container(
                            width: 150.0,
                            height: 43.0,
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
                              onPressed: () async {
                                if (_formkey.currentState.validate()) {
                                  print("hello ");

                                  final String email = _email.text;
                                  final String password = _password.text;
                                  print("hello 2");
                                  final UserModel user =
                                      await loginUser(email, password);
                                  print("login " + email + " " + password);

                                  setState(() {
                                    _user = user;
                                  });
                                  print("login id " + _user.user.id);
                                  print("user : " + userModelToJson(_user));

                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setString('id', _user.user.id);

                                  return showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("ID Wallet : \n"),
                                          content: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 16.0),
                                              child: Column(
                                                children: <Widget>[
                                                  Text(
                                                    'Or',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontSize: 20.0),
                                                  ),
                                                  IconButton(
                                                    icon:
                                                        Icon(Icons.fingerprint),
                                                    onPressed: _authenticate,
                                                    iconSize: 50.0,
                                                  ),
                                                ],
                                              )),
                                          actions: [
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("Close")),
                                          ],
                                          backgroundColor: Color(0xff001a33),
                                        );
                                      });
                                } else {
                                  return;
                                }
                              },
                            ),
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

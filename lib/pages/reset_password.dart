import 'package:TunCoinWallet/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool hidePassword = true;
  bool hidePassword2 = true;
  TextEditingController _confirmpas = TextEditingController();
  TextEditingController _code = TextEditingController();
  TextEditingController _password = TextEditingController();

  Future resetpassword(String code, String password) async {
    final String apiUrl = "https://tuncoin.herokuapp.com/resetPassword";
    // double amount1 = double.parse(amount);
    final Response =
        await http.put(apiUrl, body: {"password": password, "resetCode": code});

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
                        'password updated ',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      RaisedButton(
                        onPressed: () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => LoginPage())),
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
            'mail not found! ',
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff001a33),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formkey,
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'Forget Password !!!',
                      style: TextStyle(
                          color: Color(0xff13f4ef),
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: TextFormField(
                      controller: _code,
                      decoration: InputDecoration(
                        hintText: 'Code',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0))),
                        hintStyle: TextStyle(fontFamily: 'Montserrat'),
                        filled: true,
                        contentPadding: EdgeInsets.all(16.0),
                        prefixIcon: Icon(Icons.person_outline_outlined),
                      ),
                      keyboardType: TextInputType.text,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Please entre code ";
                        }

                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                    child: TextFormField(
                      controller: _password,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0))),
                        hintStyle: TextStyle(fontFamily: 'Montserrat'),
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
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: TextFormField(
                      controller: _confirmpas,
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0))),
                        hintStyle: TextStyle(fontFamily: 'Montserrat'),
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
                  Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
                  Container(
                    width: 320.0,
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
                        'New Password',
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

                          final String code = _code.text;
                          final String password = _password.text;
                          print("code : " + code);
                          print("password" + password);

                          await resetpassword(code, password);
                        } else {
                          return;
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

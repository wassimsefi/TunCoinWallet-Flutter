import 'package:TunCoinWallet/Model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:TunCoinWallet/pages/reset_password.dart';
import 'package:http/http.dart' as http;

class ForgetPasswordPage extends StatefulWidget {
  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();

  Future forgetpassword(String email) async {
    final String apiUrl = "https://tuncoin.herokuapp.com/forgotPassword";
    // double amount1 = double.parse(amount);
    final Response = await http.put(apiUrl, body: {"email": email});

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
                        'Check you e-mail : \n ' + email,
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      RaisedButton(
                        onPressed: () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => ResetPasswordPage())),
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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Color(0xff001a33),
      ),
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
                      controller: _email,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0))),
                        hintStyle: TextStyle(fontFamily: 'Montserrat'),
                        filled: true,
                        contentPadding: EdgeInsets.all(16.0),
                        prefixIcon: Icon(Icons.person_outline_outlined),
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
                        'Send',
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
                          print("hello 2");
                          await forgetpassword(email);
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

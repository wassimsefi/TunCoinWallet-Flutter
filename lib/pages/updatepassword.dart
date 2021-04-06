import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:TunCoinWallet/pages/menu.dart';

import 'package:TunCoinWallet/Model/user_model.dart';
import 'package:http/http.dart' as http;

class UpdatepasswordPage extends StatefulWidget {
  @override
  _UpdatepasswordPageState createState() => _UpdatepasswordPageState();
}

class _UpdatepasswordPageState extends State<UpdatepasswordPage> {
  String id = "";
  User _user;

  bool hidePassword = true;
  bool hidePassword2 = true;
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmpas = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  Future<User> updateUser(String id, String password) async {
    final String apiUrl = "https://tuncoin.herokuapp.com/updatePassword";
    final Response =
        await http.patch(apiUrl, body: {"id": id, "password": password});

    if (Response.statusCode == 200) {
      final String responseString = Response.body;
      return userFromJson(responseString);
    } else if (Response.statusCode == 401) {
      throw Exception(showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('update Up In Error'),
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
    }
  }

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
        backgroundColor: Color(0xff001a33),
        appBar: AppBar(
          title: Text("Update password"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Color(0xff001a33),
            ),
            onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Menu())),
          ),
          backgroundColor: Color(0xff13f4ef),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.article_outlined),
              color: Color(0xff001a33),
              onPressed: () {
                print("wessssssssssss....");
              },
            ),
          ],
        ),
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
                          Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                          Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
                          Form(
                            key: _formkey,
                            child: Column(
                              children: [
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
                                'Update',
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

                                  final String id = _user.id;

                                  final String password = _password.text;
                                  print("hello " + id + "pass: " + password);
                                  final User user =
                                      await updateUser(id, password);

                                  setState(() {
                                    _user = user;
                                  });
                                  print("hello111 ");

                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => Menu()));
                                } else {
                                  return;
                                }
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                          )
                        ],
                      ),
                    ))
              ],
            ),
          ],
        ));
  }
}

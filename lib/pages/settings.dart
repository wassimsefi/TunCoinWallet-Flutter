import 'package:TunCoinWallet/Model/user_model.dart';
import 'package:TunCoinWallet/pages/accueil.dart';
import 'package:TunCoinWallet/pages/news.dart';
import 'package:TunCoinWallet/widgets/Scan.dart';
import 'package:TunCoinWallet/widgets/generate.dart';
import 'package:TunCoinWallet/pages/Updatepassword.dart';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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

  Future logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('id');
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Accueilpage()));
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
        backgroundColor: Color(0xff001a33),
        elevation: 1,
        title: Text("Settings"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Color(0xff13f4ef),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Account",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff001a33),
                  ),
                ),
              ],
            ),
            Divider(
              height: 15,
              thickness: 2,
            ),
            SizedBox(
              height: 10,
            ),
            buildAccountOptionRowID(context),
            buildAccountOptionRowQRCodeGenerator(),
            buildAccountOptionRowQRCodeScanner(context),
            buildAccountOptionRowScoial(context),
            buildAccountOptionRowLanguage(context),
            buildAccountOptionRowChangedpwd(context),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Icon(
                  Icons.volume_up_outlined,
                  color: Color(0xff13f4ef),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Notifications",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff001a33)),
                ),
              ],
            ),
            Divider(
              height: 15,
              thickness: 2,
            ),
            SizedBox(
              height: 10,
            ),
            buildNotificationOptionRow("New for you", true),
            buildNotificationOptionRow("Account activity", true),
            buildNotificationOptionRow("Opportunity", false),
            SizedBox(
              height: 50,
            ),
            Center(
                child: FlatButton(
              padding: EdgeInsets.symmetric(horizontal: 40),
              onPressed: () {
                logOut();
              },
              child: Text('SIGN OUT',
                  style: TextStyle(
                    fontSize: 16,
                    letterSpacing: 2.2,
                    color: Colors.white,
                  )),
              color: Color(0xffF52F20),
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: Color(0xffF52F20),
                      width: 1,
                      style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(50)),
            ))
          ],
        ),
      ),
    );
  }

  Row buildNotificationOptionRow(String title, bool isActive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700]),
        ),
        Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              value: isActive,
              onChanged: (bool val) {},
            ))
      ],
    );
  }

  GestureDetector buildAccountOptionRow(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AdvanceCustomAlert();
            });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector buildAccountOptionRowScoial(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Social"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Icon(
                              Icons.web_asset_rounded,
                              size: 18,
                            ),
                          ),
                          TextSpan(
                            text: " http://www.TunCoin.tn",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Social",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector buildAccountOptionRowQRCodeScanner(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Scan())),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "QR Code Scanner",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector buildAccountOptionRowQRCodeGenerator() {
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Generate())),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "QR Code",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector buildAccountOptionRowID(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("ID Wallet : \n"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _user.id,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
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
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "ID Wallet",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector buildAccountOptionRowLanguage(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Language"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Anglais"),
                  ],
                ),
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
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Language",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector buildAccountOptionRowChangedpwd(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => UpdatepasswordPage())),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Update Password ",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  // Future scanQRCode() async {
  //   try {
  //     final qrCode = await FlutterBarcodeScanner.scanBarcode(
  //         "#ff6666", "Cancel", true, ScanMode.QR);
  //     print(qrCode);

  //     if (!mounted) return;
  //     setState(() {
  //       this.qrCode = qrCode;
  //     });
  //   } on PlatformException {
  //     qrCode = 'failed to get platform version. ';
  //   }
  // }
}

class AdvanceCustomAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Color(0xff001a33),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        child: Stack(
          overflow: Overflow.visible,
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: 250,
              width: 350,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
                child: Column(
                  children: [
                    Text(
                      'Warning !!!',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'You can not access this file',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
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
        ));
  }
}

import 'package:TunCoinWallet/Model/user_model.dart';
import 'package:TunCoinWallet/pages/Crypto.dart';
import 'package:TunCoinWallet/pages/accueil.dart';
import 'package:TunCoinWallet/pages/news.dart';
import 'package:TunCoinWallet/pages/portfolio.dart';
import 'package:TunCoinWallet/pages/send.dart';
import 'package:TunCoinWallet/pages/sign_up.dart';
import 'package:TunCoinWallet/pages/statistical%20.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import 'buy.dart';
import 'notification.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  String id = "";
  User _user;

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

  List<Transaction> buyingList = new List();
  List<Transaction> sendingList = new List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getId();
    _tabController = new TabController(vsync: this, length: 3);

    print('hello');
  }

  @override
  Widget build(BuildContext context) {
    print('transaction length ' + (_user.transaction.length).toString());
    print(transactionToJson(_user.transaction[1]));
    for (var i = 0; i < _user.transaction.length; i++) {
      if (_user.transaction[i].typeTransaction == "Buying") {
        print("yes \i");
        print(transactionToJson(_user.transaction[i]));
        buyingList.add(_user.transaction[i]);
      } else {
        print("no \i");

        sendingList.add(_user.transaction[i]);
      }
    }

    print(transactionToJson(sendingList[3]));
    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          FutureBuilder(
            future: getUser(id),
            builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
              if (snapshot.hasData) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 32, vertical: 60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            _user.balance.toString() + " TNC",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.w700),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                InkWell(
                                  child: Container(
                                    child: Icon(
                                      Icons.notifications,
                                      color: Colors.lightBlue[100],
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NotificationPage()));
                                  },
                                ),
                                SizedBox(
                                  width: 16,
                                ),
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
                          )
                        ],
                      ),
                      Text(
                        "Available Balance",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.blue[100]),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          InkWell(
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(243, 245, 248, 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(18))),
                                    child: Icon(
                                      Icons.article_rounded,
                                      color: Colors.blue[900],
                                      size: 30,
                                    ),
                                    padding: EdgeInsets.all(12),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "News",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color: Colors.blue[100]),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () async {
                              print("object : " + id);
                              print("home mail " + _user.email);

                              print("length transaction  " +
                                  _user.transaction.length.toString());

                              print("balance mail " + _user.balance.toString());

                              print("user : " + userToJson(_user));
                              //  final Transaction _transaction =  userToJson(_user)[]

                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => NewsPage()));
                            },
                          ),
                          InkWell(
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(243, 245, 248, 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(18))),
                                    child: Icon(
                                      Icons.euro_rounded,
                                      color: Colors.blue[900],
                                      size: 30,
                                    ),
                                    padding: EdgeInsets.all(12),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "Crypto",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color: Colors.blue[100]),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => Cryptopage()));
                            },
                          ),
                          InkWell(
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(243, 245, 248, 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(18))),
                                    child: Icon(
                                      Icons.stacked_bar_chart,
                                      color: Colors.blue[900],
                                      size: 30,
                                    ),
                                    padding: EdgeInsets.all(12),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "Statistical",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color: Colors.blue[100]),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => SatisticalPage()));
                            },
                          ),
                          InkWell(
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(243, 245, 248, 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(18))),
                                    child: Icon(
                                      Icons.logout,
                                      color: Colors.blue[900],
                                      size: 30,
                                    ),
                                    padding: EdgeInsets.all(12),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "LogOut",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color: Colors.blue[100]),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              logOut();
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          FutureBuilder(
            future: getUser(id),
            builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
              if (snapshot.hasData) {
                return DraggableScrollableSheet(
                  builder: (context, scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(245, 245, 245, 1),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40))),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 24,
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Recent Transactions",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 24,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    "See all",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                        color: Colors.grey[800]),
                                  )
                                ],
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 32),
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            ListView(
                              shrinkWrap: true,
                              padding: EdgeInsets.only(left: 10.0, right: 0.0),
                              children: <Widget>[
                                SizedBox(height: 15.0),
                                TabBar(
                                    controller: _tabController,
                                    indicatorColor: Colors.amber,
                                    labelColor: Color(0xFFC88D67),
                                    isScrollable: true,
                                    labelPadding:
                                        EdgeInsets.only(right: 30.0, left: 30),
                                    unselectedLabelColor: Color(0xFFCDCDCD),
                                    tabs: [
                                      Tab(
                                        child: Text('All',
                                            style: TextStyle(
                                              fontFamily: 'Varela',
                                              fontSize: 21.0,
                                            )),
                                      ),
                                      Tab(
                                        child: Text('Buying',
                                            style: TextStyle(
                                              fontFamily: 'Varela',
                                              fontSize: 21.0,
                                            )),
                                      ),
                                      Tab(
                                        child: Text('Sending',
                                            style: TextStyle(
                                              fontFamily: 'Varela',
                                              fontSize: 21.0,
                                            )),
                                      )
                                    ]),
                                Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.75,
                                    width: double.infinity,
                                    child: TabBarView(
                                        controller: _tabController,
                                        children: [
                                          Container(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount:
                                                  _user.transaction.length,
                                              padding: EdgeInsets.all(0),
                                              controller: ScrollController(
                                                  keepScrollOffset: false),
                                              itemBuilder: (context, index) {
                                                // if (_user.transaction.length == 0) {
                                                //   print("nullll !!!!!!!!!");
                                                //   return Center(
                                                //     child: Text(
                                                //       "Null !!!!!!",
                                                //       style: TextStyle(
                                                //           fontSize: 15,
                                                //           fontWeight: FontWeight.w700,
                                                //           color: Colors.grey[500]),
                                                //     ),
                                                //   );
                                                // }

                                                Transaction _transaction =
                                                    _user.transaction[index];

                                                return Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 32,
                                                      vertical: 10),
                                                  padding: EdgeInsets.all(16),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20))),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .grey[100],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            18))),
                                                        child: Icon(
                                                          _transaction.typeTransaction ==
                                                                  "Buying"
                                                              ? Icons
                                                                  .send_rounded
                                                              : Icons
                                                                  .get_app_rounded,
                                                          color: Colors
                                                              .lightBlue[900],
                                                        ),
                                                        padding:
                                                            EdgeInsets.all(12),
                                                      ),
                                                      SizedBox(
                                                        width: 16,
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Text(
                                                              _transaction
                                                                  .typeTransaction,
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: Colors
                                                                          .grey[
                                                                      900]),
                                                            ),
                                                            Text(
                                                              "Payment from Saad",
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: Colors
                                                                          .grey[
                                                                      500]),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: <Widget>[
                                                          Text(
                                                            _transaction.amount
                                                                    .toString() +
                                                                " TNC",
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: _transaction.typeTransaction ==
                                                                        "Buying"
                                                                    ? Colors
                                                                        .lightGreen
                                                                    : Colors
                                                                        .orange),
                                                          ),
                                                          Text(
                                                            _transaction
                                                                    .date.day
                                                                    .toString() +
                                                                "/" +
                                                                _transaction
                                                                    .date.month
                                                                    .toString(),
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Colors
                                                                    .grey[500]),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          Container(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: buyingList.length,
                                              padding: EdgeInsets.all(0),
                                              controller: ScrollController(
                                                  keepScrollOffset: false),
                                              itemBuilder: (context, index) {
                                                // if (_user.transaction.length == 0) {
                                                //   print("nullll !!!!!!!!!");
                                                //   return Center(
                                                //     child: Text(
                                                //       "Null !!!!!!",
                                                //       style: TextStyle(
                                                //           fontSize: 15,
                                                //           fontWeight: FontWeight.w700,
                                                //           color: Colors.grey[500]),
                                                //     ),
                                                //   );
                                                // }

                                                Transaction _transaction =
                                                    buyingList[index];

                                                return Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 32,
                                                      vertical: 10),
                                                  padding: EdgeInsets.all(16),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20))),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .grey[100],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            18))),
                                                        child: Icon(
                                                          _transaction.typeTransaction ==
                                                                  "Buying"
                                                              ? Icons
                                                                  .send_rounded
                                                              : Icons
                                                                  .get_app_rounded,
                                                          color: Colors
                                                              .lightBlue[900],
                                                        ),
                                                        padding:
                                                            EdgeInsets.all(12),
                                                      ),
                                                      SizedBox(
                                                        width: 16,
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Text(
                                                              _transaction
                                                                  .typeTransaction,
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: Colors
                                                                          .grey[
                                                                      900]),
                                                            ),
                                                            Text(
                                                              "Payment from Saad",
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: Colors
                                                                          .grey[
                                                                      500]),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: <Widget>[
                                                          Text(
                                                            _transaction.amount
                                                                    .toString() +
                                                                " TNC",
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: _transaction.typeTransaction ==
                                                                        "Buying"
                                                                    ? Colors
                                                                        .lightGreen
                                                                    : Colors
                                                                        .orange),
                                                          ),
                                                          Text(
                                                            _transaction
                                                                    .date.day
                                                                    .toString() +
                                                                "/" +
                                                                _transaction
                                                                    .date.month
                                                                    .toString(),
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Colors
                                                                    .grey[500]),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          Container(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: sendingList.length,
                                              padding: EdgeInsets.all(0),
                                              controller: ScrollController(
                                                  keepScrollOffset: false),
                                              itemBuilder: (context, index) {
                                                // if (_user.transaction.length == 0) {
                                                //   print("nullll !!!!!!!!!");
                                                //   return Center(
                                                //     child: Text(
                                                //       "Null !!!!!!",
                                                //       style: TextStyle(
                                                //           fontSize: 15,
                                                //           fontWeight: FontWeight.w700,
                                                //           color: Colors.grey[500]),
                                                //     ),
                                                //   );
                                                // }

                                                Transaction _transaction =
                                                    sendingList[index];

                                                return Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 32,
                                                      vertical: 10),
                                                  padding: EdgeInsets.all(16),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20))),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .grey[100],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            18))),
                                                        child: Icon(
                                                          _transaction.typeTransaction ==
                                                                  "Buying"
                                                              ? Icons
                                                                  .send_rounded
                                                              : Icons
                                                                  .get_app_rounded,
                                                          color: Colors
                                                              .lightBlue[900],
                                                        ),
                                                        padding:
                                                            EdgeInsets.all(12),
                                                      ),
                                                      SizedBox(
                                                        width: 16,
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Text(
                                                              _transaction
                                                                  .typeTransaction,
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: Colors
                                                                          .grey[
                                                                      900]),
                                                            ),
                                                            Text(
                                                              "Payment from Saad",
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: Colors
                                                                          .grey[
                                                                      500]),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: <Widget>[
                                                          Text(
                                                            _transaction.amount
                                                                    .toString() +
                                                                " TNC",
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: _transaction.typeTransaction ==
                                                                        "Buying"
                                                                    ? Colors
                                                                        .lightGreen
                                                                    : Colors
                                                                        .orange),
                                                          ),
                                                          Text(
                                                            _transaction
                                                                    .date.day
                                                                    .toString() +
                                                                "/" +
                                                                _transaction
                                                                    .date.month
                                                                    .toString(),
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Colors
                                                                    .grey[500]),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ]))
                              ],
                            ),
                          ],
                        ),
                        controller: scrollController,
                      ),
                    );
                  },
                  initialChildSize: 0.65,
                  minChildSize: 0.65,
                  maxChildSize: 1,
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          //Container for top data

          //draggable sheet
        ],
      ),
    );
  }
}

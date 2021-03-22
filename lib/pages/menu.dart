import 'package:TunCoinWallet/pages/home.dart';
import 'package:TunCoinWallet/pages/login.dart';
import 'package:TunCoinWallet/pages/portfolio.dart';
import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  var screens = [
    Homepage(),
    Portfoliopage(),
  ]; //screens for each tab

  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    var bottomNavigationBarItem2 = BottomNavigationBarItem(
      icon: Icon(Icons.credit_card),
      title: Text("Cryptocurrency"),
    );
    var bottomNavigationBarItem = bottomNavigationBarItem2;
    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 26, 51, 1),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromRGBO(0, 26, 51, 1),
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Color(0xff13f4ef),
            ),
            title: Text("Home",
                style: new TextStyle(
                  color: const Color(0xff13f4ef),
                )),
          ),
          bottomNavigationBarItem,
        ],
        onTap: (index) {
          setState(() {
            selectedTab = index;
          });
        },
        showUnselectedLabels: true,
        iconSize: 30,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff13f4ef),
        onPressed: () {},
        elevation: 0,
        child: Icon(
          Icons.add,
          color: Color(0xff001a33),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: screens[selectedTab],
    );
  }
}

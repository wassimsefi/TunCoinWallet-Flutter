import 'package:TunCoinWallet/pages/buy.dart';
import 'package:TunCoinWallet/pages/home.dart';
import 'package:TunCoinWallet/pages/login.dart';
import 'package:TunCoinWallet/pages/news.dart';
import 'package:TunCoinWallet/pages/portfolio.dart';
import 'package:TunCoinWallet/pages/send.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  var screens = [
    Homepage(),
    SendPage(),
    BuyPage(),
    Portfoliopage(),
  ]; //screens for each tab

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 26, 51, 1),
      bottomNavigationBar: CurvedNavigationBar(
        color: Color.fromRGBO(0, 26, 51, 1),
        height: 65,
        backgroundColor: Colors.grey[200],
        index: selectedIndex,
        items: [
          Icon(Icons.home, color: Colors.grey[200]),
          Icon(Icons.send_rounded, color: Colors.grey[200]),
          Icon(Icons.get_app_rounded, color: Colors.grey[200]),
          Icon(Icons.credit_card_rounded, color: Colors.grey[200]),
        ],
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        animationCurve: Curves.easeInBack,
        animationDuration: const Duration(milliseconds: 300),
      ),
      body: screens[selectedIndex],
    );
  }
}

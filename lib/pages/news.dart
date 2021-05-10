import 'package:TunCoinWallet/Model/article_model.dart';
import 'package:TunCoinWallet/pages/home.dart';
import 'package:TunCoinWallet/pages/login.dart';
import 'package:TunCoinWallet/pages/menu.dart';
import 'package:TunCoinWallet/widgets/customListTile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'dart:async';

import 'package:flutter/services.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  Future<List<Article>> getArticle() async {
    final String apiUrl = "https://tuncoin.herokuapp.com/cryptocurrency/news";
    final Response = await http.get(apiUrl);

    if (Response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(Response.body);

      List<dynamic> body = json['articles'];

      List<Article> articles =
          body.map((dynamic item) => Article.fromJson(item)).toList();
      return articles;
    } else {
      throw ("Can't get the article");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff001a33),
      appBar: AppBar(
        title: Text("News"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) => Menu())),
        ),
        backgroundColor: Color(0xff001a33),
      ),
      body: FutureBuilder(
        future: getArticle(),
        builder: (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
          if (snapshot.hasData) {
            List<Article> articles = snapshot.data;
            return ListView.builder(
                itemCount: articles.length,
                itemBuilder: (context, index) =>
                    customListTile(articles[index], context));
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

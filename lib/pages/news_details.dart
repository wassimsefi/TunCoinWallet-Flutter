import 'package:TunCoinWallet/Model/article_model.dart';
import 'package:TunCoinWallet/pages/news.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsdatailsPage extends StatelessWidget {
  final Article article;
  NewsdatailsPage({this.article});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff001a33),
      appBar: AppBar(
        title: Text(article.title),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => NewsPage())),
        ),
        backgroundColor: Color(0xff001a33),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 250.0,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(article.urlToImage),
                  fit: BoxFit.cover,
                ),
                // borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(9.0),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: InkWell(
                        child: Text(article.source.name),
                        onTap: () async {
                          if (await canLaunch(article.url)) {
                            await launch(article.url);
                          } else
                            // can't launch url, there is some error
                            throw "Could not launch $article.url";
                        }),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    "Description : ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.white),
                  ),
                  Text(
                    article.description,
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    "Content : ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                        color: Colors.white),
                  ),
                  Text(
                    article.content,
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      persistentFooterButtons: [
        Container(
          child: Text(
            article.url,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
        )
      ],
    );
  }
}

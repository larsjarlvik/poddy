import 'package:flutter/material.dart';

import 'package:poddy/pages/homePage.dart';
import 'package:poddy/pages/searchPage.dart';


void main() => runApp(new Poddy());

class Poddy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Poddy',
      theme: new ThemeData(
        brightness: Brightness.light,
        accentColor: Colors.cyan,
      ),
      home: new MainPage()
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => new MainPageState();
}

class MainPageState extends State<MainPage> {
  int index = 1;

  setTab(int index) {
    this.setState(() { this.index = index; });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Row(
          children: [
            new Text("PODDY",
              style: new TextStyle(fontFamily: 'Norwester', color: new Color.fromARGB(255, 50, 50, 50), fontSize: 26.0)
            )
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        backgroundColor: Colors.white,
      ),
      body: new Stack(
        children: <Widget>[
          new Offstage(
            offstage: index != 0,
            child: new TickerMode(enabled: index == 0, child: new HomePage()),
          ),
          new Offstage(
            offstage: index != 1,
            child: new TickerMode(enabled: index == 1, child: new SearchPage()),
          ),
          new Offstage(
            offstage: index != 2,
            child: new TickerMode(enabled: index == 2, child: new SearchPage()),
          ),
        ],
      ),
      bottomNavigationBar: new Container(
        decoration: new BoxDecoration(
          color: Colors.white,
          border: new Border(top: new BorderSide(
            color: Colors.black12,
            width: 0.5
          ))
        ),
        child: new BottomNavigationBar(
          fixedColor: Colors.cyan,
          currentIndex: this.index,
          onTap: setTab,
          items: <BottomNavigationBarItem>[
            new BottomNavigationBarItem(
              icon: new Icon(Icons.rss_feed),
              title: new Text("My Podcasts"),
            ),
            new BottomNavigationBarItem(
              icon: new Icon(Icons.play_arrow),
              title: new Text("Now Playing"),
            ),
            new BottomNavigationBarItem(
              icon: new Icon(Icons.search),
              title: new Text("Search"),
            ),
          ],
        )
      )
    );
  }
}

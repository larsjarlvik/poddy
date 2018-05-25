import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:poddy/pages/homePage.dart';
import 'package:poddy/pages/searchPage.dart';

import 'package:poddy/components/AppBar.dart';


void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  runApp(new Poddy());
}

class Poddy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Poddy',
      color: Colors.white,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        accentColor: const Color(0xFFF850DD),
      ),
      home: new MainPage(),
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
      appBar: buildAppBar(context),
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
      bottomNavigationBar: _buildBottomNavBar(context)
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return new Container(
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
              title: new Text('My Podcasts'),
            ),
            new BottomNavigationBarItem(
              icon: new Icon(Icons.play_arrow),
              title: new Text('Now Playing'),
            ),
            new BottomNavigationBarItem(
              icon: new Icon(Icons.search),
              title: new Text('Search'),
            ),
          ],
        )
    );
  }
}

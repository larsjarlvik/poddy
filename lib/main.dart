import 'package:flutter/material.dart';

import 'package:poddy/pages/home_page.dart';
import 'package:poddy/pages/search_page.dart';
import 'package:poddy/pages/player_page.dart';

void main() {
  runApp(new Poddy());
}

class Poddy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Poddy',
      color: Colors.white,
      theme: new ThemeData(
        primaryColor: const Color(0xFFF850DD),
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
  int page = 1;
  PageController pageController;

  MainPageState() {
    this.pageController =  new PageController(
      initialPage: page,
    );
  }

  setTab(int index) {
    this.pageController.animateToPage(index, 
      duration: const Duration(milliseconds: 300), 
      curve: Curves.easeInOut
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new PageView(
        onPageChanged: (newPage) => this.setState(() => this.page = newPage),
        controller: pageController,
        children: <Widget>[
          new HomePage(),
          new PlayerPage(),
          new SearchPage(),
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
          currentIndex: this.page,
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

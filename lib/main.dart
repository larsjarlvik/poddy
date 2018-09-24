import 'package:flutter/material.dart';

import 'package:poddy/pages/home_page.dart';

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
    pageController = new PageController(
      initialPage: page,
    );
  }

  setTab(int index) {
    pageController.animateToPage(index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new HomePage(),
    );
  }
}

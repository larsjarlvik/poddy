import 'package:flutter/material.dart';

import 'package:poddy/pages/home_page.dart';

void main() {
  runApp(new Poddy());
}

class Poddy extends StatelessWidget {
  final routeObserver = new RouteObserver<PageRoute>();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Poddy',
      color: Colors.white,
      navigatorObservers: [routeObserver],
      theme: new ThemeData(
        primaryColor: const Color(0xFFF850DD),
        accentColor: const Color(0xFFF850DD),
      ),
      home: new Scaffold(
        body: new HomePage(routeObserver)
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:poddy/components/player_bar.dart';

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
      navigatorObservers: [routeObserver],
      theme: new ThemeData(
        primaryColor: const Color(0xFFF850DD),
        accentColor: const Color(0xFFF850DD),
      ),
      home: new Scaffold(
        body: new HomePage(routeObserver),
        bottomNavigationBar: new PlayerBar(),
      ),
    );
  }
}

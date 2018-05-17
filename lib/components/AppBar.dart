import 'package:flutter/material.dart';

AppBar buildAppBar(BuildContext context, { backButton: false }) {
  IconButton leading;

  if (backButton) {
    leading = new IconButton(
      icon: new Icon(Icons.arrow_back), 
      onPressed: () => Navigator.pop(context),
      color: new Color.fromARGB(255, 50, 50, 50),
    );
  }

  var appBar = new AppBar(
    title: new Text("PODDY",
      style: new TextStyle(fontFamily: 'Norwester', color: new Color.fromARGB(255, 50, 50, 50), fontSize: 26.0)
    ),
    backgroundColor: Colors.white,
    leading: leading,
    centerTitle: true
  );

  return appBar;
}

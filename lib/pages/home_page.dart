import 'package:flutter/material.dart';

import 'package:poddy/components/app_bar.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: buildAppBar(context),
      body: new Center(
        child: new RaisedButton(
          onPressed: () {},
          child: new Text('Go back!'),
        ),
      ),
    );
  }
}

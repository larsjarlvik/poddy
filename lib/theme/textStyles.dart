import 'package:flutter/material.dart';

class TextStyles {
  static TextStyle headline(BuildContext context) {
    return Theme.of(context).textTheme.headline.copyWith(
      fontSize: 32.0,
      fontWeight: FontWeight.w300,
      color: new Color.fromARGB(255, 56, 56, 56),
    );
  }
}
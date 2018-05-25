import 'package:flutter/material.dart';

class TextStyles {
  static TextStyle headline(BuildContext context) {
    return Theme.of(context).textTheme.headline.copyWith(
      fontSize: 32.0,
      fontWeight: FontWeight.w300,
      color: new Color.fromARGB(255, 56, 56, 56),
    );
  }

  static TextStyle subHeadline(BuildContext context) {
    return Theme.of(context).textTheme.headline.copyWith(
      fontSize: 24.0,
      fontWeight: FontWeight.w300,
      color: new Color.fromARGB(255, 56, 56, 56),
    );
  }

  static TextStyle body(BuildContext context, {
    fontWeight: FontWeight.w300
  }) {
    return Theme.of(context).textTheme.body1.copyWith(
      fontSize: 16.0,
      height: 1.4,
      fontWeight: fontWeight,
    );
  }
}
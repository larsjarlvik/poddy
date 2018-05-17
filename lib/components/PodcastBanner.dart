import 'package:flutter/material.dart';

Widget podcastBanner(BuildContext context, String url) {
  return new Stack(
    children: <Widget>[
      _buildImage(url),
      _buildTopHeader(context),
    ],
  );
}

class DialogonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.lineTo(0.0, size.height - 60.0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

Widget _buildImage(String url) {
  return new ClipPath(
    clipper: new DialogonalClipper(),
    child: new Stack(
      children: [
        new AspectRatio(
          aspectRatio: 4 / 3.5,
          child: new FadeInImage.assetNetwork(
            placeholder: '',
            image: url,
            fit: BoxFit.fitWidth,
          )
        ),
        new AspectRatio(
          aspectRatio: 4 / 3.5,
          child: Container(
            color: new Color.fromARGB(50, 0, 0, 0),
            width: double.infinity,
          ),
        )
      ]
    )
  );
}

Widget _buildTopHeader(BuildContext context) {
  return new Padding(
    padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 30.0),
    child: new Row(
      children: <Widget>[
        new IconButton(
          icon: new Icon(Icons.arrow_back, size: 32.0),
          onPressed: () => Navigator.pop(context),
          color: Colors.white,
        ),
      ],
    ),
  );
}
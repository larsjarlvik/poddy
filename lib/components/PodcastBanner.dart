import 'package:flutter/material.dart';


class PodcastBanner extends StatelessWidget {
  final String url;

  PodcastBanner(String url) : url = url;

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        _buildImage(context, url),
        _buildTopHeader(context),
      ],
    );
  }
}

class DialogonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height - 60.0);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

Widget _buildImage(BuildContext context, String url) {
  return new Stack(
    children: [
      new ClipPath(
        clipper: new DialogonalClipper(),
        child: new Container(
          color: new Color.fromARGB(240, 0, 0, 0),
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
              ),
            ],
          )
        )
      ),
      new Positioned(
        bottom: 20.0,
        right: 20.0,
        child: new FloatingActionButton(
          child: new Icon(Icons.subscriptions, size: 32.0),
          foregroundColor: Colors.white,
          backgroundColor: Theme.of(context).accentColor,
          onPressed: () => {},
        ),
      )
    ]
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

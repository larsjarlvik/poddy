import 'package:flutter/material.dart';

class PodcastBanner extends StatefulWidget {
  final String url;
  final ScrollController scrollController;
  final VoidCallback onActionPressed;
  final Icon actionIcon;

  PodcastBanner(String url, {
    this.actionIcon,
    this.onActionPressed, 
    this.scrollController,
  }) : url = url;

  @override
  PodcastBannerState createState() => new PodcastBannerState(url, scrollController, 
    actionIcon: actionIcon,
    onActionPressed: onActionPressed
  );
}

class PodcastBannerState extends State<PodcastBanner> {
  final String url;
  final GestureTapCallback onActionPressed;
  final Icon actionIcon;

  // State
  var scroll = 0.0;

  PodcastBannerState(String url, ScrollController scrollController, {
    this.actionIcon,
    this.onActionPressed, 
  }) : url = url
  {
    scrollController.addListener(() => 
      this.setState(() => this.scroll = scrollController.offset)
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: [
        _buildImage(context),
        _buildTopHeader(context),
      ],
    );
  }

  Widget _buildImage(BuildContext context) {
    final heightMultiplier = (400 - scroll >= 60.0 ? 400 - scroll : 60.0) - 60.0;
    final accent = Theme.of(context).accentColor;

    var floatingElevation = (heightMultiplier - 300) * 0.08;
    floatingElevation = floatingElevation < 0.0 ? 0.0 : floatingElevation;

    var floatingAlpha = (heightMultiplier * 1.0).round();
    floatingAlpha = floatingAlpha > 255 ? 255 : floatingAlpha;

    return new Stack(
      children: [
        new ClipPath(
          clipper: new DialogonalClipper(),
          child: new Container(
            color: new Color.fromARGB(240, 0, 0, 0),
            child: new Stack(
              children: [
                new FadeInImage.assetNetwork(
                  width: double.infinity,
                  placeholder: 'assets/gradient.png',
                  image: url,
                  fit: BoxFit.fitWidth,
                ),
                new Container(
                  color: new Color.fromARGB(150 - (heightMultiplier * 0.3).round(), 0, 0, 0),
                  width: double.infinity,
                ),
              ],
            )
          )
        ),
        new Align(
          alignment: new Alignment(0.95, 0.9),
          child: new FloatingActionButton(
            elevation: floatingElevation,
            child: actionIcon,
            foregroundColor: Colors.white,
            backgroundColor: new Color.fromARGB(floatingAlpha, accent.red, accent.green, accent.blue) ,
            onPressed: () => onActionPressed(),
          ),
        )
      ]
    );
  }

  Widget _buildTopHeader(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 30.0),
    );
  }
}

class DialogonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height - (size.height - 60.0) * 0.15);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

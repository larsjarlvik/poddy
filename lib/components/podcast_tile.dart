import 'package:flutter/material.dart';
import 'package:poddy/models/podcast.dart';

Padding buildPodcastTile (Podcast podcast) {
  return new Padding(
    padding: EdgeInsets.all(5.0),
    child: (
      new Container(
        decoration: new BoxDecoration(
          boxShadow: [new BoxShadow(
            color: Colors.grey,
            blurRadius: 1.0,
          )],
          image: new DecorationImage(
            image: new NetworkImage(podcast.artworkLarge),
            fit: BoxFit.cover,
          ),
        ),
        child: null
      )
    ),
  );
}
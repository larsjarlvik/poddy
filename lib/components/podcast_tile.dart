import 'package:flutter/material.dart';
import 'package:poddy/models/podcast.dart';

Card buildPodcastTile (Podcast podcast) {
  return new Card(
    elevation: 1.5,
    child: new Container(
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: new NetworkImage(podcast.artworkLarge),
          fit: BoxFit.cover,
        ),
      ),
      child: null
    ),
  );
}
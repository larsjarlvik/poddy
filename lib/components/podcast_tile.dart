import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:poddy/models/podcast.dart';

Widget buildPodcastTile (Podcast podcast, VoidCallback onTap) {
  return new GestureDetector(
    onTap: onTap,
    child: new Card(
      elevation: 1.5,
      child: new CachedNetworkImage(
        placeholder: new Icon(Icons.photo, color: new Color.fromARGB(255, 56, 56, 56)), 
        imageUrl: podcast.artworkLarge
      )
    )
  );
}
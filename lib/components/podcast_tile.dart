import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:poddy/models/podcast.dart';

Widget buildPodcastTile (Podcast podcast, VoidCallback onTap) {
  return new Card(
    elevation: 1.5,
    child: Stack(children: [
      new CachedNetworkImage(
        placeholder: new Icon(Icons.photo, color: new Color.fromARGB(255, 56, 56, 56)),
        imageUrl: podcast.artworkLarge
      ),
      new Positioned.fill(
        child: new Material(
          color: Colors.transparent,
          child: new InkWell(
            highlightColor: Color.fromARGB(100, 255, 255, 255),
            onTap: onTap,
          )
        )
      )
    ]),
  );
}
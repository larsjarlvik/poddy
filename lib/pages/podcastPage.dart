import 'package:flutter/material.dart';
import 'package:poddy/api/search.dart';
import 'package:poddy/components/PodcastBanner.dart';

class PodcastPage extends StatefulWidget {
  final SearchResult searchResult;

  PodcastPage(SearchResult result) : searchResult = result;

  @override
  PodcastPageState createState() => new PodcastPageState(searchResult);
}

class PodcastPageState extends State<PodcastPage> {
  SearchResult searchResult;
  
  PodcastPageState(SearchResult result) : searchResult = result;
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
        children: <Widget>[
          new PodcastBanner(searchResult.artworkLarge),
          new Text(searchResult.name)
        ],
      )
    );
  }
}

import 'package:flutter/material.dart';
import 'package:poddy/api/search.dart';
import 'package:poddy/components/PodcastBanner.dart';

import 'package:poddy/theme/textStyles.dart';

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
        children: [
          new PodcastBanner(searchResult.artworkLarge),
          new Container(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: new Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  new Align(
                    alignment: Alignment.centerLeft,
                    child: new Text(searchResult.name, style: TextStyles.headline(context), overflow: TextOverflow.fade) 
                  )
                ],
              )
            )
          )
        ],
      )
    );
  }
}

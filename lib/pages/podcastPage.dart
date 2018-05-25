import 'package:flutter/material.dart';
import 'package:flutter_html_view/html_parser.dart';

import 'package:poddy/api/search.dart';
import 'package:poddy/api/feed.dart';
import 'package:poddy/components/PodcastBanner.dart';
import 'package:poddy/theme/textStyles.dart';

class PodcastPage extends StatefulWidget {
  final SearchResult searchResult;

  PodcastPage(SearchResult result) : searchResult = result;

  @override
  PodcastPageState createState() => new PodcastPageState(searchResult);
}

class PodcastPageState extends State<PodcastPage> {
  // State
  var _podcast = new Podcast();
  
  PodcastPageState(SearchResult result) {
    _podcast = new Podcast.fromSearchResult(result);
    _downloadPodcast(result);
  }
  
  _downloadPodcast(SearchResult result) async {
    print(result.feedUrl);

    final podcast = await fetchPodcast(result);
    this.setState(() { this._podcast = podcast; });
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SingleChildScrollView(
        child: new Column(
          children: [
            new PodcastBanner(_podcast.artworkLarge),
            new Container(
              alignment: AlignmentDirectional(0.0, 0.0),
              child: new Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildIntroText(context),
                  ],
                )
              )
            ),
            new AnimatedOpacity(
              opacity: _podcast.loaded ? 1.0 : 0.0,
              duration: new Duration(milliseconds: 500),
              child: new Column(
                children: [
                  new Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 24.0, 12.0, 0.0),
                    child: new Align(
                      alignment: Alignment.topLeft,
                      child: new Text('Episodes', style: TextStyles.subHeadline(context)) 
                    ),
                  ),
                  _buildEpisodeList(context),
                ]
              ),
            )
          ],
        )
      ) 
    );
  }

  _buildIntroText(BuildContext context) {
    return new Column(
      children: [
        new Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 12.0),
          child: new Column(
            children: [
              new Align(
                alignment: Alignment.topLeft,
                child: new Text(_podcast.name, style: TextStyles.headline(context)) 
              ),
              new Align(
                alignment: Alignment.topLeft,
                child: new Text(_podcast.primaryGenre, style: TextStyles.body(context, fontWeight: FontWeight.w700)),
              )
            ],
          ) 
        ),
        new DefaultTextStyle(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildHtmlText(context, _podcast.description),
          ),
          style: TextStyles.body(context)
        )
      ]
    );
  }

  _buildEpisodeList(BuildContext context) {
    var episodes = new List<Widget>();
    _podcast.episodes.forEach((ep) => episodes.add(new ListTile(
      title: new Text(ep.name, style: TextStyles.body(context, fontWeight: FontWeight.w400), overflow: TextOverflow.ellipsis),
      subtitle: new Text(ep.duration, style: TextStyles.body(context)),
    )));

    return new Padding(
      padding: new EdgeInsets.all(4.0),
      child: new Column(children: episodes)
    );
  }

  _buildHtmlText(BuildContext context, String htmlString) {
      final htmlParser = new HtmlParser();
      final nodes = htmlParser.HParse(htmlString);

      if (nodes.length == 0) {
        return [new Align(
          alignment: Alignment.topLeft,
          child: new Padding(
            padding: new EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
            child: new Text(htmlString),
          ),
        )];
      }

      return nodes;
  }
}

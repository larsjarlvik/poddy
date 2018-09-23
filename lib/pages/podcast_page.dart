import 'package:flutter/material.dart';
import 'package:flutter_html_view/html_parser.dart';

import 'package:poddy/api/feed.dart';
import 'package:poddy/storage/subscriptions.dart';
import 'package:poddy/components/podcast_banner.dart';
import 'package:poddy/models/podcast.dart';
import 'package:poddy/theme/text_styles.dart';

class PodcastPage extends StatefulWidget {
  final Podcast podcast;

  PodcastPage(Podcast podcast) : podcast = podcast;

  @override
  PodcastPageState createState() => new PodcastPageState(podcast);
}

class PodcastPageState extends State<PodcastPage> {
  final scrollController = new ScrollController();
  final key = new GlobalKey<ScaffoldState>();

  // State
  var podcast = new Podcast();
  var subscribed = false;
  
  PodcastPageState(Podcast podcast) {
    this.podcast = podcast;
    setSubscribed();

    if (!podcast.loaded) {
      downloadPodcast(podcast);
    }
  }

  setSubscribed() async {
    final subscribed = await containsPodcast(this.podcast);
    this.setState(() { this.subscribed = subscribed; });
  }
  
  downloadPodcast(Podcast podcast) async {
    final updatedPodcast = await fetchPodcast(podcast);
    if (this.mounted) {
      this.setState(() { this.podcast = updatedPodcast; });
    }
  }

  toggleSubscibe() async {
    var message = '';
    final subscribed = await containsPodcast(this.podcast);

    if (subscribed) {
      removeSubscription(podcast);
      message = 'Removed!';
    } else {
      addSubscription(podcast);
      message = 'Subscribed!';
    }

    key.currentState.showSnackBar(new SnackBar(
      content: new Text(message),
      duration: new Duration(seconds: 3),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: key,
      body: new CustomScrollView(
        controller: scrollController,
        slivers: [
          new SliverAppBar(
            key: new Key(this.subscribed.toString()),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            expandedHeight: 400.0,
            flexibleSpace: new PodcastBanner(podcast.artworkLarge,
              actionIcon: new Icon(this.subscribed ? Icons.delete : Icons.subscriptions),
              onActionPressed: toggleSubscibe,
              scrollController: scrollController,
            ),
            pinned: true,
          ),
          new SliverPadding(
            padding: new EdgeInsets.all(0.0),
            sliver: new SliverList(
              delegate: new SliverChildListDelegate([
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
                  opacity: podcast.loaded ? 1.0 : 0.0,
                  duration: new Duration(milliseconds: 1000),
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
                ),
              ]
            ),
          ),
        ),
      ])
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
                child: new Text(podcast.name, style: TextStyles.headline(context)) 
              ),
              new Align(
                alignment: Alignment.topLeft,
                child: new Text(podcast.primaryGenre, style: TextStyles.body(context, fontWeight: FontWeight.w700)),
              )
            ],
          ) 
        ),
        new DefaultTextStyle(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildHtmlText(context, podcast.description),
          ),
          style: TextStyles.body(context)
        )
      ]
    );
  }

  _buildEpisodeList(BuildContext context) {
    var episodes = new List<Widget>();
    podcast.episodes.forEach((ep) => episodes.add(new ListTile(
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

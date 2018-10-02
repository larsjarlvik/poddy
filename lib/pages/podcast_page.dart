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

  PodcastPageState(Podcast p) {
    podcast = p;
    setSubscribed();

    if (!podcast.loaded) {
      downloadPodcast(podcast);
    }
  }

  setSubscribed() async {
    final isSubscribed = await containsPodcast(podcast);
    setState(() { subscribed = isSubscribed; });
  }

  downloadPodcast(Podcast podcast) async {
    final updatedPodcast = await fetchPodcast(podcast);
    if (mounted) {
      setState(() { podcast = updatedPodcast; });
    }
  }

  toggleSubscibe() async {
    var message = '';
    final isSubscribed = await containsPodcast(podcast);

    if (isSubscribed) {
      removeSubscription(podcast);
      message = 'Removed!';
    } else {
      addSubscription(podcast);
      message = 'Subscribed!';
    }

    setState(() { subscribed = !isSubscribed; });
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
            key: new Key(subscribed.toString()),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            expandedHeight: 400.0,
            flexibleSpace: new PodcastBanner(podcast.artworkLarge,
              actionIcon: new Icon(subscribed ? Icons.delete : Icons.subscriptions),
              onActionPressed: toggleSubscibe,
              scrollController: scrollController,
            ),
            pinned: true,
          ),
          new SliverPadding(
            padding: new EdgeInsets.all(10.0),
            sliver: new SliverList(
              delegate: new SliverChildListDelegate([
                _buildIntroText(context),
              ])
            )
          ),
          new SliverPadding(
            padding: new EdgeInsets.fromLTRB(18.0, 26.0, 18.0, 0.0),
            sliver: new SliverList(
              delegate: new SliverChildListDelegate([
                new AnimatedOpacity(
                  opacity: podcast.loaded ? 1.0 : 0.0,
                  duration: new Duration(milliseconds: 300),
                  child: new Align(
                    alignment: Alignment.topLeft,
                    child: new Text('Episodes', style: TextStyles.subHeadline(context))
                  ),
                ),
              ]),
            )
          ),
          new SliverPadding(
            padding: new EdgeInsets.all(18.0),
            sliver: new SliverList(
              delegate: _buildEpisodeList()
            )
          ),
        ]
      )
    );
  }

  _buildIntroText(BuildContext context) {
    return new Column(
      children: [
        new Padding(
          padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
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
        new AnimatedOpacity(
          opacity: podcast.loaded ? 1.0 : 0.0,
          duration: new Duration(milliseconds: 300),
          child: new DefaultTextStyle(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildHtmlText(context, podcast.description),
            ),
            style: TextStyles.body(context)
          )
        )
      ]
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

  _buildEpisodeList() {
    return new SliverChildBuilderDelegate(
      (BuildContext context, int index) => index.isEven ?
        Divider(height: 4.0) :
        ListTile(
          contentPadding: EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 0.0),
          title: new Text(podcast.episodes[index].name, style: TextStyles.body(context, fontWeight: FontWeight.w400), overflow: TextOverflow.ellipsis),
          subtitle: new Text(podcast.episodes[index].duration, style: TextStyles.body(context)),
          trailing: new IconButton(
            color: Theme.of(context).accentColor,
            icon: new Icon(Icons.play_circle_outline),
            onPressed: () {},
          ),
        ),
      childCount: podcast.episodes.length * 2
    );
  }
}

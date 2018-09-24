import 'dart:async';

import 'package:flutter/material.dart';

import 'package:poddy/api/search.dart';
import 'package:poddy/components/podcast_tile.dart';
import 'package:poddy/components/search_bar.dart';
import 'package:poddy/models/podcast.dart';
import 'package:poddy/pages/podcast_page.dart';
import 'package:poddy/storage/subscriptions.dart';
import 'package:poddy/theme/text_styles.dart';
import 'package:poddy/models/search_result.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  // State
  List<SearchResult> searchResults;
  List<Podcast> subscriptions = new List<Podcast>();
  
  var isSearching = false;

  getSubscriptions() async {
    final subs = await readSubscriptions();
    this.setState(() { this.subscriptions = subs; });
  }

  HomePageState() {
    searchResults = null;
  }

  submitQuery(String value) async {
    String query = value.trim();
    if (query.length < 2) return;

    setState(() => isSearching = true);
    FocusScope.of(context).requestFocus(new FocusNode());

    List<SearchResult> results = await doSearch(value);
    if (this.mounted) {
      this.setState(() { this.searchResults = results; this.isSearching = false; });
    }
  }

  showHome() {
    this.setState(() { this.searchResults = null; this.isSearching = false; });
  }

  showPodcast(Podcast result) {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => new PodcastPage(result)
      )
    );
  }

  Future<bool> onPopState() async {
    if (searchResults != null) {
      showHome();
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    getSubscriptions();

    return new WillPopScope(
      onWillPop: onPopState,
      child: new Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: new SearchBar(
          submitQuery,
          showHome
        ),
        body: new Column(
          children: [
            buildSearchSpinner(context),
            buildResultList(context)
          ],
        ) 
      )
    );
  }

  buildSearchSpinner(BuildContext context) {
    return new AnimatedOpacity(
      opacity: isSearching ? 1.0 : 0.0,
      duration: new Duration(milliseconds: 1000),
      child: new Container(
        height: 1.5,
        child: new LinearProgressIndicator(
          backgroundColor: Colors.transparent,
        ),
      )
    );
  }

  buildResultList(BuildContext context) {
    Widget child;

    if (searchResults == null) {
      child = GridView.builder(
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3
        ),
        itemCount: subscriptions.length,
        itemBuilder: (BuildContext context, int index) {
          return buildPodcastTile(
            subscriptions[index],
            () => showPodcast(subscriptions[index])
          );
        },
      );
    }
    else if (searchResults.length == 0) {
      child = new Center(
        child: new Text('Nothing found...', style: TextStyles.body(context)
      ));
    }
    else {
      child = new ListView.builder(
        padding: new EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
        itemCount: searchResults.length,
        itemBuilder: (BuildContext context, int index) {
          return new ListTile(
            leading: new Image.network(searchResults[index].artworkSmall, height: 45.0),
            title: new Text(searchResults[index].name),
            onTap: () => this.showPodcast(Podcast.fromSearchResult(searchResults[index])),
          );
        },
      );
    }

    return new Flexible(
      child: new AnimatedOpacity(
        opacity: !isSearching? 1.0 : 0.0,
        duration: new Duration(milliseconds: 1000),
        child: child,
      )
    );
  }
}

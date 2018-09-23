import 'dart:async';

import 'package:flutter/material.dart';

import 'package:poddy/api/search.dart';
import 'package:poddy/components/podcast_tile.dart';
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
  final searchController = new TextEditingController();

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
    getSubscriptions();
  }

  submitQuery(String value) async {
    String query = value.trim();
    if (query.length < 2) return;

    setState(() => isSearching = true);
    searchController.clear();
    FocusScope.of(context).requestFocus(new FocusNode());

    List<SearchResult> results = await doSearch(value);
    if (this.mounted) {
      this.setState(() { this.searchResults = results; this.isSearching = false; });
    }
  }

  showHome() {
    getSubscriptions();
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
    return new WillPopScope(
      onWillPop: onPopState,
      child: new Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: buildAppBar(context),
        body: new Column(
          children: [
            buildSearchSpinner(context),
            buildResultList(context)
          ],
        ) 
      )
    );
  }

  buildAppBar(BuildContext context) {
    return new AppBar(
      elevation: 1.5,
      backgroundColor: Colors.white,
      titleSpacing: 0.0,
      leading: new IconButton(
        color: searchResults != null ? new Color.fromARGB(255, 56, 56, 56) : new Color.fromARGB(100, 56, 56, 56),
        icon: new Icon(Icons.home),
        onPressed: () => showHome(),
      ),
      title: new Card(
        color: new Color.fromARGB(150, 240, 234, 230),
        elevation: 0.0,
        child: new Padding(
          padding: new EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          child: new TextField(
            controller: searchController,
            onSubmitted: submitQuery,
            decoration: new InputDecoration(
              hintText: 'Search podcasts',
              icon: new Icon(Icons.search),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
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
  
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

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

enum PageState {
  Home,
  ShowSearch,
  Searching,
  SearchResults,
}

class HomePage extends StatefulWidget {
  final RouteObserver routeObserver;

  HomePage(RouteObserver routeObserver) : routeObserver = routeObserver;

  @override
  HomePageState createState() => new HomePageState(routeObserver);
}

class HomePageState extends State<HomePage> with RouteAware {
  final RouteObserver routeObserver;

  // State
  List<SearchResult> searchResults;
  List<Podcast> subscriptions = new List<Podcast>();

  var pageState = PageState.Home;

  getSubscriptions() async {
    final subs = await readSubscriptions();
    setState(() { subscriptions = subs; });
  }

  HomePageState(RouteObserver routeObserver) :
    routeObserver = routeObserver {
    searchResults = null;
  }

  @override
  initState() {
    super.initState();
    getSubscriptions();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPopNext() {
    getSubscriptions();
  }

  submitQuery(String value) async {
    String query = value.trim();
    if (query.length < 2) return;

    setState(() => pageState = PageState.Searching);
    FocusScope.of(context).requestFocus(new FocusNode());

    List<SearchResult> results = await doSearch(value);
    if (mounted) {
      setState(() { searchResults = results; pageState = PageState.SearchResults; });
    }
  }

  showPodcast(Podcast result) {
    Navigator.push(context, new MaterialPageRoute(
      builder: (context) => new PodcastPage(result)
    ));
  }

  Future<Null> handleRefresh() async {
    await refreshPodcasts();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new SearchBar(
        submitQuery,
        () => setState(() { pageState = PageState.ShowSearch; }),
        () => setState(() { searchResults = null; pageState = PageState.Home; }),
      ),
      body: RefreshIndicator(
        onRefresh: handleRefresh,
          child: new Column(
          children: [
            buildSearchSpinner(context),
            buildPageContent(context)
          ],
        )
      )
    );
  }

  buildSearchSpinner(BuildContext context) {
    return new AnimatedOpacity(
      opacity: pageState == PageState.Searching ? 1.0 : 0.0,
      duration: new Duration(milliseconds: 1000),
      child: new Container(
        height: 1.5,
        child: new LinearProgressIndicator(
          backgroundColor: Colors.transparent,
        ),
      )
    );
  }

  buildPageContent(BuildContext context) {
    return new Flexible(
      child: new AnimatedCrossFade(
        duration: const Duration(milliseconds: 300),
        firstChild: buildHome(),
        secondChild: new AnimatedOpacity(
          opacity: pageState != PageState.Searching ? 1.0 : 0.0,
          duration: new Duration(milliseconds: 300),
          child: buildSearch(),
        ),
        crossFadeState: pageState == PageState.Home || pageState == PageState.ShowSearch ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      )
    );
  }

  buildHome() {
    return GridView.builder(
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

  buildSearch() {
    if (searchResults == null) {
      return new Center(
        child: new Text('', style: TextStyles.body(context)
      ));
    }

    if (searchResults.length == 0) {
      return new Center(
        child: new Text('Nothing found...', style: TextStyles.body(context)
      ));
    }

    return new ListView.builder(
      padding: new EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
      itemCount: searchResults.length,
      itemBuilder: (BuildContext context, int index) {
        return new ListTile(
          leading: new Image.network(searchResults[index].artworkSmall, height: 45.0),
          title: new Text(searchResults[index].name),
          onTap: () => showPodcast(Podcast.fromSearchResult(searchResults[index])),
        );
      },
    );
  }
}

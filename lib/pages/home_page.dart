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
    await getSubscriptions();
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSearchSpinner(context),
            _buildPageContent(context)
          ],
        )
      )
    );
  }

  _buildSearchSpinner(BuildContext context) {
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

  _buildPageContent(BuildContext context) {
    return new Flexible(
      child: new AnimatedCrossFade(
        duration: const Duration(milliseconds: 300),
        firstChild: _buildHome(),
        secondChild: new AnimatedOpacity(
          opacity: pageState != PageState.Searching ? 1.0 : 0.0,
          duration: new Duration(milliseconds: 300),
          child: _buildSearch(),
        ),
        crossFadeState: pageState == PageState.Home || pageState == PageState.ShowSearch ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      )
    );
  }

  _buildHome() {
    if (subscriptions.length == 0 && pageState == PageState.Home) return _buildWelcome();

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

  _buildWelcome() {
    return new Container(
      padding: EdgeInsets.fromLTRB(80.0, 0.0, 80.0, 30.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(image: AssetImage('assets/nothing-here.png')),
          new Container(
            padding: EdgeInsets.only(top: 20.0),
            child: new Column(
              children: [
                new Text('Nothing here...', 
                  style: TextStyles.subHeadline(context),
                  textAlign: TextAlign.center,
                ),
                new Text('You haven\'t subscribed to any podcasts. Search for a podcast and hit the subscibe button and it will show up here.', 
                  style: TextStyles.body(context), 
                  textAlign: TextAlign.center,
                ),
                new Container(
                  padding: new EdgeInsets.only(top: 20.0),
                  child: new OutlineButton(
                    padding: EdgeInsets.fromLTRB(20.0, 7.0, 20.0, 12.0),
                    child: new Text('Browse popular podcasts', style: TextStyles.body(context, fontWeight: FontWeight.bold)),
                    onPressed: () {},
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0))
                  )
                )
              ]
            ),
          )
        ]
      ),
    );
  }

  _buildSearch() {
    if (searchResults == null) {
      return new Center(
        child: new Text('', style: TextStyles.body(context))
      );
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
          leading: new Image.network(searchResults[index].artworkSmall, height: 45.0, width: 45.0),
          title: new Text(searchResults[index].name),
          onTap: () => showPodcast(Podcast.fromSearchResult(searchResults[index])),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

import 'package:poddy/api/search.dart';
import 'package:poddy/pages/podcastPage.dart';

class SearchPage extends StatefulWidget {
  @override
  SearchPageState createState() => new SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final searchController = new TextEditingController();
  var _searchResults = new List<SearchResult>();

  submitQuery(String value) async {
    String query = value.trim();
    if (query.length < 3) return;

    searchController.clear();
    FocusScope.of(context).requestFocus(new FocusNode());

    List<SearchResult> results = await doSearch(value);
    this.setState(() { this._searchResults = results; });
  }

  showPodcast(SearchResult result) {
    Navigator.of(context).push(new PageRouteBuilder(
      pageBuilder: (_, __, ___) => new PodcastPage(result),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Column(
        children: [
          new Container(
            padding: new EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
            child: new Stack(
              alignment: const Alignment(1.0, 0.0),
              children: <Widget>[
                new TextField(
                  controller: searchController,
                  onSubmitted: submitQuery,
                  decoration: new InputDecoration(
                    hintText: 'Search podcasts',
                  ),
                ),
                new IconButton(
                  onPressed: () => submitQuery(searchController.text),
                  icon: new Icon(Icons.search),
                  iconSize: 24.0,
                )
              ]
            )
          ),
          new Flexible(
            child: new ListView.builder(
              padding: new EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
              itemCount: _searchResults.length,
              itemBuilder: (BuildContext context, int index) {
                return new ListTile(
                  leading: new Image.network(_searchResults[index].artworkSmall),
                  title: new Text(_searchResults[index].name),
                  onTap: () => this.showPodcast(_searchResults[index]),
                );
              },
            )
          )
        ],
      ) 
    );
  }
  
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';

import 'package:poddy/api/search.dart';
import 'package:poddy/pages/podcast_page.dart';

class SearchPage extends StatefulWidget {
  @override
  SearchPageState createState() => new SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final searchController = new TextEditingController();

  // State
  var searchResults = new List<SearchResult>();

  submitQuery(String value) async {
    String query = value.trim();
    if (query.length < 2) return;

    searchController.clear();
    FocusScope.of(context).requestFocus(new FocusNode());

    List<SearchResult> results = await doSearch(value);
    this.setState(() { this.searchResults = results; });
  }

  showPodcast(SearchResult result) {
    Navigator.of(context).push(
      new MaterialPageRoute(builder: (context) => new PodcastPage(result))
    );
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
              itemCount: searchResults.length,
              itemBuilder: (BuildContext context, int index) {
                return new ListTile(
                  leading: new Image.network(searchResults[index].artworkSmall),
                  title: new Text(searchResults[index].name),
                  onTap: () => this.showPodcast(searchResults[index]),
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
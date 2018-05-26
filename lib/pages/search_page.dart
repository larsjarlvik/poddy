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
    return new Scaffold(
      appBar: buildAppBar(context),
      body: new Container(
        child: new Column(
          children: [
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
      )
    );
  }

  buildAppBar(BuildContext context) {
    return new AppBar(
      elevation: 1.5,
      backgroundColor: new Color.fromARGB(255, 50, 50, 50),
      title: new Card(
        color: new Color.fromARGB(60, 255, 255, 255),
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
  
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

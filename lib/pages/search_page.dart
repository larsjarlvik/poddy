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
  var isSearching = false;

  submitQuery(String value) async {
    String query = value.trim();
    if (query.length < 2) return;

    setState(() => isSearching = true);
    searchController.clear();
    FocusScope.of(context).requestFocus(new FocusNode());

    List<SearchResult> results = await doSearch(value);
    this.setState(() { this.searchResults = results; this.isSearching = false; });
  }

  showPodcast(SearchResult result) {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => new PodcastPage(result)
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: buildAppBar(context),
      body: new Column(
        children: [
          new AnimatedOpacity(
            opacity: isSearching ? 1.0 : 0.0,
            duration: new Duration(milliseconds: 1000),
            child: new Container(
              height: 2.0,
              child: new LinearProgressIndicator(
                backgroundColor: Colors.transparent,
              ),
            )
          ),
          new Flexible(
            child: new AnimatedOpacity(
              opacity: !isSearching? 1.0 : 0.0,
              duration: new Duration(milliseconds: 1000),
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
          )
        ],
      ) 
    );
  }

  buildAppBar(BuildContext context) {
    return new AppBar(
      elevation: 1.5,
      backgroundColor: Colors.white,
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
  
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

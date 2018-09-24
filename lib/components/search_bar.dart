import 'dart:async';

import 'package:flutter/material.dart';


class SearchBar extends StatefulWidget implements PreferredSizeWidget {
  final ValueChanged<String> onSearch;
  final VoidCallback back;
  final VoidCallback search;

  SearchBar(ValueChanged<String> onSearch, VoidCallback search, VoidCallback back) :
    onSearch = onSearch,
    search = search,
    back = back;

  @override
  SearchBarState createState() => new SearchBarState(onSearch, search, back);

  @override
  Size get preferredSize => new Size.fromHeight(50.0);
}

class SearchBarState extends State<SearchBar> {
  final searchController = new TextEditingController();
  final ValueChanged<String> onSearch;
  final VoidCallback back;
  final VoidCallback search;

  // State
  bool showSearch = false;

  SearchBarState(ValueChanged<String> onSearch, VoidCallback search, VoidCallback back) :
    onSearch = onSearch,
    search = search,
    back = back;

  @override
  PreferredSizeWidget build(BuildContext context) {
    return new AppBar(
      brightness: Brightness.light,
      elevation: 1.5,
      backgroundColor: Colors.white,
      titleSpacing: 0.0,
      leading: buildLeading(context),
      centerTitle: true,
      title: showSearch ? buildSearchState(context) : buildDefaultState(context)
    );
  }

  toggleShowSearch() {
    setState(() => showSearch = !showSearch);
    if (!showSearch) {
      back();
      searchController.clear();
    } else {
      search();
    }
  }

  Future<bool> onPopState() async {
    if (showSearch) {
      toggleShowSearch();
      return false;
    }

    return true;
  }

  Widget buildLeading(BuildContext context) {
    var icon = showSearch ? Icons.arrow_back : Icons.search;
    return new WillPopScope(
      onWillPop: onPopState,
      child: new IconButton(
        color: new Color.fromARGB(255, 56, 56, 56),
        icon: new Icon(icon),
        onPressed: toggleShowSearch,
      )
    );
  }

  Widget buildDefaultState(BuildContext context) {
    return new Padding(
      padding: new EdgeInsets.fromLTRB(0.0, 14.0, 0.0, 14.0),
      child: new Image(image: AssetImage('assets/poddy.png'))
    );
  }

  Widget buildSearchState(BuildContext context) {
    return new Padding(
      padding: new EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
      child: new TextField(
        controller: searchController,
        onSubmitted: onSearch,
        autofocus: true,
        decoration: new InputDecoration(
          hintText: 'Type to search podcasts',
          enabledBorder: new UnderlineInputBorder(
            borderSide: new BorderSide(style: BorderStyle.none)
          ),
          focusedBorder: new UnderlineInputBorder(
            borderSide: new BorderSide(style: BorderStyle.none)
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

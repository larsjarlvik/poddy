import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';

Future<List<SearchResult>> doSearch(String query) async {
  final response = await get('https://itunes.apple.com/search?media=podcast&term=$query');
  final responseJson = json.decode(response.body); 
  final podcasts = responseJson['results'];

  List<SearchResult> mappedPodcasts = new List<SearchResult>();
  podcasts.forEach((p) => mappedPodcasts.add(new SearchResult.fromJson(p)));

  return mappedPodcasts;
}

class SearchResult {
  final String name;
  final String creator;
  final String artworkSmall;
  final String artworkLarge;
  final String feedUrl;
  final String primaryGenre;

  SearchResult({ this.name, this.creator, this.artworkSmall, this.artworkLarge, this.feedUrl, this.primaryGenre });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return new SearchResult(
      name: json['trackName'],
      creator: json['artistName'],
      artworkSmall: json['artworkUrl100'],
      artworkLarge: json['artworkUrl600'],
      feedUrl: json['feedUrl'],
      primaryGenre: json['primaryGenreName'],
    );
  }
}
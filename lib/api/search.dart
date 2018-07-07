import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:poddy/models/search_result.dart';

Future<List<SearchResult>> doSearch(String query) async {
  final response = await get('https://itunes.apple.com/search?media=podcast&term=$query');
  final responseJson = json.decode(response.body); 
  final podcasts = responseJson['results'];

  List<SearchResult> mappedPodcasts = new List<SearchResult>();
  podcasts.forEach((p) => mappedPodcasts.add(new SearchResult.fromJson(p)));

  return mappedPodcasts;
}

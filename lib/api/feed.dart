import 'dart:async';
import 'package:poddy/models/podcast.dart';
import 'package:poddy/models/search_result.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart';

Future<Podcast> fetchPodcast(SearchResult result) async {
  final response = await get(result.feedUrl);
  final document = xml.parse(response.body);

  return new Podcast.fromXml(result, document);
}

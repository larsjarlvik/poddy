import 'package:xml/xml.dart' as xml;

import 'search_result.dart';
import 'episode.dart';

class Podcast {
  final String name;
  final String feedUrl;
  final String creator;
  final String artworkSmall;
  final String artworkLarge;
  final String primaryGenre;
  
  bool loaded;
  List<Episode> episodes;
  String description;

  Podcast({ this.name, this.feedUrl,
    this.creator: '',
    this.artworkSmall: '',
    this.artworkLarge: '',
    this.description: '',
    this.primaryGenre: '',
    this.episodes = const [],
    this.loaded = false,
  });

  factory Podcast.fromSearchResult(SearchResult result) {
    return new Podcast(
      name: result.name,
      feedUrl: result.feedUrl,
      creator: result.creator,
      artworkLarge: result.artworkLarge,
      artworkSmall: result.artworkSmall,
      primaryGenre: result.primaryGenre,
      loaded: false,
    );
  }

  factory Podcast.fromXml(SearchResult result, xml.XmlDocument document) {
    var podcast = new Podcast.fromSearchResult(result);
    var episodes = new List<Episode>();

    document.findAllElements('item').forEach((item) =>
      episodes.add(new Episode.fromXml(item))
    );

    podcast.description = document.findAllElements('description').first.text;
    podcast.episodes = episodes;
    podcast.loaded = true;

    return podcast;
  }
}
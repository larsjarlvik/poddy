import 'package:xml/xml.dart' as xml;

import 'search_result.dart';
import 'episode.dart';

class Podcast {
  final int id;
  final String name;
  final String feedUrl;
  final String creator;
  final String artworkSmall;
  final String artworkLarge;
  final String primaryGenre;
  
  bool loaded;
  List<Episode> episodes;
  String description;

  Podcast({ this.id, this.name, this.feedUrl,
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
      id: result.id,
      name: result.name,
      feedUrl: result.feedUrl,
      creator: result.creator,
      artworkLarge: result.artworkLarge,
      artworkSmall: result.artworkSmall,
      primaryGenre: result.primaryGenre,
      loaded: false,
    );
  }

  factory Podcast.fromXml(Podcast podcast, xml.XmlDocument document) {
    var episodes = new List<Episode>();

    document.findAllElements('item').forEach((item) =>
      episodes.add(new Episode.fromXml(item))
    );

    podcast.description = document.findAllElements('description').first.text;
    podcast.episodes = episodes;
    podcast.loaded = true;

    return podcast;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'feedUrl': feedUrl,
    'creator': creator,
    'artworkSmall': artworkSmall,
    'artworkLarge': artworkLarge,
    'primaryGenre': primaryGenre,
    'episodes': episodes.map((e) => e.toJson()).toList()
  };

  Podcast.fromJson(Map json) :
    id = json['id'],
    name = json['name'],
    description = json['description'],
    feedUrl = json['feedUrl'],
    creator = json['creator'],
    artworkSmall = json['artworkSmall'],
    artworkLarge = json['artworkLarge'],
    primaryGenre = json['primaryGenre'],
    episodes = (json['episodes'] as List).map((e) => Episode.fromJson(e)).toList(),
    loaded = true;
}
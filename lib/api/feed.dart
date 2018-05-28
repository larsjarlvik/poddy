import 'dart:async';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart';

import 'search.dart';

Future<Podcast> fetchPodcast(SearchResult result) async {
  final response = await get(result.feedUrl);
  final document = xml.parse(response.body);

  return new Podcast.fromXml(result, document);
}

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

class Episode {
  final String name;
  final String url;
  final String duration;

  Episode({ this.name, this.url,
    this.duration: ''
  });

  factory Episode.fromXml(xml.XmlElement item) {
    var rawDuration = item.findElements('itunes:duration').first.text;
    var numDuration = int.tryParse(rawDuration);
    var parsedDuration = '';

    if (numDuration != null) {
      var hours = ((numDuration / 3600).floor()).toString().padLeft(2, '0') + ':';
      var minutes = ((numDuration / 60).floor() % 60).toString().padLeft(2, '0') + ':';
      var seconds = (numDuration % 60).toString().padLeft(2, '0');
      
      hours = hours != '00:' ? hours : '';

      parsedDuration = '$hours$minutes$seconds';
    } else {
      parsedDuration = rawDuration.substring(0, 3) == '00:' ? rawDuration.substring(3) : rawDuration;
    }

    return new Episode(
      name: item.findElements('title').first.text, 
      url: item.findElements('enclosure').first.getAttribute('url'),
      duration: parsedDuration,
    );
  }
}
import 'package:intl/intl.dart';
import 'package:xml/xml.dart' as xml;

class Episode {
  final String name;
  final String description;
  final String url;
  final DateTime pubDate;
  final String duration;

  Episode({ this.name, this.description, this.url, this.pubDate,
    this.duration: ''
  });

  factory Episode.fromXml(xml.XmlElement item) {
    final format = new DateFormat("EEE, dd MMM yyyy HH:mm:ss zzz");
    final rawDuration = item.findElements('itunes:duration').first.text;
    final numDuration = int.tryParse(rawDuration);
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
      description: item.findElements('description').first.text,
      url: item.findElements('enclosure').first.getAttribute('url'),
      pubDate: format.parse(item.findElements('pubDate').first.text),
      duration: parsedDuration,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'url': url,
    'pubDate': pubDate.toIso8601String(),
    'duration': duration,
  };

  Episode.fromJson(Map json) :
    name = json['name'],
    description = json['description'],
    url = json['url'],
    pubDate = DateTime.parse(json['pubDate']),
    duration = json['duration'];
}
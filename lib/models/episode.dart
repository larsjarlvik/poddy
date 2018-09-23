import 'package:xml/xml.dart' as xml;

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
  
  Map<String, dynamic> toJson() => {
    'name': name,
    'url': url,
    'duration': duration,
  };

  Episode.fromJson(Map json) :
    name = json['name'],
    url = json['url'],
    duration = json['duration'];
}
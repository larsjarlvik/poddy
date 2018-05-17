import 'dart:async';


Future<Podcast> fetchPodcast(String feedUrl) async {
  
}

class Podcast {
  final String name;

  Podcast({ this.name });

  factory Podcast.fromXml() {
    return new Podcast(
      name: 'test'
    );
  }
}
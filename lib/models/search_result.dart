
class SearchResult {
  final int id;
  final String name;
  final String creator;
  final String artworkSmall;
  final String artworkLarge;
  final String feedUrl;
  final String primaryGenre;

  SearchResult({ this.id, this.name, this.creator, this.artworkSmall, this.artworkLarge, this.feedUrl, this.primaryGenre });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return new SearchResult(
      id: json['collectionId'],
      name: json['trackName'],
      creator: json['artistName'],
      artworkSmall: json['artworkUrl100'],
      artworkLarge: json['artworkUrl600'],
      feedUrl: json['feedUrl'],
      primaryGenre: json['primaryGenreName'],
    );
  }
}
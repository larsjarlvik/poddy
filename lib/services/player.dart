import 'package:audioplayers/audioplayers.dart';
import 'package:poddy/models/episode.dart';

class Player {
  static final Player _player = new Player._internal();

  final _audioPlayer = new AudioPlayer();

  factory Player() {
    return _player;
  }

  Player._internal();

  play(Episode episode) async {
    await _audioPlayer.play(episode.url);
  }
}

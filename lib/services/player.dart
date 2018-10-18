import 'package:audioplayers/audioplayers.dart';
import 'package:poddy/models/episode.dart';
import 'package:poddy/models/podcast.dart';

typedef void PlayHandler(Podcast podcast, Episode episode);
typedef void DurationHandler(Duration duration);
typedef void StateUpdateHandler();

enum PlayerState {
  Buffering,
  Playing,
  Paused,
  Completed
}

class Player {
  static final Player _player = new Player._internal();
  final _audioPlayer = new AudioPlayer();

  PlayHandler playEvent;
  DurationHandler durationEvent;
  StateUpdateHandler stateUpdateEvent;

  PlayerState state;

  factory Player() {
    return _player;
  }

  Player._internal();

  play(Podcast podcast, Episode episode) async {
    if (stateUpdateEvent != null) _setState(PlayerState.Buffering);

    await _audioPlayer.play(episode.url);
    if (playEvent != null) playEvent(podcast, episode);

    _audioPlayer.positionHandler = (Duration duration) {
      if (durationEvent != null) durationEvent(duration);
      if (stateUpdateEvent != null && state != PlayerState.Playing) _setState(PlayerState.Playing);
    };
    
    _audioPlayer.completionHandler = () {
      _setState(PlayerState.Completed);
    };
  }

  pause() async {
    await _audioPlayer.pause();
    if (stateUpdateEvent != null) _setState(PlayerState.Paused);
  }

  resume() async {
    await _audioPlayer.resume();
    if (stateUpdateEvent != null) _setState(PlayerState.Playing);
  }

  _setState(PlayerState ps) {
    state = ps;
    stateUpdateEvent();
  }
}

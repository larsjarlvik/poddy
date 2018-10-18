import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:poddy/models/episode.dart';
import 'package:poddy/models/podcast.dart';

import 'package:poddy/services/player.dart' as player;

class PlayerBar extends StatefulWidget {
  PlayerBar();

  @override
  PlayerBarState createState() => new PlayerBarState();
}

class PlayerBarState extends State<PlayerBar> {
  final player.Player _player;

  // State
  Podcast podcast;
  Episode episode;
  Duration duration;
  player.PlayerState playerState;

  PlayerBarState() : _player = new player.Player()
  {
    _player.playEvent = (Podcast p, Episode e) {
      setState(() { podcast = p; episode = e; });
    };

    _player.durationEvent = (Duration d) {
      setState(() { duration = d; });
    };

    _player.stateUpdateEvent = () {
      setState(() { playerState = _player.state; });
    };
  }

  @override
  Widget build(BuildContext context) {
    return new BottomAppBar(
      elevation: 4.0,
      color: Colors.white,
      child: new Container(
        child: new ListTile(
          leading: _buildLeading(podcast),
          title: new Text(episode != null ? episode.name : 'Nothing playing', overflow: TextOverflow.ellipsis),
          subtitle: _buildSubtitle(),
          trailing: _buildTrailing(),
        ),
      ),
    );
  }

  String _getFriendlyDuration(Duration duration) {
    final dur = duration != null ? duration : new Duration();
    return '${dur.inMinutes.toString().padLeft(2, '0')}:${(dur.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  Widget _buildLeading(Podcast podcast) {
    if (podcast == null) {
      return new Icon(Icons.audiotrack, size: 30.0);
    }

    return new CachedNetworkImage(
      placeholder: new Icon(Icons.audiotrack, size: 30.0),
      imageUrl: podcast.artworkSmall,
      height: 50.0,
      width: 50.0,
      fit: BoxFit.fitWidth,
    );
  }

  Widget _buildSubtitle() {
    switch(playerState) {
      case player.PlayerState.Playing:
      case player.PlayerState.Paused:
        return new Text('${_getFriendlyDuration(duration)} / ${episode.duration}');
      case player.PlayerState.Completed:
        return new Text('Completed');
      case player.PlayerState.Buffering:
        return new Text('Buffering...');
    }

    return new Text('Select an episode to to play');
  }

  Widget _buildTrailing() {
    if (playerState == player.PlayerState.Playing) {
      return new IconButton(
        color: Color.fromARGB(255, 56, 56, 56),
        icon: new Icon(Icons.pause),
        onPressed: () { _player.pause(); },
      );
    }

    return new IconButton(
      color: Color.fromARGB(255, 56, 56, 56),
      icon: new Icon(Icons.play_arrow),
      onPressed: () { _player.resume(); },
    );
  }
}
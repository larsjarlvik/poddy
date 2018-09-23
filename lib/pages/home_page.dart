import 'package:flutter/material.dart';
import 'package:poddy/components/podcast_tile.dart';
import 'package:poddy/models/podcast.dart';
import 'package:poddy/pages/podcast_page.dart';

import 'package:poddy/storage/subscriptions.dart';

class HomePage extends StatefulWidget {
  final podcasts = readSubscriptions();

  HomePage();

  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {

  // State
  var podcasts = new List<Podcast>();
  
  getSubscriptions() async {
    podcasts = await readSubscriptions();
  }

  HomePageState() {
    podcasts = [];
    getSubscriptions();
  }

  showPodcast(Podcast result) {
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: (
        GridView.builder(
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3
          ),
          itemCount: podcasts.length,
          itemBuilder: (BuildContext context, int index) {
            return podcastTile(podcasts[index]);
          },
        )
      )
    );
  }
}
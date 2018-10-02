import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:poddy/api/feed.dart';
import 'package:poddy/models/podcast.dart';

const String _fileName = 'subscriptions.json';

Future<File> get _localFile async {
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  return new File('$path/$_fileName');
}

addSubscription(Podcast podcast) async {
  final existing = await readSubscriptions();
  existing.add(podcast);

  final encoded = json.encode(existing);
  final file = await _localFile;
  await file.writeAsString(encoded);
}

removeSubscription(Podcast podcast) async {
  final existing = await readSubscriptions();
  existing.remove(existing.firstWhere((s) => s.id == podcast.id));

  final encoded = json.encode(existing);
  final file = await _localFile;
  await file.writeAsString(encoded);
}

updateSubscription(Podcast podcast) async {
  try {
    final existing = await readSubscriptions();
    final index = existing.indexWhere((s) => s.id == podcast.id);

    existing[index] = podcast;

    final encoded = json.encode(existing);
    final file = await _localFile;
    await file.writeAsString(encoded);
  } catch (e) {
    print('Failed to update ${podcast.feedUrl}');
  }
}

Future<List<Podcast>> readSubscriptions() async {
  final file = await _localFile;
  final exists = await file.exists();

  if (!exists) return new List<Podcast>();

  final encoded = await file.readAsString();
  Iterable podcasts = json.decode(encoded);
  final mapped = podcasts.map((final p) => Podcast.fromJson(p)).toList();

  return mapped;
}

Future<bool> containsPodcast(Podcast podcast) async {
  final subscriptions = await readSubscriptions();
  return subscriptions.any((s) => s.id == podcast.id);
}

Future refreshPodcast(Podcast podcast) async {
  final updated = await fetchPodcast(podcast);
  await updateSubscription(updated);
}

Future refreshPodcasts() async {
  final subscriptions = await readSubscriptions();
  await Future.wait(subscriptions.map((s) => refreshPodcast(s)));
}

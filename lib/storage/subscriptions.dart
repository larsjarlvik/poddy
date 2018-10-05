import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:poddy/api/feed.dart';
import 'package:poddy/models/podcast.dart';

_encode(Podcast podcast) {
  return json.encode(podcast);
}

_decode(String podcast) {
  return json.decode(podcast);
}

Future<File> getFile(Podcast podcast) async {
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  return new File('$path/sub_${podcast.id}.json');
}

Future<List<File>> listSubscriptions() async {
  final directory = await getApplicationDocumentsDirectory();
  final files = directory.list();

  return files
    .where((s) => s is File && s.path.contains('sub_'))
    .map((s) => s as File)
    .toList();
}

addSubscription(Podcast podcast) async {
  final exists = await containsPodcast(podcast);
  if (exists) {
    return;
  }

  final encoded = await compute(_encode, podcast);
  final file = await getFile(podcast);
  await file.writeAsString(encoded);
}

removeSubscription(Podcast podcast) async {
  final exists = await containsPodcast(podcast);
  if (!exists) {
    return;
  }

  final file = await getFile(podcast);
  file.delete();
}

updateSubscription(Podcast podcast) async {
  try {
    final file = await getFile(podcast);
    final encoded = await compute(_encode, podcast);
    await file.writeAsString(encoded);
  } catch (e) {
    print('Failed to update ${podcast.feedUrl}');
  }
}

Future<Podcast> readSubscription(Podcast podcast) async {
  final file = await getFile(podcast);
  return await _readSubscription(file);
}

Future<Podcast> _readSubscription(File file) async {
  final encoded = await file.readAsString();
  final decoded = await compute(_decode, encoded);
  return Podcast.fromJson(decoded);
}

Future<List<Podcast>> readSubscriptions() async {
  final files = await listSubscriptions();
  final mapped = new List<Podcast>();

  for (final f in files) {
    mapped.add(await _readSubscription(f));
  }

  return mapped;
}

Future<bool> containsPodcast(Podcast podcast) async {
  final subscriptions = await listSubscriptions();
  final file = await getFile(podcast);

  return subscriptions.where((s) => s.path == file.path).length > 0;
}

Future refreshPodcast(Podcast podcast) async {
  final updated = await fetchPodcast(podcast);
  await updateSubscription(updated);
}

Future refreshPodcasts() async {
  final subscriptions = await readSubscriptions();
  await Future.wait(subscriptions.map((s) => refreshPodcast(s)));
}

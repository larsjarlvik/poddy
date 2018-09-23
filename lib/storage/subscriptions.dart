import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
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

  file.writeAsString(encoded);
}

removeSubscription(Podcast podcast) async {
  final existing = await readSubscriptions();
  existing.remove(existing.firstWhere((s) => s.id == podcast.id));

  final encoded = json.encode(existing);
  final file = await _localFile;

  file.writeAsString(encoded);
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

